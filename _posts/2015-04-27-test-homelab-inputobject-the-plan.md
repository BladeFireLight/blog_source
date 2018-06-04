---
title: Test-HomeLab -InputObject "The Plan"
date: 2015-04-27
tags: [TestLab]
excerpt: "My Plan for a home test lab"
---

### Posts in This series

1. Test-HomeLab -InputObject "The Plan" (This Post)
2. [Get-Posh-Git \| Test-Lab]({% post_url 2015-04-30-Get-Posh-Git-Test-Lab %})
3. [Get-DSCFramework \| Test-Lab]({% post_url 2015-05-02-get-dscframework-test-lab %})
4. [Invoke-DscBuild \| Test-Lab]({% post_url 2015-05-03-invoke-dscbuild-test-lab %})
5. [Test-Lab \| Update-GitHub]({% post_url 2015-05-06-test-lab-update-github %})

## The Plan

What I intend to do is to create and in home test lab that I can use to test and develop DSC.  I’m basing my lab from [Greg Altman excellent post](http://powershell.org/wp/2015/03/25/home-labs-for-the-it-pro/) over on [PowerShell.org](http://powershell.org/)

The only exception I to this is that I have 2 machines to use a Hyper-V hosts. Now the second one I plan on installing Nano if/when it got into preview. Baring that I will use Hyper-V server 2012 R2.

Now to keep the lab services into the virtual realm as Greg mentioned, _and_ use two hosts. I have spend the weekend trying to create a vyos VPN tunnel between two isolated networks.

Needless to say not everything go according to plan. the Tunnel reports the link is up, but their is no traffic between network.

I have already wasted most of the weekend on this, so I’m going to move forward for now with with out the VPN.  It’s not like I need it yet.

So, onward.

I’m going to first build a windows 8.1 dev PC by hand, and load the PowerShell.org DSC tooling on it. From there I can build configs for building a as much of the rest of the environment as possible.

I hope to have a Pull Server, DC, PKI CA, up first, then move on to other servers that I can use to build resources for.

I have been running DSC in production for the last year, and I hope I can share may experience via a how to for a test environment and how it relates back to problems in the enterprise.
