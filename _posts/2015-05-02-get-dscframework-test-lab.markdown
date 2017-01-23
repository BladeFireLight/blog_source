---
title: Get-DSCFramework \| Test-Lab
modified:
excerpt:
tags: [TestLab]
date: 2015-05-02T00:00:00-05:00
---
{% include toc %}
### Posts in This series

1. [Test-HomeLab -InputObject "The Plan"]({% post_url 2015-04-27-test-homelab-inputobject-the-plan %})
2. [Get-Posh-Git \| Test-Lab]({% post_url 2015-04-30-Get-Posh-Git-Test-Lab %})
3. Get-DSCFramework \| Test-Lab (This Post)
4. [Invoke-DscBuild \| Test-Lab]({% post_url 2015-05-03-invoke-dscbuild-test-lab %})
5. [Test-Lab \| Update-GitHub]({% post_url 2015-05-06-test-lab-update-github %})

In the last post we got the posh-git installed, Now we are going to fork the Powershell.org DSC tools development branch and clone that locally.

I already have an account with GitHub, You will need one to be able to contribute.

I had over the the repository and click the fork button

![fork]({{ site.url}}/assets/images/fork.png)

with that done next is to get a copy of the clone URL.

![cloneurl]({{ site.url}}/assets/images/cloneurl.png)

I create a folder to store the repository in

~~~
C:\> mkdir github
    Directory: C:\
Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d----          5/1/2015   5:25 PM            github

C:\> cd github
C:\github>
~~~

now I have everything I need to make a clone.

~~~
C:\github> git clone https://github.com/BladeFireLight/DSC.git PshOrgDSC --branch development
git : Cloning into 'PshOrgDSC'...
At line:1 char:1
+ git clone https://github.com/BladeFireLight/DSC.git PshOrgDSC --branch developme ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (Cloning into 'PshOrgDSC'...:String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError


C:\github> cd .\PshOrgDSC

C:\github\PshOrgDSC [development]> dir

    Directory: C:\github\PshOrgDSC

Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d----          5/1/2015   5:38 PM            Tooling
-a---          5/1/2015   5:38 PM        605 .gitattributes
-a---          5/1/2015   5:38 PM        366 .gitignore
-a---          5/1/2015   5:38 PM       1099 LICENSE.txt
-a---          5/1/2015   5:38 PM       1231 README.md
-a---          5/1/2015   5:38 PM       7305 README.old.md

C:\github\PshOrgDSC [development]>
~~~

I’m not sure why PowerShell thought it was an error but the clone worked.

Next up will be getting the example config to build.

~~~
C:\github\PshOrgDSC [development]> cd .\Tooling\Examples

C:\github\PshOrgDSC\Tooling\Examples [development]> dir

    Directory: C:\github\PshOrgDSC\Tooling\Examples

Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d----          5/1/2015   5:38 PM            DSC_Configuration
d----          5/1/2015   5:38 PM            SampleConfiguration
-a---          5/1/2015   5:38 PM       1770 README.md
-a---          5/1/2015   5:38 PM       1203 SampleBuild.ps1
~~~
