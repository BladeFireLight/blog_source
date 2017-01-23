---
title: Shaving the Yak, Leads Me to Create New Module WindowsImageTools
modified:
excerpt:
tags: [Rant]
date: 2015-09-29T00:00:00-05:00
---

{% include toc %}

## My Yak needs shaving.

If your not familiar with the term.

http://www.hanselman.com/blog/YakShavingDefinedIllGetThatDoneAsSoonAsIShaveThisYak.aspx

It’s been quite a journey since my last post.

Windows 10 came out, and Convert-WindowsImage.ps1 was upgraded (braking my scripts I blogged about this summer) and Server 2016 Preview 3 was released.

Looking at the Nano folder on Preview 3 they are using a WIM and Convert-WindowsImage.ps1to create a VHDX. Good move Microsoft.

Now for the bad part.

Convert-WindowImage.ps1 is buggy, and not a module. But Microsoft is working hart to fix this. Not being one to wait. I decided to take the functionality I need and re-work the whole process as a module. (and found some underlying bugs in PowerShell in the process )  The results of my effort is documented below.

As for Windows 10.

There are a number of changes to DSC that have broken all my production configuration scripts. And Configurations created on Windows10 or WMF 5 preview have bugs when using depends on, that cause the LCM on 2012R2 to hang.

For Production this is a show stopper, but I’m already working to separate out the configuration’s based on target OS.

## WindowsImageTools

Microsoft recently moved Convert-WindowsImage over to GitHub and added some nice features, but it’s still a script, not a module. They also nicely added an MIT licence to that repo. So taking advantage of that I started my own project based on that code. I’m calling it WindowsImageTools

So far there are four exported functions.

1. Initialize-VHDPartition
    1. Create a VHD with correct partition for BIOS or UEFI with or without Recovery tools/image
2. Set-VHDPartition
    1. take an ISO or WIM and populate the VHD. This detects the layout and acts accordingly.
    2. It also can add drivers, enable features, inject unattend.xml and inject additional files or folders
3. Convert-Wim2VHD
    1. This is a wrapper functions around the first two
4. New-UnattendXml
    1. Create an Unattend.xml that works with both 32 and 64 bit in a single file
    2. Sets the admin password and autologin count
    3. Creates then deletes a second user (for Windows7)
    4. Sets TimeZone
    5. Starts a PowerShell script to bootstrap the system configuration

That last one took quite some work to figure out. It only fully works with Volume media because it does not set the license key.

I also discovered that 64bit windows will run both the 32bit sections for adding users and running scripts, but not the part for skipping licensing and autologin. This is true from win7 forward. If your not familiar with Unattend.xml those parts are all under the same section in the xml.

If you want to give it a spin it’s [available at the PowerShell Gallery](https://www.powershellgallery.com/packages/WindowsImageTools/)

## Onward

So equipped with these tools i’m now going to reword my auto patching and WIM creation script. and add that into the module.
