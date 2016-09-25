---
layout: post
title: Windows Image Tools \| Modify VHDX
modified:
categories: [projects, WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
comments: true
featured: true
date: 2016-08-30T16:48:59-05:00
---

{% include toc.html %}

## Continuing onward

In the last post I talked about Unattend.xml and using WindowsImageTools to create a new VHDX with an Unattend.xml and FirstBoot.ps1 for it to run.

using that as a starting point I'm going to replace the do-nothing FirstBoot.ps1 add have it so something more interesting. 

## Prerequisites

You will need the VHDX created at the end of my post on New-UnattendXml and obviously a copy on WindowsImageTools from the PowerShell gallery.

We are going to have our VHDX install [7Zip](http://www.7-zip.org/download.html) on first boot so you will need to download a the MSI if your following along. 

## Creating a new improved FirstBoot.ps1

I downloaded my MSI into G:\filesToInject\PsTemp and now i'm going to replace firstboot.ps1 so it will silently install it and write a log and shutdown

{% highlight PowerShell %}
$BetterFirstBootContent = {
   start-process C:\PsTemp\7z1602-x64.msi -ArgumentList '/q','INSTALLDIR="C:\Program Files\7-Zip"' -wait
}
 New-Item -Path "G:\filesToInject\PsTemp" -Name FirstBoot.ps1 -ItemType 'file' -Value $BetterFirstBootContent -Force
{% endhighlight %}

### Placing the files in the VHDX

So now we need to get the two fils into our existing VHD. Now I could just run Convert-Wim2VHD again with the same commands and I would get the desired effect, but I dont want to wait for the that process. I also could just mount the VHDX and drag and drop the files into the VHDX, but that would not let me show off another function in WindowsImageTools

#### Mount-VhdAndRunBlock

Mount-VhdAndRunBlock is one of my favorite tools. It will mount a VHD and run a script block allowing me to manipulate the files inside. This can be used for copying in files, Editing the registry, checking if a file exists and so on.

{% highlight PowerShell %}
$ScriptBlock = {
  copy G:\filesToInject\PsTemp\*.* "$($driveletter):\PsTemp\" -Force
} 
Mount-VhdAndRunBlock -VHD 'G:\vhd\2012r2_eval_Core.vhdx' -block $ScriptBlock
{% endhighlight %}

Now that we have the better first boot script we need to create a VM to attach the vhdx to. for that I'm going to use Invoke-CreateVmRunAndWait. 

### Before we create a VM 

Lets look at what we need besides the vhdx to use Invoke-CreateVmRunAndWait

{% highlight PowerShell %}
help Invoke-CreateVmRunAndWait

NAME
    Invoke-CreateVmRunAndWait

SYNOPSIS
    Create a temp vm with a random name and wait for it to stop


SYNTAX
    Invoke-CreateVmRunAndWait [-VhdPath] <String> [-VmGeneration] <Int32> [-VmSwitch] <String> [[-vLan] <Int32>]
    [[-ProcessorCount] <Int32>] [[-MemoryStartupBytess] <Int64>] [<CommonParameters>]
{% endhighlight %}

So according to the syntax VhdPath, VmGeneration and VmSwitch are required parameters.

#### Deciding on a VM Generation 

While I know what type of VHDX i created, when creating automation script we may not always know if I need a Gen1 or Gen2 VM. So I'm going use Get-VhdPartitionStyle.

Get-VhdPartitionStyle will return a string of either MBR for Master Boot Record or GPT for GUID Partition Table. Generation 1 VM's are based on BIOS and windows only works with MBR partitions for BIOS based computers. Generation 2 VM's are based on uEFI architecture and Windows uses GPT partitions by default with uEFI. 

{% highlight PowerShell %}
$vmGeneration = 2 #default to gen2 
$PartitionStyle = Get-VhdPartitionStyle -vhd 'G:\vhd\2012r2_eval_Core.vhdx'
if ($PartitionStyle -eq 'GPT') 
{
    $vmGeneration = 2
}
{% endhighlight %}

#### Getting the switch 

We are not actually going to use the network in this example so I'm just going to grab the first VmSwitch

{% highlight PowerShell %}
$VmSwitch = (Get-VMSwitch)[0].Name #First switch
{% endhighlight %}

### Creating the VM

{% highlight PowerShell %}
Invoke-CreateVmRunAndWait -VhdPath 'G:\vhd\2012r2_eval_Core.vhdx' -VmGeneration $vmGeneration -VmSwitch $VmSwitch -verbose
{% endhighlight %}

We now have a randomly named vm that will run our script and install z7ip. Because it running this during the specialize phase once it's done it will reboot and end up at the "Press Ctrl+Alt+Del to login" I"m just going to use Hyper-V manager to shut it down.

{% highlight PowerShell %}
VERBOSE: [Invoke-CreateVmRunAndWait] : Creating VM 1utbdwad at 08/30/2016 10:57:29
VERBOSE: [Invoke-CreateVmRunAndWait] : VM 1utbdwad stopped
VERBOSE: [Invoke-CreateVmRunAndWait] : VM 1utbdwad Deleted at 08/30/2016 11:08:47
{% endhighlight %}

### Checking the results

{% highlight PowerShell %}
$ScriptBlock = {
  dir "$($driveletter):\Program Files\"
} 
Mount-VhdAndRunBlock -VHD 'G:\vhd\2012r2_eval_Core.vhdx' -block $ScriptBlock
{% endhighlight %}

```
    Directory: K:\Program Files


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         9/4/2016   9:42 AM                7-Zip
d-----        8/22/2013  10:39 AM                Common Files
d-----        3/21/2014   1:09 PM                Internet Explorer
d-----        8/22/2013  10:39 AM                WindowsPowerShell
```

## Summary

So now we have a VM with an app installed, users created and automated the Out of Box Esperance. However a fresh install of Server 2012 R2 does not have WMF 5 and will have a ton of patches that need to be installed.

I will tackle that next.
