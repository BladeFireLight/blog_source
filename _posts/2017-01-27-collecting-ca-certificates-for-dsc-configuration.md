---
title: Collecting CA Certificates for DSC Configuration
modified:
categories: [Nuggets]
tags: [DSC, PKI]
excerpt: "Best practice is to use individual certificates for each Node for DSC. While you can use auto enrollment, getting the certificates to where the MOF are build can be a problem. This is one solution"
---

## The Goal

Microsoft PFE Ashely McGlone [recommends](https://blogs.msdn.microsoft.com/powershell/2015/10/01/powershell-dsc-faq-sorting-out-certificates/) that each node managed by DSC (Desired State Configuration) have unique certificate for protecting credentials.

![Mof Credential Security Chart]({{ site.url }}{{ site.baseurl }}/assets/images/MofCredSecurity.png)

Starting in WMF 5.0 .MOF are [encrypted at rest](https://msdn.microsoft.com/en-us/powershell/wmf/5.0/dsc_encryptedmof) on the Node by . But that is not the case for the file on the pull server. So I'm going on the assumption that this is still a best practice. 
{: .notice--info}

The problem with that is getting the certificates either from the node or from a CA (Certificate Authority) to the DSC development workstation or CI/CD (Continuous Integration/Continuous Deployment) server. I'm going to cover one method.

## Pre-requisites

For this I'm going to be using [PowerShell Automated Lab Environment](https://github.com/theJasonHelmick/PS-AutoLab-Env) and it's Configuration called "devops-powershell-fundamentals"


This will generate the following:

1. DC1 - Domain Controller and Certificate Authority
2. S1, S2 - Member servers
3. N1 - Nano server (not used)
3. Cli1 - Windows 10 workstation
4. NAT virtual switch and static IP's 
5. Certificate Template called "DSC Template"
6. Auto-Enrollment GPO

## Demo 

I'm going to start with the 

