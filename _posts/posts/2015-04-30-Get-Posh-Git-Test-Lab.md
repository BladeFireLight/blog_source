---
title: Get-Posh-Git \| Test-Lab
date: 2015-04-30
tags: [TestLab]
excerpt: "My initial test lab starting to take shape."
comments: true
---

### Posts in This series

1. [Test-HomeLab -InputObject "The Plan"]({% post_url 2015-04-27-test-homelab-inputobject-the-plan %})
2. Get-Posh-Git \| Test-Lab (This Post)
3. [Get-DSCFramework \| Test-Lab]({% post_url 2015-05-02-get-dscframework-test-lab %})
4. [Invoke-DscBuild \| Test-Lab]({% post_url 2015-05-03-invoke-dscbuild-test-lab %})
5. [Test-Lab \| Update-GitHub]({% post_url 2015-05-06-test-lab-update-github %})

My initial test lab starting to take shape.

I have a vyos router bridging my production environment and my isolated virtual switch similar to what [Greg Altman talks about](http://powershell.org/wp/2015/03/25/home-labs-for-the-it-pro/) on PowerShell.org

And I have one Windows 8.1 Pro VM to setup the [PowerShell.org DSC tools](https://github.com/powershellorg/dsc/tree/development)

Now I’m going to get the development branch, as it has some major fixes, including a re-working of how modules are tested and package, and how passwords are stored.  The part on password is the big item for me.

Now I could just download it via GitHub using IE.

![DevBranch]({{ site.url}}/images/devbranch.png)

But this blog is about giving back to the community so I’m going to using the GitHub client, and it’s included Posh-Git module for PowerShell.

The GitHub client is a nice simple GUI client, but I have one issue with it. It installs into a users profile. While all store apps and downloaded .net apps do this and it’s a good thing for isolation. In a secure environment like where i work it’s frowned apon. So ifyour in that boat, Posh-Git can be downloaded from github and works with other git clients.

Now I dont plan on using the GUI for the purpose of this blog so I’m going to change my PowerShell profile to load posh-git. GitHub client has to be ran once to create the files I use in my profile.

The commands for that are.

{% highlight powershell %}
#create/add posh-git to profile
if (-not (test-path (split-path -Path $profile.CurrentUserAllHosts -Parent)))
{
mkdir (split-path -Path $profile.CurrentUserAllHosts -Parent)
}
'. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")' | out-file -Path $profile.CurrentUserAllHosts -Append
'. $env:github_posh_git\profile.example.ps1' | out-file -Path $profile.CurrentUserAllHosts -Append
{% endhighlight %}

restart powershell and I can run get-module to see what modules are loaded.

{% highlight powershell %}
C:\> Get-Module
 
ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     1.0.0.0    ISE                                 {Get-IseSnippet, Import-IseSnippet, New-IseSnippet}
Manifest   3.1.0.0    Microsoft.PowerShell.Management     {Add-Computer, Add-Content, Checkpoint-Computer, Clear-Content...}
Manifest   3.1.0.0    Microsoft.PowerShell.Utility        {Add-Member, Add-Type, Clear-Variable, Compare-Object...}
Script     0.0        posh-git                            {Add-SshKey, Enable-GitColors, Get-AliasPattern, Get-GitDirectory...}
{% endhighlight %}

Now we are ready to fork the PowerShell.org DSC repository and clone it locally.
