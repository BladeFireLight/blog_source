---
title: Windows Image Tools \| VHDX Creation
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-08-21T16:48:59-05:00
---

 ## Getting started

To automate the creation of clean VM's we need a clean diskimage. for that we will use Convert-Wim2VHD from WindowsImageTools

Before you can create a VHDX your going to need a source. either a WIM or ISO. In tha lab that would usually be a trial version. For work, the iso from your licencing portal, or heaven forbid a physical CD.

You can get an evaluation copy of windows from [TechNet Evaluation Center](https://www.microsoft.com/en-us/evalcenter)

I'm going to use a evaluation of 2012r2. I have it downloaded and saved to G:\ISO\Srv2012r2Eval.iso and i'm going to create a new vhdx in G:\vhd 

```	powershell
Convert-Wim2VHD -Path G:\vhd\2012r2_eval_Core.vhdx -Size 60gb -Dynamic -DiskLayout UEFI -SourcePath G:\iso\Srv2012r2Eval.ISO -Index 1 -Verbose
```

```	powershell
VERBOSE: [Convert-Wim2VHD] : Overwrite partitions inside [G:\vhd\2012r2_eval_Core.vhdx] 
with content of [G:\iso\Srv2012r2Eval.ISO]
VERBOSE: [Convert-Wim2VHD] : InitializeVHDPartitionParam
VERBOSE:
Name                           Value
----                           -----
Dynamic                        True
Path                           G:\vhd\2012r2_eval_Core.vhdx
DiskLayout                     UEFI
force                          True
Size                           64424509440

VERBOSE: [Convert-Wim2VHD] : SetVHDPartitionParam
VERBOSE:
Name                           Value
----                           -----
SourcePath                     G:\iso\Srv2012r2Eval.ISO
Path                           G:\vhd\2012r2_eval_Core.vhdx
FeatureSourceIndex             1
Index                          1
Force                          True
Confirm                        False

VERBOSE: [Convert-Wim2VHD] : ParametersToPass
VERBOSE:
Name                           Value
----                           -----
Verbose                        True

VERBOSE: [Initialize-VHDPartition] Create partition structure for Bootable vhd(x) on 
[G:\vhd\2012r2_eval_Core.vhdx]
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Creating
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : @vhdParms
VERBOSE:
Name                           Value
----                           -----
Path                           G:\vhd\2012r2_eval_Core.vhdx
SizeBytes                      64424509440
Dynamic                        True
ErrorAction                    Stop
BlockSizeBytes                 1048576

VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Mounting disk image
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Initializing disk [5] as 
GPT
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Clearing disk partitions to 
start all over
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : EFI system : Creating 
partition of [209715200] bytes
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : EFI system : Formatting 
FAT32
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : EFI system : Setting system 
partition as ESP
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : MSR : Creating partition of 
[134217728] bytes
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Windows : Creating partition 
of [64078479360] bytes
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Windows : Formatting volume 
NTFS
VERBOSE: [Initialize-VHDPartition] [2012r2_eval_Core.vhdx] : Dismounting disk image
VERBOSE: [Set-VHDPartition] : Overwrite partitions inside [G:\vhd\2012r2_eval_Core.vhdx] 
with content of
[G:\iso\Srv2012r2Eval.ISO]
VERBOSE: [Set-VHDPartition] : Opening ISO [Srv2012r2Eval.ISO]
VERBOSE: [Set-VHDPartition] : Looking for I:\sources\install.wim
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Mounting disk image 
[G:\vhd\2012r2_eval_Core.vhdx]
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Munted as disknumber [5]
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Partition Table
VERBOSE:
PartitionNumber DriveLetter        Size Type
--------------- -----------        ---- ----
              1           J   209715200 System
              2               134217728 Reserved
              3           K 64078479360 Basic

VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] Windows Partition [3] : Applying 
image from
[I:\sources\install.wim] to [K:\] using Index [1]
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Disk Layout [UEFI]
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] System Partition [1] : Running 
[K:\Windows\System32\bcdboot.exe] ->
 K:\Windows /s J: /v /f UEFI
VERBOSE: [Run-Executable] : Running [K:\Windows\System32\bcdboot.exe] 
[K:\Windows /s J: /v /f UEFI]
VERBOSE:
Name                           Value
----                           -----
PassThru                       True
FilePath                       K:\Windows\System32\bcdboot.exe
ArgumentList                   {K:\Windows, /s J:, /v, /f UEFI}
RedirectStandardError          C:\Users\BLADE_~1\AppData\Local\Temp\bcdboot.exe-Standard
Error.txt
NoNewWindow                    True
Wait                           True

RedirectStandardOutput         C:\Users\BLADE_~1\AppData\Local\Temp\bcdboot.exe-Standard
Output.txt
VERBOSE: [Run-Executable] : Return code was [0]
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Removing Drive letters
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Dismounting
VERBOSE: [Set-VHDPartition] [2012r2_eval_Core.vhdx] : Finished
```

## Server with a GUI and .net 3.5

Lets say we need a VM with the Desktop and .Net 3.5 to run a legacy vendor app.

```	powershell
Convert-Wim2VHD -Path G:\vhd\2012r2_eval_gui.vhdx -Size 60gb -Dynamic -DiskLayout UEFI -SourcePath G:\iso\Srv2012r2Eval.ISO -Index 2 -Feature NetFx3
```

The -Feature command takes the feature names that would be understood by DISM, or Install-WindowsOptionalFeature

Creating a VHDX is a good start, but we want to automate this. for that we need an Unatten.xml. I will cover that in the next blog
