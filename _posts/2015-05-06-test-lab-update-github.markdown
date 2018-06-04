---
title: Test-Lab \| Update-GitHub
modified:
excerpt:
tags: [TestLab]
date: 2015-05-06T00:00:00-05:00
---

### Posts in This series

1. [Test-HomeLab -InputObject "The Plan"]({% post_url 2015-04-27-test-homelab-inputobject-the-plan %})
2. [Get-Posh-Git \| Test-Lab]({% post_url 2015-04-30-Get-Posh-Git-Test-Lab %})
3. [Get-DSCFramework \| Test-Lab]({% post_url 2015-05-02-get-dscframework-test-lab %})
4. [Invoke-DscBuild \| Test-Lab]({% post_url 2015-05-03-invoke-dscbuild-test-lab %})
5. Test-Lab \| Update-GitHub (This Post)

Last time we were able to get the sample DSC config to build. The problem is we had to modify the sample script and the instructions were not clear on the setup of the files.

So to day I plan to update the SampleBuild.ps1, SampleConfiguration.psm1 and readme.md with my changes and submit a pull request.

The first thing I’m going to modify is SampleConfiguration.psm1, now this file worked as is with the previous blog. but some of the things we did were to get arround an issue with this file.

The line i’m talking about is here

```	powershell
 Import-Module DscConfiguration -ErrorAction Stop
```

This imports a module that is already loaded by SampleBuild.ps1 but is also not in the path at this point of Invoke-DscBuild, unless the DscConfiguration module is added to a path in -ModulePath used by Invoke-DscBuild.  Now if your going to run import-module SampleConfiguration crate the ConfigurationData hash table your self and call SampleConfiguration then it makes sense to have that here. I don’t imagine anyone doing that but stranger things have happen, so I’m going to keep that line but wrap it in something to avoid the requirement of placing extra modules in DSC_Tools

```	powershell
if (-not (Get-Module DscConfiguration)) {
 Import-Module DscConfiguration -ErrorAction Stop
}
```

This checks to see if DscConfiguration is already loaded into memory and skips the import is it is.

Now I don’t need any modules in DSC_Tooling. Unless I have modules used by my scripts that I dont import prior to calling Invoke-DscBuild

Next up is SampleBuild.ps1, I dont have any changes to make from what I did last time. so i will add that to my git repo in just a bit.

Now Readme.md in the examples folder needs some serious work.

```
Example DSC Build
------

This folder contains some very basic examples of what a DSC configurationData folder structure, script, and call to Invoke-DscBuild might look like.  If you want to execute SampleBuild.ps1, there are a few dependencies you need to set up ahead of time:

- You must install all of the DSC tooling modules (content of \Tools minus the example folder) from this repository into your PSModulePath (typically into C:\Program Files\WindowsPowerShell\Modules\)
- You must also copy the Tooling\Examples\SampleConfiguration folder to the PSModulePath.
- You must copy [Pester](https://github.com/pester/Pester) (version 3.0.0 or later) and [ProtectedData](https://github.com/dlwyatt/ProtectedData) (version 2.1 or later) into the PSModulePath.
- You should create a DSC_Resources folder in the same directory as SampleBuild.ps1 and DSC_Configuration.  Copy the following modules into that DSC_Resources folder:
  - [StackExchangeResources](https://github.com/PowerShellOrg/StackExchangeResources)
  - [cWebAdministration](https://github.com/PowerShellOrg/cWebAdministration)
  - [cSmbShare](https://github.com/PowerShellOrg/cSmbShare)

Create a folder to place all the files into. i.e. c:\DSC, inside that folder create folders named BuildOutput, DSC_Configuration, DSC_Resorces, DSC_Script, DSC_Tooling.

the folder structure should look like this
C:\DSC                # copy SampleBuild.ps1 here
+---BuldOutput        # Where the MOF files and ziped modules end up
+---DSC_Configuration # Copy \Tooling\Examples\DSC_Configuration\*  here
+---DSC_Resources     # copy StackExchangeResources, cSmbShare and cWebAdministration here
+---DSC_Script        # copy \Tooling\Examples\SampleConfiguration here
+---DSC_Tooling       # This is for any modules that may be used in a Configuration script, in the case of SampleConfiguration it would be empty.

If you plan on modifying SampleConfiguration.psm1 inside of DSC_Script you will also want to add the content of DSC_Modules to C:\Program Files\WindowsPowerShell\Modules\ but that is not necessary if your just building configurations that are authored on another machine.

Once these dependencies are set up, you can execute SampleBuild.ps1.  It will run tests against the 3 modules in your DSC_Resources folder, compile your configuration into MOF documents, produce zip files for the resource modules, generate checksums for everything and copy them into BuildOutput

_Note:  The SampleBuild.ps1 file currently just dumps DSC_Tooling modules into the temporary folder, since I wasn't using that feature.  We'll build on these examples soon to show off some of the other functionality in the DscBuild and DscConfiguration modules, such as encrypting credentials in source control._
```

If you compare with my last post you will notice I removed the line about placing SampleConfguration into C:\Program Files\WindowsPowerShell\Modules\. this path is no longer in the psmodulepath when inovke-DscBuild runs, as it used to be. This is due to needing to keep psmodulepath clean so that DSC_Resorces are accessible for configuration building but not necessarily needed.

I also added a section showing the required folder structure and what each folder is used for, along with what needs to be done if your going to author on the same machine you build on.

Now that that is done. I’m going to copy the files into C:\GitHub\PshOrgDSC\Tooling\Examples one at a time and add and commit changes.

copy SampleConfiguration.psm1 first. Notice the prompt change thanks to posh-git, (you will not see the color change)

```
C:\GitHub\PshOrgDSC\Tooling\Examples\SampleConfiguration [development +0 ~1 -0]> git add *

C:\GitHub\PshOrgDSC\Tooling\Examples\SampleConfiguration [development +0 ~1 -0]> git commit -m 'Fixed issue with loading scamplescript moduel not loading if module is already loaded but no longer in path'
[development a5301a8] Fixed issue with loading scamplescript moduel not loading if module is already loaded but no longer in path
 1 file changed, 3 insertions(+), 1 deletion(-)

C:\GitHub\PshOrgDSC\Tooling\Examples\SampleConfiguration [development]>
```

next up SampleBuild.ps1

```
C:\GitHub\PshOrgDSC\Tooling\Examples [development +0 ~1 -0]> git add *

C:\GitHub\PshOrgDSC\Tooling\Examples [development +0 ~1 -0]> git commit -m 'updated SampleBuild.ps1 to include missing value to invoke-DSCBuild. and added -verbose'
[development 5c35462] updated SampleBuild.ps1 to include missing value to invoke-DSCBuild. and added -verbose
 1 file changed, 4 insertions(+), 3 deletions(-)

C:\GitHub\PshOrgDSC\Tooling\Examples [development]>
```

last up readme.md

```
C:\GitHub\PshOrgDSC\Tooling\Examples [development +0 ~1 -0]> git add *

C:\GitHub\PshOrgDSC\Tooling\Examples [development +0 ~1 -0]> git commit -m 'updated \Tooling\Example\Readme.md to match the current state of development, and included section showing required folder structure'
[development 3aa570d] updated \Tooling\Example\Readme.md to match the current state of development, and included section showing required folder structure
 1 file changed, 14 insertions(+), 2 deletions(-)

C:\GitHub\PshOrgDSC\Tooling\Examples [development]>
```

finally I push the commits to my fork

```
C:\GitHub\PshOrgDSC\Tooling\Examples [development]> git push
git : To https://github.com/BladeFireLight/DSC.git
```

Now I can subit a pull request.

I head over to github https://github.com/BladeFireLight/DSC/tree/development

![compaireandpull]({{ site.url}}/images/compaireandpull.png)

Clicking Compare and pull request gives me a diff of each file and it’s changes.

![exampleDiff]({{ site.url}}/images/exampleDiff.png)

It also tells me there are no issues merging my commits into the upstream Development branch.