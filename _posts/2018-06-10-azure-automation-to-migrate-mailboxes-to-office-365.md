---
layout: single
title: Azure Automation to Migrate Mailboxes to Office 365
date: 2018-06-07 21:18 -0500
categories: [Nuggets]
tags: [Azure, Office 365]
---
**Note** Some code blocks on this page have word wrap turned on. 
{: .notice--info}
## The problem

While azure automation is a powerfull platform. 
It has some limitations in PowerShell that makes working with Exchange online dificult.
The main issue is the inability to use [Import-PsSession](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-pssession?view=powershell-6).
This can be gotten arround with some creative use of variables.

## The goal

I recently had to setup a way to the helpdesk to be able to migrate users to the cloud without giving them rights in exchange or a complicated interface.
The moves would need to be both directions and they needed a way to check on the status of the move. 
Azure automation seemed like a good fit. 

## Show me some code

Now I started with some colecting the paramerters, connecting to Azure so I can retrive the credentials from the azure credential store.
This part was fairly strait forward.

**Note** that I did not make the Identity paramater as an array like you would normaly do in an advanced function.
This is because I wanted to use Flow on the front end and it's Email selction returns a string of ; seporated email addresses. 
{: .notice--warning}

### Param and connecting to Azure
``` powershell 
[CmdletBinding( 
    SupportsShouldProcess = $true, 
    PositionalBinding = $true,
    ConfirmImpact = 'Medium')]
  
Param
(
    # UPN or Email address
    [Parameter(
        Mandatory = $true, 
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true, 
        Position = 0,
        HelpMessage = "UPN or Email address"
    )]
    [string]
    $Identity,

    [Parameter(
        Position = 1,
        HelpMessage = "Migration Direction : ToCloud or ToExchange"
    )]
    [ValidateSet("ToCloud", "ToExchange")] 
    [string]
    $Direction = 'ToCloud'
)


$CredName = '365MigrationCredName'
$connectionName = "AzureRunAsConnection"

$IdentityList = @()
$IdentityList = $Identity -split ';'

try {
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    Write-verbose "Logging in to Azure..." -Verbose
    $AzureRmAccountParam = @{
        ServicePrincipal = $true
        TenantId = $servicePrincipalConnection.TenantId
        ApplicationId = $servicePrincipalConnection.ApplicationId
        CertificateThumbprint = $servicePrincipalConnection.CertificateThumbprint
    }
    $null = Add-AzureRmAccount @AzureRmAccountParam
}
catch {
    if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    }
    else {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
```
{: .pre-wrap}


When working with mailbox migrations in PowerShell you have to use two diferent credentials. 
One for office 365 in the user@domain format and one for Exchange using the domain/username format. 
In my case this was the same user syncronized between on-premises AD and Azure AD. 
For this reason I only need one credential and only the basic username needs to be stored.
I will create the two credentials from it.

### Retriveing credentials
``` powershell
Write-verbose "Getting Credentials ..." -Verbose
$Credential = Get-AutomationPSCredential -Name $CredName
Write-verbose  "Credential Loaded : $($Credential.UserName)" -Verbose
if (($Credential.UserName -like "*@*") -or ($Credential.UserName -like "*\*")) {
    Throw "Credential username must be the username only!. do not include the domain"
}

$o365Cred = New-Object System.Management.Automation.PSCredential ("$($Credential.UserName)@mydomain.com", $Credential.Password)
$exchCred = New-Object System.Management.Automation.PSCredential ("mydomain\$($Credential.UserName)", $Credential.Password)
Write-verbose  "Credential Loaded : $($o365Cred.UserName)" -Verbose
Write-verbose  "Credential Loaded : $($exchCred.UserName)" -Verbose
```
{: .pre-wrap}

Now I'm going to connect to office 365.

``` powershell
Write-verbose 'Connecting to office365 ...' -Verbose
$OnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'https://outlook.office365.com/powershell-liveid/' -Authentication Basic -Credential $o365Cred -ErrorAction Stop
Write-verbose 'Importing PowerShell Commands ...' -Verbose
#Import-PSSession -Prefix "Online" $OnlineSession
```
{: .pre-wrap}
Notice that the import sesion is commented out.
That is becuase implicit remoteing is disable or not functional in Azure Automation at the time of this writing. 
Please [up vote the issue](https://feedback.azure.com/forums/246290-automation/suggestions/13797918-enable-implicit-remoting) 

I will loop through the identity list
``` powershell
Foreach ($user in $IdentityList) {
```

With Import-PSSession out, and [Import-Module](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Import-Module?view=powershell-6)(Import-PSSession ...) being flaky at best.
I have to fall back to [Invoke-Command](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Invoke-Command?view=powershell-6)
I'm going to start with checking if the mailbox exists in the cloud with [Get-Mailbox](https://docs.microsoft.com/en-us/powershell/module/exchange/mailboxes/get-mailbox?view=exchange-ps).

``` powershell
$Mailbox = Invoke-Command -Session $OnlineSession -ScriptBlock { param($user) Get-Mailbox -Identity $user -ErrorAction SilentlyContinue }-ArgumentList $user
```
{: .pre-wrap}

Now check the direction and start the mailbox move if it's not allready there. 
``` powershell
if (-not ($MailBox) -and ($Direction -eq 'ToCloud')) { 
    "Migrating To Cloud : $user"
    ## Migration to cloud command ##
    }
elseif (($MailBox) -and ($Direction -eq 'ToExchange')) {
    "Migrating To Exchange : $user to $database"
    ## Migration to Exchange comamnd ##
    }
else {
    Write-Warning "Mailbox for $User already exists Destination : Skiping"
}
```
{: .pre-wrap}

Migrateing to the cloud the comamnd is fairly strait forward. 
I need to pass values to [New-MoveRequest](https://docs.microsoft.com/en-us/powershell/module/exchange/move-and-migration/new-moverequest?view=exchange-ps) so I have to Paramaterize the script block and use -ArgumentList.
Format-List is to reduce the amount of data outlput. 
I dont need all of it.

``` powershell
$ScriptBlock = {
    param([PSCredential]$exchCred, $user)
    $MoveRequestParam = @{
        Remote = $true
        RemoteHostName = 'mail.mydomain.com' # your exchange servers external URL for EWS
        RemoteCredential = $exchCred
        TargetDeliveryDomain = 'mydomain.mail.onmicrosoft.com' # Your *.mail.onmicrosoft.com domain
        Identity = $user
    }  
    New-MoveRequest @MoveRequestParm
}
Invoke-Command -Session $OnlineSession -ScriptBlock $ScriptBlock -ArgumentList $exchCred, $user | Format-List DisplayName, QueuedTimestamp
```
{: .pre-wrap}

Migrateing back to exchange is a little more involved but not by much

If your wondering why I would want to migrate back to exchange. Mistakes do happen, a users that is not ready for migraiton might accendently get moved
{: .notice--info}

``` powershell
$databaseBaseName = 'db'
$databaseMaxNumber = 24
#randomly pick a target DB
$database = "$databaseBaseName$((get-random -Minimum 1 -Maximum $databaseMaxNumber).ToString("00"))"
"Migrating To Exchange : $user to $database"
$scriptBlock = {
    param([PSCredential]$exchCred, $user, $database)  
    $MoveRequesParm = @{
        Outbound = $true
        RemoteHostName = 'mail.mydomain.com' # your exchange servers external URL for EWS
        RemoteCredential = $exchCred
        TargetDeliveryDomain = 'mydomain.com' # your onprem email domain
        Identity = $user
        RemoteTargetDatabase = $database
    }
    New-MoveRequest @MoveRequesParm
}
Invoke-Command -Session $OnlineSession -ScriptBlock $scriptblock  -ArgumentList $exchCred, $user, $database | Format-List DisplayName, QueuedTimestamp
```
{: .pre-wrap}

And there you have the basic's of the migration. Next up is checking the status.