---
title: Windows Image Tools \| Creating an Updated Image Part 3
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-10-12T16:48:59-05:00
---

## Plan for today

The end game is in site. Now that I have 2 images with WMF 5. it's time to apply all the Windows Updates. 

## Prerequisites

If you are folowing along you shoudl have a WindowsImageTools Update directory with two images. A striped down Core image, and all you can eat GUI image for source.

## Kicking off Updates

First off I'm going to run the updates. There are a nubmer of ways to do this, Invoke-WindowsUpdate can target individual images or all the images in our Update folders, and it can control the output.
Because i'm doing source and small core images. I will update each image separately, and export the WIM only for the source, and shrink the Core

Lets start with the source

``` powershell
get-date
Invoke-WindowsImageUpdate -Path G:\Blog_Example -output Both -ImageName Srv2012r2_Core -ReduceImageSize -Verbose
get-date
Invoke-WindowsImageUpdate -Path G:\Blog_Example -output WIM -ImageName Srv2012r2_Source -Verbose
get-date
```

``` 
Wednesday, October 12, 2016 12:26:17 AM
VERBOSE: [Invoke-WindowsImageUpdate] : Validateing [Srv2012r2_Core]
VERBOSE: [Invoke-WindowsImageUpdate] : Validateing VM switch config
VERBOSE: Performing the operation "Download required Modules" on target "PowerShell Gallery".
VERBOSE: Loading module from path 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1\PackageManagement.psd1'.
VERBOSE: Loading 'FormatsToProcess' from path 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1\PackageManagement.format.ps1xml'.
VERBOSE: Loading module from path 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1\Microsoft.PowerShell.PackageManagement.dll'.
VERBOSE: Exporting cmdlet 'Find-Package'.
VERBOSE: Exporting cmdlet 'Get-Package'.
VERBOSE: Exporting cmdlet 'Get-PackageProvider'.
VERBOSE: Exporting cmdlet 'Get-PackageSource'.
VERBOSE: Exporting cmdlet 'Install-Package'.
VERBOSE: Exporting cmdlet 'Import-PackageProvider'.
VERBOSE: Exporting cmdlet 'Find-PackageProvider'.
VERBOSE: Exporting cmdlet 'Install-PackageProvider'.
VERBOSE: Exporting cmdlet 'Register-PackageSource'.
VERBOSE: Exporting cmdlet 'Save-Package'.
VERBOSE: Exporting cmdlet 'Set-PackageSource'.
VERBOSE: Exporting cmdlet 'Uninstall-Package'.
VERBOSE: Exporting cmdlet 'Unregister-PackageSource'.
VERBOSE: Importing cmdlet 'Find-Package'.
VERBOSE: Importing cmdlet 'Find-PackageProvider'.
VERBOSE: Importing cmdlet 'Get-Package'.
VERBOSE: Importing cmdlet 'Get-PackageProvider'.
VERBOSE: Importing cmdlet 'Get-PackageSource'.
VERBOSE: Importing cmdlet 'Import-PackageProvider'.
VERBOSE: Importing cmdlet 'Install-Package'.
VERBOSE: Importing cmdlet 'Install-PackageProvider'.
VERBOSE: Importing cmdlet 'Register-PackageSource'.
VERBOSE: Importing cmdlet 'Save-Package'.
VERBOSE: Importing cmdlet 'Set-PackageSource'.
VERBOSE: Importing cmdlet 'Uninstall-Package'.
VERBOSE: Importing cmdlet 'Unregister-PackageSource'.
VERBOSE: [Invoke-WindowsImageUpdate] : Geting latest PSWindowsUpdate
VERBOSE: Using the provider 'PowerShellGet' for searching packages.
VERBOSE: The -Repository parameter was not specified.  PowerShellGet will use all of the registered repositories.
VERBOSE: Getting the provider object for the PackageManagement Provider 'NuGet'.
VERBOSE: The specified Location is 'https://www.powershellgallery.com/api/v2/' and PackageManagementProvider is 'NuGet'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='PSWindowsUpdate'' for ''.
VERBOSE: Total package yield:'1' for the specified package 'PSWindowsUpdate'.
VERBOSE: Performing the operation "Save Package" on target "'PSWindowsUpdate' to location 'G:\Blog_Example\Resource\Modules'".
VERBOSE: The specified module will be installed in 'G:\Blog_Example\Resource\Modules'.
VERBOSE: The specified Location is 'NuGet' and PackageManagementProvider is 'NuGet'.
VERBOSE: Downloading module 'PSWindowsUpdate' with version '1.5.2.2' from the repository 'https://www.powershellgallery.com/api/v2/'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='PSWindowsUpdate'' for ''.
VERBOSE: InstallPackage' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\239759536'
VERBOSE: DownloadPackage' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\239759536\PSWindowsUpdate\PSWindowsUpdate.nupkg', uri='https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'
VERBOSE: Downloading 'https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'.
VERBOSE: Completed downloading 'https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'.
VERBOSE: Completed downloading 'PSWindowsUpdate'.
VERBOSE: Hash for package 'PSWindowsUpdate' does not match hash provided from the server.
VERBOSE: InstallPackageLocal' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\239759536'
VERBOSE: Module 'PSWindowsUpdate' was saved successfully to path 'G:\Blog_Example\Resource\Modules\PSWindowsUpdate\1.5.2.2'.
VERBOSE: Performing the operation "Invoke Windows Updates on Image" on target "Srv2012r2_Core".
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : New Diff Disk : Creating G:\Blog_Example\BaseImage\Srv2012r2_Core_Update.vhdx from G:\Blog_Example\BaseImage\Srv2012r2_Core_base.vhdx
VERBOSE: New-VHD will create a new virtual hard disk with the path "G:\Blog_Example\BaseImage\Srv2012r2_Core_Update.vhdx".
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : Adding PSWindowsUpdate Module to G:\Blog_Example\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : updateting AtStartup script
VERBOSE: Sidebyside detected in PSWindowsUpdate : switching to v4 compatability
VERBOSE: [createRunAndWaitVM] : Creating VM 40floaow at 10/12/2016 00:26:34
VERBOSE: [createRunAndWaitVM] : VM 40floaow Stoped
VERBOSE: [createRunAndWaitVM] : VM 40floaow Deleted at 10/12/2016 02:25:36
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : Changes detected : Merging G:\Blog_Example\BaseImage\Srv2012r2_Core_Update.vhdx into G:\Blog_Example\BaseImage\Srv2012r2_Core_base.vhdx
VERBOSE: Merge-VHD will merge the virtual hard disk "g:\blog_example\baseimage\srv2012r2_core_update.vhdx" into its parent "g:\blog_example\baseimage\srv2012r2_core_base.vhdx".
Wednesday, October 12, 2016 2:28:08 AM
VERBOSE: [Invoke-WindowsImageUpdate] : Validateing [Srv2012r2_Source]
VERBOSE: [Invoke-WindowsImageUpdate] : Validateing VM switch config
VERBOSE: Performing the operation "Download required Modules" on target "PowerShell Gallery".
VERBOSE: [Invoke-WindowsImageUpdate] : Geting latest PSWindowsUpdate
VERBOSE: Using the provider 'PowerShellGet' for searching packages.
VERBOSE: The -Repository parameter was not specified.  PowerShellGet will use all of the registered repositories.
VERBOSE: Getting the provider object for the PackageManagement Provider 'NuGet'.
VERBOSE: The specified Location is 'https://www.powershellgallery.com/api/v2/' and PackageManagementProvider is 'NuGet'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='PSWindowsUpdate'' for ''.
VERBOSE: Total package yield:'1' for the specified package 'PSWindowsUpdate'.
VERBOSE: Performing the operation "Save Package" on target "'PSWindowsUpdate' to location 'G:\Blog_Example\Resource\Modules'".
VERBOSE: The specified module will be installed in 'G:\Blog_Example\Resource\Modules'.
VERBOSE: The specified Location is 'NuGet' and PackageManagementProvider is 'NuGet'.
VERBOSE: Downloading module 'PSWindowsUpdate' with version '1.5.2.2' from the repository 'https://www.powershellgallery.com/api/v2/'.
VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='PSWindowsUpdate'' for ''.
VERBOSE: InstallPackage' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\1874556358'
VERBOSE: DownloadPackage' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\1874556358\PSWindowsUpdate\PSWindowsUpdate.nupkg', uri='https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'
VERBOSE: Downloading 'https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'.
VERBOSE: Completed downloading 'https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/1.5.2.2'.
VERBOSE: Completed downloading 'PSWindowsUpdate'.
VERBOSE: Hash for package 'PSWindowsUpdate' does not match hash provided from the server.
VERBOSE: InstallPackageLocal' - name='PSWindowsUpdate', version='1.5.2.2',destination='C:\Users\Blade_000\AppData\Local\Temp\1874556358'
VERBOSE: Module 'PSWindowsUpdate' was saved successfully to path 'G:\Blog_Example\Resource\Modules\PSWindowsUpdate\1.5.2.2'.
VERBOSE: Performing the operation "Invoke Windows Updates on Image" on target "Srv2012r2_Source".
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : New Diff Disk : Creating G:\Blog_Example\BaseImage\Srv2012r2_Source_Update.vhdx from G:\Blog_Example\BaseImage\Srv2012r2_Source_base.vhdx
VERBOSE: New-VHD will create a new virtual hard disk with the path "G:\Blog_Example\BaseImage\Srv2012r2_Source_Update.vhdx".
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : Adding PSWindowsUpdate Module to G:\Blog_Example\BaseImage\Srv2012r2_Source_Update.vhdx
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : updateting AtStartup script
VERBOSE: Sidebyside detected in PSWindowsUpdate : switching to v4 compatability
VERBOSE: [createRunAndWaitVM] : Creating VM 5dvm2bu2 at 10/12/2016 02:28:24
VERBOSE: [createRunAndWaitVM] : VM 5dvm2bu2 Stoped
VERBOSE: [createRunAndWaitVM] : VM 5dvm2bu2 Deleted at 10/12/2016 05:30:56
VERBOSE: [Invoke-WindowsImageUpdate] : Windows Update : Changes detected : Merging G:\Blog_Example\BaseImage\Srv2012r2_Source_Update.vhdx into G:\Blog_Example\BaseImage\Srv2012r2_Source_base.vhdx
VERBOSE: Merge-VHD will merge the virtual hard disk "g:\blog_example\baseimage\srv2012r2_source_update.vhdx" into its parent "g:\blog_example\baseimage\srv2012r2_source_base.vhdx".
VERBOSE: [Invoke-WindowsImageUpdate] : SysPrep : New Diff Disk : Creating G:\Blog_Example\BaseImage\Srv2012r2_Source_Sysprep.vhdx from G:\Blog_Example\BaseImage\Srv2012r2_Source_base.vhdx
VERBOSE: New-VHD will create a new virtual hard disk with the path "G:\Blog_Example\BaseImage\Srv2012r2_Source_Sysprep.vhdx".
VERBOSE: [Invoke-WindowsImageUpdate] : SysPrep : updateting AtStartup script
VERBOSE: [Invoke-WindowsImageUpdate] : SysPrep : Creating temp vm and waiting
VERBOSE: [createRunAndWaitVM] : Creating VM 4nxvrw5x at 10/12/2016 05:34:45
VERBOSE: [createRunAndWaitVM] : VM 4nxvrw5x Stoped
VERBOSE: [createRunAndWaitVM] : VM 4nxvrw5x Deleted at 10/12/2016 05:41:37
VERBOSE: [Invoke-WindowsImageUpdate] : SysPrep : Removing PageFile and PsTemp
VERBOSE: [Invoke-WindowsImageUpdate] : SysPrep : Cleaning SxS
VERBOSE: [Invoke-WindowsImageUpdate] : WIM : Creating G:\Blog_Example\UpdatedImageShare\Srv2012r2_Source.wim
VERBOSE: [Invoke-WindowsImageUpdate] : WIM : removing G:\Blog_Example\BaseImage\Srv2012r2_Source_Sysprep.vhdx
Wednesday, October 12, 2016 6:19:52 AM
```
{: .pre-wrap}


After a few hours I have a a fully patched system.

```
G:\Blog_Example\UpdatedImageShare

    Directory: G:\Blog_Example\UpdatedImageShare

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        9/27/2016   3:24 PM     7541358592 Srv2012r2_Core.vhdx 
-a----        9/27/2016   3:14 PM     3415926982 Srv2012r2_Core.wim
-a----        9/26/2016   6:36 PM     4523302203 Srv2012r2_Source.wim  
```
