---
title: Windows Image Tools \| Overview
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-03-16T16:48:59-05:00
---

## The problem

One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).

## What to do about it

I have spend some time putting together a number of scripts to automate this, but after the release of windows 10 and it's built in access to the galaxy I decided to look at updating and packaging my script into something portable and share it.

### Why a Module, why not a script?

Well scripts are great for automating a process, but not the best when you want to customize for your own process. Say you use a script on the [PowerShell Gallery](https://www.powershellgallery.com/) and have customized it to fit your environment and business process. Then their is a bug fix posted to the gallery. You get the fun of adapting the changes into your modified code. This is time consuming, and the reason so many thing in production remain outdated and buggy. But if your using a customized controller script[^ControlerSsript] that relies on a module function, being able to use the newer release from the PowerShell Gallery is less painful.

[^ControlerSsript]: A script that is specific to a business process

For that reason I have chosen to use a module and include a function that creates an example controller script.

## Functions included in WindowsImageTools

Functions cover three different areas, Creating VHDX, Manipulating them, and Updates.

### Create VHDX
   * Initialize-VHDPartition
     * Create a VHD(x) with the partitions structure appropriate for the target generation of a VM
   * Set-VHDPartition
     * Populate the VHD(x) partitions with the content of an ISO or WIM
   * Convert-Wim2VHD
     * Wrapper combining Initialize-VHDPartition and Set-VHDPartition in a single function
   * New-UnattendXml
     * Create an Unattent.xml to silently setup windows

### Work with VHDX
   * Get-VhdPartitionStyle
     * Returns GPT[^GPT] or MBR[^MBR]
   * Mount-VhdAndRunBlock
     * Mounts a VHD(x) sets the letter of the first mount point to $driveLeter and invokes a script block. useful for manipulating  files inside a VHD
   * Invoke-CreateVmRunAndWait
     * Created a VM attached the VHD to it and waits for it to stop. Used for running boot time scripts that shut down when finished.

### Update VHDX
   * New-WindowsImageToolsExample
     * Creates an example folder structure and example controller scripts
   * Get-UpdateConfig
     * Gets the update configuration stored in the update folders. Contains VM Switch, and IP addresses needed to access the internet when running updates.
   * Set-UpdateConfig
     * Change settings in the update configuration
   * Add-UpdateImage
     * Uses Convert-Wim2VHD and New-UnattendXml to prep a VHDX for updating
   * Update-WindowsImageWMF
     * Update VHDX to WMF 4 or WMF 5
   * Invoke-WindowsImageUpdate
     * For one VHDX or all VHD's in update folder, run windows update and output WIM and optional VHDX

[^GPT]: GUID Partition Table. Used for Generation 2 and UEFI. will contain MSR, UEFI and Primary partition, may include options Recovery Tools and Recovery Image partitions

[^MBR]: Master Boot Record. Used for Generation 1 and legacy BIOS. Will use one Primary partition
