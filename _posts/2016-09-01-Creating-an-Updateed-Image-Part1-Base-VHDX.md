---
title: Windows Image Tools \| Creating an Updated Image Part 1
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-09-01T16:48:59-05:00
---

{% include toc %}

## Staring over

In the last post I demonstrated creating a fresh VHDX, with unattent.xml and using that to install 7zip.

Now i'm going to throw all that out, and starting over with a base image to install WMF5 and run windows updates.

## Prerequisites

For this we need the folder scructure used the WindowsImageTools to store the files. Luckily we have New-WindowsImageToolsExample that will create the folders and files we need.

{% highlight PowerShell %}
New-WindowsImageToolsExample -Path g:\Blog_Example
WARNING: Unable to read Windows Image Tools Update Cofniguration from g:\Blog_Example\Config.xml, creating a new file


    Directory: G:\


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         9/6/2016   4:09 PM                Blog_Example
{% endhighlight %}

Let's take a look at what we get

```
dir G:\Blog_Example\


    Directory: G:\Blog_Example


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----         9/6/2016   4:09 PM                BaseImage
d-----         9/6/2016   4:09 PM                ISO
d-----         9/6/2016   4:09 PM                Resource
d-----         9/6/2016   4:09 PM                UpdatedImageShare
-a----         9/6/2016   4:09 PM           3993 AdvancedUpdateExample.ps1
-a----         9/6/2016   4:09 PM           4775 BasicConvertExample.ps1
-a----         9/6/2016   4:09 PM           7456 BasicUpdateExample.ps1
-a----         9/6/2016   4:09 PM           1788 Config.xml
-a----         9/6/2016   4:09 PM           4814 DownloadEvalIso.ps1
```

I will not be delving into the example ps1 files. I'm going to walkthrough a similar example to the advanced one. 

We will start by looking at the Config.xml

{% highlight XML %}
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>System.Collections.Hashtable</T>
      <T>System.Object</T>
    </TN>
    <DCT>
      <En>
        <S N="Key">Gateway</S>
        <S N="Value">192.168.0.1</S>
      </En>
      <En>
        <S N="Key">vLan</S>
        <I32 N="Value">0</I32>
      </En>
      <En>
        <S N="Key">IpAddress</S>
        <S N="Value">192.168.0.100</S>
      </En>
      <En>
        <S N="Key">VmSwitch</S>
        <S N="Value">vmswitch</S>
      </En>
      <En>
        <S N="Key">IpType</S>
        <S N="Value">DHCP</S>
      </En>
      <En>
        <S N="Key">SubnetMask</S>
        <I32 N="Value">24</I32>
      </En>
      <En>
        <S N="Key">DnsServer</S>
        <S N="Value">192.168.0.1</S>
      </En>
    </DCT>
  </Obj>
</Objs>
{% endhighlight %}

It's a basic clixml file created with Export-Clixml containing the configuration used by WindowsImageTools to manage network settings for the vm's it creates. Now I'm not about to edit that file manual, and while I could use Import-Clixml/Export-Clixml to work with it. It simpler to use the functions that come with WindowsImageTools Get-UpdateConfig/Set-UpdateConfig

```
Get-UpdateConfig -Path G:\Blog_Example\

Name                           Value
----                           -----
IpType                         DHCP
vLan                           0
DnsServer                      192.168.0.1
Gateway                        192.168.0.1
VmSwitch                       vmswitch
SubnetMask                     24
IpAddress                      192.168.0.100
```

As you can see the default uses DHCP for the vm's IP assignment, does not use vLan tageing and attached to the virtual switch called vmswitch. To use it in my enviroment I need to make one small change

```
Set-UpdateConfig -Path G:\Blog_Example\ -VmSwitch Bridge | Get-UpdateConfig

Name                           Value
----                           -----
IpType                         DHCP
vLan                           0
DnsServer                      192.168.0.1
Gateway                        192.168.0.1
VmSwitch                       Bridge
SubnetMask                     24
IpAddress                      192.168.0.100
```

Now we are ready to add a base images.

## A la carte or All you can eat  

I'm going to create two images. One bear-bones 2012 R2 Core and one 2012 R2 GUI with .net 3.5. The reason for this is I want one really small WIM/VHDX for a starting port, and one WIM that I can use for a source to add Windows Features.

{% capture protip_critical_css %}
#### Why the Soruce WIM?

Windows Core comes with very little of the Windows Features installed, and when you add them Install-WindowsFeature will look to Windows Update for the missing bits. However if you don't have internet access then you need a source WIM. In a secure environment InfoSec usually frowns on web surfing from servers and expect you to use WSUS for updates. Unfortunately Install-WindowsFeature will not use WSUS. 
{% endcapture %}

<div class="notice--info">
  {{ protip_critical_css | markdownify }}
</div>

{% highlight PowerShell %}
Add-UpdateImage -Path 'G:\Blog_Example\' -FriendlyName 'Srv2012r2_Source' -DiskLayout UEFI -SourcePath 'G:\iso\Srv2012r2Eval.ISO'  -AdminCredential (Get-Credential) -AddPayloadForRemovedFeature -Index 4
Add-UpdateImage -Path 'G:\Blog_Example\' -FriendlyName 'Srv2012r2_Core' -DiskLayout UEFI -SourcePath 'G:\iso\Srv2012r2Eval.ISO'  -AdminCredential (Get-Credential) -Index 3
dir 'G:\Blog_Example\BaseImage\'
{% endhighlight %}

This gives us the two files. 

```
    Directory: G:\Blog_Example\BaseImage


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         9/6/2016   8:55 PM     4874829824 Srv2012r2_Core_base.vhdx
-a----         9/6/2016   8:28 PM     8250195968 Srv2012r2_Source_base.vhdx
```

Next up I'm going to update both to WMF5. 
