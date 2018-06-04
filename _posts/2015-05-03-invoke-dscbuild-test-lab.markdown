---
title: Invoke-DscBuild \| Test-Lab
modified:
excerpt:
tags: [TestLab]
date: 2015-05-03T00:00:00-05:00
---
### Posts in This series

1. [Test-HomeLab -InputObject "The Plan"]({% post_url 2015-04-27-test-homelab-inputobject-the-plan %})
2. [Get-Posh-Git \| Test-Lab]({% post_url 2015-04-30-Get-Posh-Git-Test-Lab %})
3. [Get-DSCFramework \| Test-Lab]({% post_url 2015-05-02-get-dscframework-test-lab %})
4. Invoke-DscBuild \| Test-Lab (This Post)
5. [Test-Lab \| Update-GitHub]({% post_url 2015-05-06-test-lab-update-github %})

In the last post we forked a copy of the Powershell.org DSC tools and cloned a copy locally

Today I’m going to get the example configuration working.

Now looking at the README.md under examples seems straightforward, but I know for a fact that it’s missing a few steps.

 This folder contains some very basic examples of what a DSC configurationData folder structure, script, and call to Invoke-DscBuild might look like.  If you want to execute SampleBuild.ps1, there are a few dependencies you need to set up ahead of time:

  1. You must install all of the DSC tooling modules from this repository into your PSModulePath (typically into C:\Program Files\WindowsPowerShell\Modules\)
  2. You must also copy the Tooling\Examples\SampleConfiguration folder to the PSModulePath.
  3. You must copy [Pester](https://github.com/pester/Pester) (version 3.0.0 or later) and [ProtectedData](https://github.com/dlwyatt/ProtectedData) (version 2.1 or later) into the PSModulePath.
  4. You should create a DSC_Resources folder in the same directory as SampleBuild.ps1 and DSC_Configuration.  Copy the following modules into that DSC_Resources folder:
  5. [StackExchangeResources](https://github.com/PowerShellOrg/StackExchangeResources)
  6. [cWebAdministration](https://github.com/PowerShellOrg/cWebAdministration)
  7. [cSmbShare](https://github.com/PowerShellOrg/cSmbShare)

Once these dependencies are set up, you can execute SampleBuild.ps1.  It will run tests against the 3 modules in your DSC_Resources folder, compile your configuration into MOF documents, produce zip files for the resource modules, generate checksums for everything and copy them into C:\Program Files\WindowsPowerShell\DscService\

Looks like we are going to need a few more DSC resources. I’m going to go and fork/clone them just like before. (don’t forget to update the URL’s to match your own fork. )

```	powershell
# Download required files via Git
#Next line not needed if you were following along with my last blog
git clone https://github.com/BladeFireLight/DSC.git c:\GitHub\PshOrgDSC --branch development
git clone https://github.com/BladeFireLight/StackExchangeResources.git c:\GitHub\StackExchangeResources
git clone https://github.com/BladeFireLight/cWebAdministration.git c:\GitHub\cWebAdministration
git clone https://github.com/BladeFireLight/cSmbShare.git c:\GitHub\cSmbShare
git clone https://github.com/BladeFireLight/Pester c:\GitHub\Pester
git clone https://github.com/BladeFireLight/ProtectedData.git c:\GitHub\ProtectedData
```

Now I’m going to create some folder structure and place all the files where they need to go

```	powershell
#Create Folders
mkdir c:\DSC
mkdir C:\DSC\BuldOutput
mkdir C:\DSC\DSC_Configuration
mkdir C:\DSC\DSC_Resources
mkdir C:\DSC\DSC_Script
mkdir C:\DSC\DSC_Tooling

#Copy Files
copy C:\github\PshOrgDSC\Tooling\* C:\DSC\DSC_Tooling\ -Exclude 'examples', 'readme.md' -Recurse
copy C:\github\PshOrgDSC\Tooling\* 'C:\Program Files\WindowsPowerShell\Modules' -Exclude 'examples', 'readme.md' -Recurse
copy C:\github\* 'C:\Program Files\WindowsPowerShell\Modules' -Include 'Pester','ProtectedData' -Recurse
copy C:\github\* C:\DSC\DSC_Tooling\ -Include 'Pester','ProtectedData' -Recurse
copy C:\github\PshOrgDSC\Tooling\Examples\SampleBuild.ps1 c:\dsc\SampleBuild.ps1
copy c:\github\* C:\DSC\DSC_Resources -Include 'cSmbShare', 'cWebAdministration', 'StackExchangeResources' -Recurse
copy c:\github\* 'C:\Program Files\WindowsPowerShell\Modules' -Include 'cSmbShare', 'cWebAdministration', 'StackExchangeResources' -Recurse
copy C:\github\PshOrgDSC\Tooling\Examples\DSC_Configuration\* C:\DSC\DSC_Configuration -Recurse
copy C:\github\PshOrgDSC\Tooling\Examples\* C:\DSC\DSC_Script -Include 'SampleConfiguration' -Recurse

#delete unneeded folders.
dir -Path c:\dsc -Include '.git' -Recurse | del -Recurse -Force #-Confirm:$false
dir -Path 'C:\Program Files\WindowsPowerShell\Modules' -Include '.git' -Recurse | del -Recurse -Force
```

Then result should give us a folder structure like this

~~~
C:\DSC
├───BuldOutput
├───DSC_Configuration
│   ├───AllNodes
│   ├───Services
│   └───SiteData
├───DSC_Resources
│   ├───cSmbShare
│   │   └───DscResources
│   │       └───PSHOrg_cSmbShare
│   ├───cWebAdministration
│   │   ├───DSCResources
│   │   │   ├───PSHOrg_cAppPool
│   │   │   └───PSHOrg_cWebsite
│   │   └───Examples
│   └───StackExchangeResources
│       ├───DSCResources
│       │   ├───StackExchange_CertificateStore
│       │   ├───StackExchange_FirewallRule
│       │   ├───StackExchange_NetworkAdapter
│       │   ├───StackExchange_Pagefile
│       │   │   ├───StackExchange_en-US
│       │   │   └───StackExchange_nl-NL
│       │   ├───StackExchange_PowerPlan
│       │   │   └───StackExchange_en-US
│       │   ├───StackExchange_ScheduledTask
│       │   ├───StackExchange_SetExecutionPolicy
│       │   │   └───StackExchange_en-US
│       │   └───StackExchange_Timezone
│       └───test
│           ├───integration
│           │   └───StackExchange_PageFile
│           │       └───pester
│           └───unit
│               └───StackExchange_Pagefile
│                   └───pester
├───DSC_Script
│   └───SampleConfiguration
└───DSC_Tooling
    ├───cDscDiagnostics
    ├───cDscResourceDesigner
    ├───dscbuild
    ├───DscConfiguration
    ├───DscDevelopment
    ├───DscOperations
    ├───Pester
    │   ├───bin
    │   ├───en-US
    │   ├───Examples
    │   │   ├───Calculator
    │   │   └───Validator
    │   ├───Functions
    │   │   └───Assertions
    │   ├───Snippets
    │   └───vendor
    │       └───tools
    │           ├───OneGet
    │           │   └───Etc
    │           └───PowerShellGet
    │               └───en-US
    └───ProtectedData
        └───en-US

C:\PROGRAM FILES\WINDOWSPOWERSHELL\MODULES
├───cDscDiagnostics
├───cDscResourceDesigner
├───cSmbShare
│   └───DscResources
│       └───PSHOrg_cSmbShare
├───cWebAdministration
│   ├───DSCResources
│   │   ├───PSHOrg_cAppPool
│   │   └───PSHOrg_cWebsite
│   └───Examples
├───dscbuild
├───DscConfiguration
├───DscDevelopment
├───DscOperations
├───Pester
│   ├───bin
│   ├───en-US
│   ├───Examples
│   │   ├───Calculator
│   │   └───Validator
│   ├───Functions
│   │   └───Assertions
│   ├───Snippets
│   └───vendor
│       └───tools
│           ├───OneGet
│           │   └───Etc
│           └───PowerShellGet
│               └───en-US
├───ProtectedData
│   └───en-US
└───StackExchangeResources
    ├───DSCResources
    │   ├───StackExchange_CertificateStore
    │   ├───StackExchange_FirewallRule
    │   ├───StackExchange_NetworkAdapter
    │   ├───StackExchange_Pagefile
    │   │   ├───StackExchange_en-US
    │   │   └───StackExchange_nl-NL
    │   ├───StackExchange_PowerPlan
    │   │   └───StackExchange_en-US
    │   ├───StackExchange_ScheduledTask
    │   ├───StackExchange_SetExecutionPolicy
    │   │   └───StackExchange_en-US
    │   └───StackExchange_Timezone
    └───test
        ├───integration
        │   └───StackExchange_PageFile
        │       └───pester
        └───unit
            └───StackExchange_Pagefile
                └───pester
~~~

now lets fix C:\DSC\SampleBuild.ps1

~~~	powershell
end
{
    Import-Module Pester -ErrorAction Stop
    Import-Module dscbuild -ErrorAction Stop
    Import-Module dscconfiguration -ErrorAction Stop

    $params = @{
        WorkingDirectory = (Get-TempDirectory).FullName
        SourceResourceDirectory = "$PSScriptRoot\DSC_Resources"
        SourceToolDirectory = "$PSScriptRoot\DSC_Tooling"
        DestinationRootDirectory = "$PSScriptRoot\BuldOutput"
        DestinationToolDirectory = $env:TEMP
        ConfigurationData = Get-DscConfigurationData -Path "$PSScriptRoot\DSC_Configuration" -Force -verbose
        ModulePath = "$PSScriptRoot\DSC_Script"  , "$PSScriptRoot\DSC_Tooling"
        ConfigurationModuleName = 'SampleConfiguration'
        ConfigurationName = 'SampleConfiguration'
        Configuration = $true
        Resource = $true
    }

    Invoke-DscBuild @params -verbose
}

begin
{
    function Get-TempDirectory
    {
        [CmdletBinding()]
        [OutputType([System.IO.DirectoryInfo])]
        param ( )

        do
        {
            $tempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.IO.Path]::GetRandomFileName())
        }
        until (-not (Test-Path -Path $tempDir -PathType Container))

        return New-Item -Path $tempDir -ItemType Directory -ErrorAction Stop
    }
}
~~~

So what is different?


* DestinationRootDirectory = “$PSScriptRoot\BuldOutput”
    * Changed to point to a relative output. this is a test, so there is no need to place it into the common location for a pull server, although in production you may want to. I prefer to copy the files after a build, as it’s usually built on a machine other then the pull server
* ConfigurationData = Get-DscConfigurationData -Path “$PSScriptRoot\DSC_Configuration” -Force -verbose
    *added verbose so I can see how its progresses and help with troubleshooting
* ModulePath = “$PSScriptRoot\DSC_Script”  , “$PSScriptRoot\DSC_Tooling”
    * This is the big one. ModulePath and SourceResourceDirectory are going to be the only path’s in $psmodulepath when the configuration module (the module referenced by ConfigurationModuleName ) is loaded and when the configuration in ConfigurationName  is executed. This feature was added to resolve a problem when your modules used to build .mof files may be newer then the ones used to configure the machine running them. Something I ran into and Dave Wyatt was kind enough to solve
* Invoke-DscBuild @params -verbose
    *Added -verbose. I’m a bit of a verbose junky.

With the updates to SampleBuild.ps1 we are ready to build our first sample set of .mof files

I do this in a clean environment so I’m opening PowerShell as an administrator and running C:\DSC\SampleBuild.ps1. After a long bit of scrolling if it works the last few lines should look like this.

~~~
VERBOSE: Moving 718aec80-e8fe-41b5-ac31-fbcd5d0186b1.mof to C:\DSC\BuldOutput\Configuration
VERBOSE: Moving b4519959-9724-40d5-ab62-5c4f82bbcd80.mof to C:\DSC\BuldOutput\Configuration
VERBOSE: Moving fc107c0b-1fc8-45fb-9991-a0a1f0fd6c21.mof to C:\DSC\BuldOutput\Configuration
~~~

Congratulations you have your first set of .mof files working with the PowerShell.org DSC tools.

Next up. Creating a pull request to update the readme.md and SampleBuild.ps1