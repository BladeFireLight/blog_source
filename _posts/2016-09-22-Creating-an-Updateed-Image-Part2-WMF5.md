---
title: Windows Image Tools \| Creating an Updated Image Part 2
modified:
categories: [WindowsImageTools]
excerpt: One of the time consuming steps to deploying new VMs is the time spend managing Images and and applying patches. I’m not big on Golden images. I tend to use a fully patched VHDX or VMDK  and let DSC handle the configuration and software. This is not the fastest, and at scale you need to create more then one image based on what saves the most time.  (IIS, SQL, Exchange, etc…).
tags: [VHDX, WindowsUpdate, WindowsUpdateTools, Module]
date: 2016-09-01T16:48:59-05:00
---

{% include toc %}

## Plan for today

Windows Management Framework contains PowerShell. You should always run the latest supported in your environment, and it's a good idea to get your hands on the preview and give it test run. I want my 2012r2 servers to be running WMF 5.0 the current stable realease.

Now I could install 5.1 preview, but as it has to be uninstalled when the final get's released, so I'm going to pass for now.

## Prerequisites  

If you folowing along you will need the WindowsImageTools update folder and two VHDX created in the last blog

## Updating WMF

Using Update-WindowsImageWMF we will download WMF 5.0 and .net 4.6. 

``` 
PS G:\> Update-WindowsImageWMF -Path G:\Blog_Example\ -ImageName Srv2012r2_Core -Verbose
```

First it's going to create a child vhdx so we can revert if things go south

```
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

Now it will copy the .NET installer and an AtStartup.ps1 to run the install.

```
VERBOSE: [Update-WindowsImageWMF] : .NET : Adding installer to G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: [Update-WindowsImageWMF] : .NET : updateting AtStartup script
```
It is going to create a VM with a random name and wait for it to stop. 
While it's running the AtStartup script will install .net, reboot and check the version of .net
If it find's what it's expecting it creates a file that Update-WindowsImageWMF will look for to decide if it can continue. 

```
VERBOSE: [Update-WindowsImageWMF] : .NET : Creating temp vm and waiting
VERBOSE: [createRunAndWaitVM] : Creating VM s4gzlpa4 at 09/22/2016 16:54:47
VERBOSE: [createRunAndWaitVM] : VM s4gzlpa4 Stoped
VERBOSE: [createRunAndWaitVM] : VM s4gzlpa4 Deleted at 09/22/2016 17:12:52
```

You cant use PowerShell to WMF because that updates PowerShell. So It will apply the MSU to the VHDX.
Now because Update-WindowsImageWMF does not know what OS is inside the vhdx. It will apply them all. Unfortunetly DISM (that does the work) reports succses when the MSU does not apply to that version of the OS. So it looks like all of the are installing but only the one that should actualy does.

```
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
To finalize the install Update-WindowsImageWMF needs to create a vm and let it finish installing then run a AtStartup script to check the version of PowerShell to validate the install worked. and if so write a flag file.

```
VERBOSE: [Update-WindowsImageWMF] : WMF : creating temp VM to finalize install on
G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
VERBOSE: [createRunAndWaitVM] : Creating VM yary1ogs at 09/22/2016 17:15:55
VERBOSE: [createRunAndWaitVM] : VM yary1ogs Stoped
VERBOSE: [createRunAndWaitVM] : VM yary1ogs Deleted at 09/22/2016 17:18:17
```

If the flag file is detected then the child vhdx is merged back into the base. if not the child file id discarded and an error thrown

```
VERBOSE: [Update-WindowsImageWMF] : WMF : Checking if changes made
VERBOSE: [Update-WindowsImageWMF] : WMF : Changes found : Merging G:\Blog_Example\\BaseImage\Srv2012r2_Core_Update.vhdx
 into G:\Blog_Example\\BaseImage\Srv2012r2_Core_Base.vhdx
```

I'm going to run the same command again on the other vhdx 

<figure class="highlight">
  <code>
<span style="color:#E0FFFF;">Update-WindowsImageWMF&nbsp;</span><span style="color:#FFE4B5;">-Path&nbsp;</span><span style="color:#EE82EE;">G:\Blog_Example\&nbsp;</span><span style="color:#FFE4B5;">-ImageName&nbsp;</span><span style="color:#EE82EE;">Srv2012r2_Source&nbsp;</span><span style="color:#FFE4B5;">-Verbose</span><br class=""/>

<span style="color:#00FFFF;">VERBOSE:&nbsp;Performing&nbsp;the&nbsp;operation&nbsp;&quot;Update&nbsp;WMF&nbsp;in&nbsp;Windows&nbsp;Image&nbsp;Tools&nbsp;Update&nbsp;Image&quot;&nbsp;on&nbsp;target&nbsp;&quot;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx&quot;.</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Creating&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx&nbsp;from&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;in&nbsp;G:\Blog_Example\\Resource\WMF\5</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;GET&nbsp;https://www.microsoft.com/en-us/download/details.aspx?id=50395&nbsp;with&nbsp;0-byte&nbsp;payload</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;received&nbsp;107378-byte&nbsp;response&nbsp;of&nbsp;content&nbsp;type&nbsp;text/html</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;GET&nbsp;http://www.microsoft.com/en-us/download/confirmation.aspx?id=50395&nbsp;with&nbsp;0-byte&nbsp;payload</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;received&nbsp;-1-byte&nbsp;response&nbsp;of&nbsp;content&nbsp;type&nbsp;text/html</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\W2K12-KB3134759-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\W2K12-KB3134759-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win7-KB3134760-x86.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win7-KB3134760-x86.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win8.1-KB3134758-x86.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;the&nbsp;latest&nbsp;WMF&nbsp;:&nbsp;G:\Blog_Example\\Resource\WMF\5\Win8.1-KB3134758-x86.msu&nbsp;:&nbsp;Found</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;Checking&nbsp;for&nbsp;.NET&nbsp;4.6.1&nbsp;installer</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;.NET&nbsp;:&nbsp;Adding&nbsp;installer&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;.NET&nbsp;:&nbsp;updateting&nbsp;AtStartup&nbsp;script</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;.NET&nbsp;:&nbsp;Creating&nbsp;temp&nbsp;vm&nbsp;and&nbsp;waiting</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;Creating&nbsp;VM&nbsp;dkdjxvqm&nbsp;at&nbsp;09/23/2016&nbsp;08:56:23</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;VM&nbsp;dkdjxvqm&nbsp;Stoped</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;VM&nbsp;dkdjxvqm&nbsp;Deleted&nbsp;at&nbsp;09/23/2016&nbsp;09:12:39</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;WMF&nbsp;:&nbsp;Applying&nbsp;WMF&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx&nbsp;and&nbsp;Updating&nbsp;AtStartup&nbsp;script</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;checking&nbsp;if&nbsp;G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu&nbsp;applies&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Target&nbsp;Image&nbsp;Version&nbsp;6.3.9600.17031</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Successfully&nbsp;added&nbsp;package&nbsp;G:\Blog_Example\Resource\WMF\5\W2K12-KB3134759-x64.msu</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;checking&nbsp;if&nbsp;G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu&nbsp;applies&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Target&nbsp;Image&nbsp;Version&nbsp;6.3.9600.17031</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Successfully&nbsp;added&nbsp;package&nbsp;G:\Blog_Example\Resource\WMF\5\Win7-KB3134760-x86.msu</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;checking&nbsp;if&nbsp;G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu&nbsp;applies&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Target&nbsp;Image&nbsp;Version&nbsp;6.3.9600.17031</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Successfully&nbsp;added&nbsp;package&nbsp;G:\Blog_Example\Resource\WMF\5\Win7AndW2K8R2-KB3134760-x64.msu</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;checking&nbsp;if&nbsp;G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu&nbsp;applies&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Target&nbsp;Image&nbsp;Version&nbsp;6.3.9600.17031</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Successfully&nbsp;added&nbsp;package&nbsp;G:\Blog_Example\Resource\WMF\5\Win8.1-KB3134758-x86.msu</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;checking&nbsp;if&nbsp;G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu&nbsp;applies&nbsp;to&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Target&nbsp;Image&nbsp;Version&nbsp;6.3.9600.17031</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;Successfully&nbsp;added&nbsp;package&nbsp;G:\Blog_Example\Resource\WMF\5\Win8.1AndW2K12R2-KB3134758-x64.msu</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;WMF&nbsp;:&nbsp;creating&nbsp;temp&nbsp;VM&nbsp;to&nbsp;finalize&nbsp;install&nbsp;on&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;Creating&nbsp;VM&nbsp;e5h2cc34&nbsp;at&nbsp;09/23/2016&nbsp;09:15:50</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;VM&nbsp;e5h2cc34&nbsp;Stoped</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[createRunAndWaitVM]&nbsp;:&nbsp;VM&nbsp;e5h2cc34&nbsp;Deleted&nbsp;at&nbsp;09/23/2016&nbsp;09:18:25</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;WMF&nbsp;:&nbsp;Checking&nbsp;if&nbsp;changes&nbsp;made</span><br class=""/><span style="color:#00FFFF;">VERBOSE:&nbsp;[Update-WindowsImageWMF]&nbsp;:&nbsp;WMF&nbsp;:&nbsp;Changes&nbsp;found&nbsp;:&nbsp;Merging&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Update.vhdx&nbsp;into&nbsp;G:\Blog_Example\\BaseImage\Srv2012r2_Source_Base.vhdx</span><br class=""/>
 </code>
</figure>

Now I'm going to quickly check to make sure this worked. I dont want to make any changes to the drive as it is so I will create a child vhdx and boot it.

<figure class="highlight">
  <code>
<span style="color:#E0FFFF;">New-VHD</span>&nbsp;<span style="color:#FFE4B5;">-Path</span>&nbsp;<span style="color:#EE82EE;">G:\Blog_Example\BaseImage\Srv2012r2_Core_temp.vhdx</span>&nbsp;<span style="color:#FFE4B5;">-ParentPath</span>&nbsp;<span style="color:#EE82EE;">G:\Blog_Example\BaseImage\Srv2012r2_Core_base.vhdx</span><br class=""/><span style="color:#E0FFFF;">Invoke-CreateVmRunAndWait</span>&nbsp;<span style="color:#FFE4B5;">-VhdPath</span>&nbsp;<span style="color:#EE82EE;">G:\Blog_Example\\BaseImage\Srv2012r2_Core_temp.vhdx</span>&nbsp;<br class=""/><span style="color:#E0FFFF;">Remove-Item</span>&nbsp;<span style="color:#EE82EE;">G:\Blog_Example\\BaseImage\Srv2012r2_Core_temp.vhdx</span>
  </code>
</figure>

checking the psversion table we see what is expected.

![PowerShell Version Table]({{ site.url }}\assets\images\PS5Version.JPG)

{% capture protip_critical_css %}
**Dealing with 2008/Win7**

WMF 5 on 2008 and Win7 need a few patches after WMF 4 is installed. So You want to run windows update before installing WMF 5
{% endcapture %}
<div class="notice--info">{{ protip_critical_css | markdownify }}</div>

Next up. Windows update and output of WIM/VHDX
