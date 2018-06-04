---
title: Windows Image Tools \| Creating an Updated Image Part 2
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-09-01T16:48:59-05:00
---

## Plan for today

Windows Management Framework contains PowerShell. You should always run the latest supported in your environment, and it's a good idea to get your hands on the preview and give it test run. I want my 2012r2 servers to be running WMF 5.0 the current stable realease.

Now I could install 5.1 preview, but as it has to be uninstalled when the final get's released, so I'm going to pass for now.

## Prerequisites  

If you folowing along you will need the WindowsImageTools update folder and two VHDX created in the last blog

## Updating WMF

Using Update-WindowsImageWMF we will download WMF 5.0 and .net 4.6. 

``` powershell 
PS G:\> Update-WindowsImageWMF -Path G:\Blog_Example\ -ImageName Srv2012r2_Core -Verbose
```

First it's going to create a child vhdx so we can revert if things go south

``` powershell
VERBOSE: Performing the operation "Update WMF in Windows Image Tools Update Image" on target
"G:\Blog_Example\\BaseImage\Srv2012r2_Core_Base.vhdx".
VERBOSE: [Update-WindowsImageWMF] : Creating G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx from
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Base.vhdx
```

Then it's going to download the installer packages

``` 
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF in G:\Blog_Example\\Resource\WMF\5
VERBOSE: GET https://www.microsoft.com/en-us/download/details.aspx?id=50395 with 0-byte payload
VERBOSE: received 107311-byte response of content type text/html
VERBOSE: GET http://www.microsoft.com/en-us/download/confirmation.aspx?id=50395 with 0-byte payload
VERBOSE: received -1-byte response of content type text/html
WARNING: [Update-WindowsImageWMF] : Checking for the latest WMF : W2K12-KB3134759-x64.msu Missing, Downloading
VERBOSE: GET https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu
 with 0-byte payload
VERBOSE: received 21540661-byte response of content type application/octet-stream
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF :
G:\Blog_Example\\Resource\WMF\5\W2K12-KB3134759-x64.msu : Found
WARNING: [Update-WindowsImageWMF] : Checking for the latest WMF : Win7AndW2K8R2-KB3134760-x64.msu Missing, Downloading
VERBOSE: GET
https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu with
 0-byte payload
VERBOSE: received 21779572-byte response of content type application/octet-stream
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF :
G:\Blog_Example\\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu : Found
WARNING: [Update-WindowsImageWMF] : Checking for the latest WMF : Win7-KB3134760-x86.msu Missing, Downloading
VERBOSE: GET https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3134760-x86.msu
with 0-byte payload
VERBOSE: received 16961221-byte response of content type application/octet-stream
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF :
G:\Blog_Example\\Resource\WMF\5\Win7-KB3134760-x86.msu : Found
WARNING: [Update-WindowsImageWMF] : Checking for the latest WMF : Win8.1AndW2K12R2-KB3134758-x64.msu Missing,
Downloading
VERBOSE: GET
https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu
with 0-byte payload
VERBOSE: received 19764832-byte response of content type application/octet-stream
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF :
G:\Blog_Example\\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu : Found
WARNING: [Update-WindowsImageWMF] : Checking for the latest WMF : Win8.1-KB3134758-x86.msu Missing, Downloading
VERBOSE: GET
https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3134758-x86.msu with 0-byte
 payload
VERBOSE: received 15059790-byte response of content type application/octet-stream
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF :
G:\Blog_Example\\Resource\WMF\5\Win8.1-KB3134758-x86.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for .NET 4.6.1 installer
WARNING: [Update-WindowsImageWMF] : Checking for .NET 4.6 installer : Missing : Downloading
VERBOSE: GET
https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.e
xe with 0-byte payload
VERBOSE: received 67681000-byte response of content type application/octet-stream
```
{: .pre-wrap}

Now it will copy the .NET installer and an AtStartup.ps1 to run the install.

``` powershell
VERBOSE: [Update-WindowsImageWMF] : .NET : Adding installer to G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: [Update-WindowsImageWMF] : .NET : updateting AtStartup script
```
It is going to create a VM with a random name and wait for it to stop. 
While it's running the AtStartup script will install .net, reboot and check the version of .net
If it find's what it's expecting it creates a file that Update-WindowsImageWMF will look for to decide if it can continue. 

``` powershell
VERBOSE: [Update-WindowsImageWMF] : .NET : Creating temp vm and waiting
VERBOSE: [createRunAndWaitVM] : Creating VM s4gzlpa4 at 09/22/2016 16:54:47
VERBOSE: [createRunAndWaitVM] : VM s4gzlpa4 Stoped
VERBOSE: [createRunAndWaitVM] : VM s4gzlpa4 Deleted at 09/22/2016 17:12:52
```

You cant use PowerShell to WMF because that updates PowerShell. So It will apply the MSU to the VHDX.
Now because Update-WindowsImageWMF does not know what OS is inside the vhdx. It will apply them all. Unfortunetly DISM (that does the work) reports succses when the MSU does not apply to that version of the OS. So it looks like all of the are installing but only the one that should actualy does.

```powershell
VERBOSE: [Update-WindowsImageWMF] : WMF : Applying WMF to G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx and
Updating AtStartup script
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu applies to
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu applies to
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu applies to
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu applies to
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu applies to
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu
```
{: .pre-wrap}

To finalize the install Update-WindowsImageWMF needs to create a vm and let it finish installing then run a AtStartup script to check the version of PowerShell to validate the install worked. and if so write a flag file.

``` powershell
VERBOSE: [Update-WindowsImageWMF] : WMF : creating temp VM to finalize install on
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: [createRunAndWaitVM] : Creating VM yary1ogs at 09/22/2016 17:15:55
VERBOSE: [createRunAndWaitVM] : VM yary1ogs Stoped
VERBOSE: [createRunAndWaitVM] : VM yary1ogs Deleted at 09/22/2016 17:18:17
```

If the flag file is detected then the child vhdx is merged back into the base. if not the child file id discarded and an error thrown

``` powershell
VERBOSE: [Update-WindowsImageWMF] : WMF : Checking if changes made
VERBOSE: [Update-WindowsImageWMF] : WMF : Changes found : Merging G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
 into G:\Blog_Example\\BaseImage\Srv2012r2_Core_Base.vhdx
```

I'm going to run the same command again on the other vhdx 

``` powershell
Update-WindowsImageWMF -Path G:\Blog_Example\ -ImageName Srv2012r2_Source -Verbose
VERBOSE: Performing the operation "Update WMF in Windows Image Tools Update Image" on target "G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx".
VERBOSE: [Update-WindowsImageWMF] : Creating G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx from G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF in G:\Blog_Example\\Resource\WMF\5
VERBOSE: GET https://www.microsoft.com/en-us/download/details.aspx?id=50395 with 0-byte payload
VERBOSE: received 107378-byte response of content type text/html
VERBOSE: GET http://www.microsoft.com/en-us/download/confirmation.aspx?id=50395 with 0-byte payload
VERBOSE: received -1-byte response of content type text/html
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\W2K12-KB3134759-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\W2K12-KB3134759-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win7-KB3134760-x86.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win7-KB3134760-x86.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win8.1-KB3134758-x86.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for the latest WMF : G:\Blog_Example\\Resource\WMF\5\Win8.1-KB3134758-x86.msu : Found
VERBOSE: [Update-WindowsImageWMF] : Checking for .NET 4.6.1 installer
VERBOSE: [Update-WindowsImageWMF] : .NET : Adding installer to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: [Update-WindowsImageWMF] : .NET : updateting AtStartup script
VERBOSE: [Update-WindowsImageWMF] : .NET : Creating temp vm and waiting
VERBOSE: [createRunAndWaitVM] : Creating VM dkdjxvqm at 09/23/2016 08:56:23
VERBOSE: [createRunAndWaitVM] : VM dkdjxvqm Stoped
VERBOSE: [createRunAndWaitVM] : VM dkdjxvqm Deleted at 09/23/2016 09:12:39
VERBOSE: [Update-WindowsImageWMF] : WMF : Applying WMF to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx and Updating AtStartup script
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu applies to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu applies to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu applies to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu applies to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu
VERBOSE: checking if G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu applies to G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: Target Image Version 6.3.9600.17031
VERBOSE: Successfully added package G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu
VERBOSE: [Update-WindowsImageWMF] : WMF : creating temp VM to finalize install on G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: [createRunAndWaitVM] : Creating VM e5h2cc34 at 09/23/2016 09:15:50
VERBOSE: [createRunAndWaitVM] : VM e5h2cc34 Stoped
VERBOSE: [createRunAndWaitVM] : VM e5h2cc34 Deleted at 09/23/2016 09:18:25
VERBOSE: [Update-WindowsImageWMF] : WMF : Checking if changes made
VERBOSE: [Update-WindowsImageWMF] : WMF : Changes found : Merging G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx into G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx
```
{: .pre-wrap}

Now I'm going to quickly check to make sure this worked. I dont want to make any changes to the drive as it is so I will create a child vhdx and boot it.

``` powershell
New-VHD -Path G:\Blog_Example\BaseImage\Srv2012r2_Core_temp.vhdx -ParentPath G:\Blog_Example\BaseImage\Srv2012r2_Core_base.vhdx
Invoke-CreateVmRunAndWait -VhdPath G:\Blog_Example\\BaseImage\Srv2012r2_Core_temp.vhdx 
Remove-Item G:\Blog_Example\\BaseImage\Srv2012r2_Core_temp.vhdx 
```
{: .pre-wrap}

checking the psversion table we see what is expected.

![PowerShell Version Table]({{ site.url }}\assets\images\PS5Version.JPG)

**Dealing with 2008/Win7**  WMF 5 on 2008 and Win7 need a few patches after WMF 4 is installed. So You want to run windows update before installing WMF 5
{: .notice--info}

Next up. Windows update and output of WIM/VHDX
