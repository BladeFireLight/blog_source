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

Starting in WMF 5.0 .MOF are [encrypted at rest](https://msdn.microsoft.com/en-us/powershell/wmf/5.0/dsc_encryptedmof) on the Node. But that is not the case for the file on the pull server. So I'm going on the assumption that this is still a best practice. 
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

Once that is up and running we can connect to cli1 via PowerShell Direct

## Demo 

I'm going to start with installing PKITools from the PowerShell Gallery  (and selecting Yes to install NuGet and allow use of untrusted rpo, this is new lab after all)

{% highlight Powershell %}
Install-Module PKITools
Get-Command -Module PkiTools

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ADCertificateTemplate                          1.6        PkiTools
Function        Get-CaLocationString                               1.6        PkiTools
Function        Get-CertificatAuthority                            1.6        PkiTools
Function        Get-CertificateTemplateOID                         1.6        PkiTools
Function        Get-IssuedCertificate                              1.6        PkiTools
{% endhighlight %}

                  
The one I want to focus on is Get-IssuedCertificate. As part of a DSC build process I want to collect the public certificates for each node. Pulling the certificate from each node is one option, but not practical in large network, and may not even be be possible due to lack of connectivity. Thankfully all the public certificates also reside on the Certificate Authority that issues them. 

In our lab there is only one domain and one CA (also the DC. no not do that in production) So the code will be simple. 

First lets look at the parameters. 

{% highlight PowerShell %}
SYNTAX
    Get-IssuedCertificate [[-ExpireInDays] <Int32>] [[-CAlocation] <String[]>] [[-Properties] <String[]>]
    [[-CertificateTemplateOid] <String>] [[-CommonName] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
{% endhighlight %}


No parameters are required. lets see what it does 

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> Get-IssuedCertificate


Issued Common Name          :
Certificate Expiration Date : 4/18/2018 3:40:05 AM
Certificate Effective Date  : 4/18/2017 3:40:05 AM
Certificate Template        : 1.3.6.1.4.1.311.21.8.8376484.9891361.12404633.14452813.1016466.111.1.29
Issued Request ID           : 2
Certificate Hash            : f2 4e db 00 12 19 68 79 98 0b 6a 95 47 6d 7a c6 a7 40 e7 63
Request Disposition Message : Issued
Requester Name              : COMPANY\DC1$
Binary Certificate          : -----BEGIN CERTIFICATE-----
                              MIIF6jCCBNKgAwIBAgITUQAAAAL5xXyLo72OVAAAAAAAAjANBgkqhkiG9w0BAQsF
                              ADBZMRAwDgYDVQQKEwdDb21wYW55MRAwDgYDVQQIEwdBcml6b25hMRAwDgYDVQQH
                              EwdQaG9lbml4MQswCQYDVQQGEwJVUzEUMBIGA1UEAxMLQ29tcGFueS5QcmkwHhcN
                              MTcwNDE4MDM0MDA1WhcNMTgwNDE4MDM0MDA1WjAAMIIBIjANBgkqhkiG9w0BAQEF
                              AAOCAQ8AMIIBCgKCAQEAxjtOVDCixBoUEOWG1WKwPqw0DY77upmE0E4Bfc6CV94g
                              X5ewYtagk7f8KvfigDaoq20qCNzFfaBprseL/0JoKPBY05Ws9O98pfAP639MGP6U
                              MCbgXZ8ILhtoWZCqHi+S8UVyu7D2meyyl54IgeoVcb0MBISWoGyyJ5tzAWYX1XQL
                              /0tnQ4YoWRcJulW7Qvn0kUhk6ooe9Mot4gCD0jPE/QjJ/loJDHO+aCRxsMwEil87
                              KqGKfEcS54dV+g6wRhgxlrfi8b1NDwhKcpgglSzhtmBEUY72m1S5AxuL7V90ZxNU
                              NQ/CBboy98NKri8RbmyvypAQ47MMyadVVmPLsAgGJwIDAQABo4IDAjCCAv4wNgYJ
                              KwYBBAGCNxUHBCkwJwYfKwYBBAGCNxUIg/+hJITb3CGF9Y8ZhvKQTb6FEm8BHQIB
                              cwIBADAUBgNVHSUEDTALBgkrBgEEAYI3FRMwDgYDVR0PAQH/BAQDAgWgMBwGCSsG
                              AQQBgjcVCgQPMA0wCwYJKwYBBAGCNxUTMHgGCSqGSIb3DQEJDwRrMGkwDgYIKoZI
                              hvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDALBglghkgBZQMEASowCwYJYIZIAWUD
                              BAEtMAsGCWCGSAFlAwQBAjALBglghkgBZQMEAQUwBwYFKw4DAgcwCgYIKoZIhvcN
                              AwcwHQYDVR0OBBYEFOB1zbkBT8m9NW7DRh7xW13OjSmLMB8GA1UdIwQYMBaAFA+9
                              p4ww6yyPs/vD4ugUNRM24pWIMIHFBgNVHR8Egb0wgbowgbeggbSggbGGga5sZGFw
                              Oi8vL0NOPUNvbXBhbnkuUHJpLENOPURDMSxDTj1DRFAsQ049UHVibGljJTIwS2V5
                              JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1Db21w
                              YW55LERDPVByaT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0
                              Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgb0GCCsGAQUFBwEBBIGwMIGtMIGq
                              BggrBgEFBQcwAoaBnWxkYXA6Ly8vQ049Q29tcGFueS5QcmksQ049QUlBLENOPVB1
                              YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
                              b24sREM9Q29tcGFueSxEQz1Qcmk/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENs
                              YXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwPgYDVR0RAQH/BDQwMqAfBgkrBgEE
                              AYI3GQGgEgQQezARELeYdUOiN2P2QTxNl4IPREMxLkNvbXBhbnkuUHJpMA0GCSqG
                              SIb3DQEBCwUAA4IBAQBCV12I9eIaFLRFsgzbhMizfufvtCOI/EKAOsEYCxI9HFKJ
                              H2HfC0lh7eEZABFQKPNx8XgCHCm5skzdR5oHLbtTwrnky2YJkFnuNOgTF/tuunoU
                              p3+X0Kk3YH88wrv+YPE37PtqF/fJnZvEUzPfxRiaiOFaTisEIXfAxTvVYVBSwK9H
                              oSgH5GTEblvlmiw6LD7JZYqrmYFCPQdB/mj+aOPjyeFClneGH2u8sxKCZHiJ/RWX
                              wQJn8DO5ACctnLC8mH70HR5vVRJ0yFX6vrpnRyJEBSpawAYFK1vPf7Wks+gLSw4q
                              g7ASEJG/MJK0oJpBosOKKGr+jMnEx6BTs1NJ3d0l
                              -----END CERTIFICATE-----

PSComputerName              : DC1.Company.Pri
RunspaceId                  : 146e5d7a-b85a-4540-9360-fea7413a9978

Issued Common Name          :
Certificate Expiration Date : 4/18/2018 3:40:07 AM
Certificate Effective Date  : 4/18/2017 3:40:07 AM
Certificate Template        : 1.3.6.1.4.1.311.21.8.8376484.9891361.12404633.14452813.1016466.111.1.28

~~~~~~~~SNIP~~~~~~~~~~~~~

                              BgkrBgEEAYI3UAEwHQYDVR0OBBYEFKYaQhzh28O8Sy4jBG5/63E59OzBMB8GA1Ud
                              IwQYMBaAFA+9p4ww6yyPs/vD4ugUNRM24pWIMIHFBgNVHR8Egb0wgbowgbeggbSg
                              gbGGga5sZGFwOi8vL0NOPUNvbXBhbnkuUHJpLENOPURDMSxDTj1DRFAsQ049UHVi
                              bGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlv
                              bixEQz1Db21wYW55LERDPVByaT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jh
                              c2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgb0GCCsGAQUFBwEB
                              BIGwMIGtMIGqBggrBgEFBQcwAoaBnWxkYXA6Ly8vQ049Q29tcGFueS5QcmksQ049
                              QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
                              bmZpZ3VyYXRpb24sREM9Q29tcGFueSxEQz1Qcmk/Y0FDZXJ0aWZpY2F0ZT9iYXNl
                              P29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwGwYDVR0RBBQwEoIQ
                              Q2xpMS5Db21wYW55LlByaTANBgkqhkiG9w0BAQsFAAOCAQEAFt8fD8dq7WdYxldl
                              648SS8KkqEeqUv4cBXt5/GBLBO/Cr7JB1m5K8U3VrjzwMgyU4n01h0xeJxYeHIvA
                              WZ1Fy8BXSzurH3MOcbC0jKuqezzXAJIpVAfkHB0UBKx+OnZes21aGXjb0ZHTv+lv
                              3lx6Wrc051RD+eDDLz0/+kLU6MRgJHTO8qlgRDRjRSqU7dcU1TKFmpij1IzWjvJb
                              GU2qHCfAnhWr8b+lMjvRMXkBxQjRF9kmMdhQxhR+nWN0/056wpr7/bukwGzPBKAU
                              HfFNFXqNT8nc79rB7IW4T6xZteEm0zG/TTNpIjL74/MGDBzFG3MTDE3i6ks9DoF/
                              9XDyDg==
                              -----END CERTIFICATE-----

PSComputerName              : DC1.Company.Pri
RunspaceId                  : 146e5d7a-b85a-4540-9360-fea7413a9978
{% endhighlight %}

That got every issued certificate for every CA on the current domain. More then I need. Obviously we need to trim that down to just the DSC certificates. for that we will need to specify -CertificateTemplateOID. Lets look at the help for that parameter.

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> help Get-IssuedCertificate -Parameter CertificateTemplateOid

-CertificateTemplateOid <String>
    Filter on Certificate Template OID (use Get-CertificateTemplateOID)

    Required?                    false
    Position?                    4
    Default value
    Accept pipeline input?       false
    Accept wildcard characters?  false
{% endhighlight %}

Good it has a function to get the OID lets look at that.

{% highlight PowerShell %}
SYNTAX
    Get-CertificateTemplateOID [-Name] <String> [[-Domain] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
{% endhighlight %}

Only the -Name is required. That I know.

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> Get-CertificateTemplateOID DSCTemplate
1.3.6.1.4.1.311.21.8.16187918.14945684.15749023.11519519.4925321.197.13392998.8282280
{% endhighlight %}

And I though GUIDS were an eye full.

Get-IssuedCertificate also has a -Propterties paramaters lets look at that.

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> help Get-IssuedCertificate -Parameter Properties

-Properties <String[]>
    Fields in the Certificate Authority Database to Export

    Required?                    false
    Position?                    3
    Default value                (
                'Issued Common Name',
                'Certificate Expiration Date',
                'Certificate Effective Date',
                'Certificate Template',
                #'Issued Email Address',
                'Issued Request ID',
                'Certificate Hash',
                #'Request Disposition',
                'Request Disposition Message',
                'Requester Name',
            'Binary Certificate' )
    Accept pipeline input?       false
    Accept wildcard characters?  false
{% endhighlight %}

For collecting the Certificates I only need the 'Issued Common Name' and 'Binary Certificate' 

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> $DSCCerts = Get-IssuedCertificate -CertificateTemplateOid (Get-CertificateTemplateOID -Name 'DSC
Template') -Properties 'Issued Common Name', 'Binary Certificate'
[hv01]: [Cli1]: PS C:\>
[hv01]: [Cli1]: PS C:\> $DSCCerts.Count
4
{% endhighlight %}

So that got me 4 certs. Now I can step through each one and save them. 

{% highlight PowerShell %}
[hv01]: [Cli1]: PS C:\> mkdir c:\certs


    Directory: C:\


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        4/21/2017   7:12 AM                certs


[hv01]: [Cli1]: PS C:\> foreach ($cert in $DSCCerts)
>> {
>>     set-content -path "c:\certs\$($cert.'Issued Common Name').cer" -Value $cert.'Binary Certificate' -Encoding Ascii
>> }
[hv01]: [Cli1]: PS C:\> dir c:\certs


    Directory: C:\certs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        4/21/2017   7:12 AM           1982 Cli1.Company.Pri.cer
-a----        4/21/2017   7:12 AM           1978 DC1.Company.Pri.cer
-a----        4/21/2017   7:12 AM           1972 S1.Company.Pri.cer
-a----        4/21/2017   7:12 AM           1972 S2.Company.Pri.cer
{% endhighlight %}

Now I have the certificate files for each node I can use for DSC.
