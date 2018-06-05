---
layout: single
title: XcomUtil Downlaod
date: 2012-04-08 15:32 -0500
categories: [XcomUtil]
---

XcomUtil 9.7 [Download](https://1drv.ms/u/s!Akk2LpG2KuW1rocTD5I8KrjlWEdy2w)

## New in this version.
* Major overhaul of the installer (XcuSetup) and the inclusion of 16/32bit exe's to support both DOSBox and Windows Vista/7 x64.
* New sub folders added to hold supporting files making the install c leaner
* New XcuSetup options were added to XcuSetup allowing for silent install and uninstallation.
* New XcuSetup option for debugging the install (XcuSetup debug) creating debug.txt.
* New command line argument "nobackup" skips backup only if it has been ran at least once. 
* XcuSetup now can have minimal impact on the game. 
  * All options default to NO.
  * Almost all changes are now prompted for (skyranger guns, interceptor as transport, Disjointed Base Bug, etc...). 
    * Items still done by default:
    * Copy protection questions set to 0000000 for UFO 1.0-1.3 and X-Com 1.0
    * Difficulty bug fixed in UFO 1.0-1.4 and X-Com 1.0-1.4
    * Unique names for all maps in TFTD, Used for Hybrid Games
    * Placement of X-Com Units on the Battlefield based on XcomUtil.cfg
    * MIA Recovery on Won Combat (Units under mind\MC control when last controling alien killed are returned to X-Com control)
* XCOMUTIL.CFG is now pieced together and overwritten by XcuSetup (see XcomUtil.txt for how to make permanent changes).
* All game files are restored to the pre-XcomUtil state each time XcuSetup is ran. Any modifications by other utilities will have to be re-applied. 
* Vista/Win7 patch now an option for XcuSetup. 
  * This will fix the blank screen issue.
  * Updated to support the split EXE. 
* XcuSetup attempts to fix UAC issues by resetting folder permissions.
* A number of community made fixes are included and selectable with XcuSetup.
* Support for the DOS/Window STEAM Install. 
  * Windows EXE, just run XcuSetup from windows launch Dos version from Steam Run XcomUtil/SteamSetup.bat to activate menu then lauch from steam.
* Out of the box support for UFO Extender. XcuSetup will detect it and ask if you want RunXcom to use it.
* RunXcom can detect if it's in DosBox. Allowing XcuSetup to be run from windows and RunXcom run from DosBox.
* Hybrid Colors updated based on BombBloke's pallets.
* EQL flag allowed any turn.
* Add Xcom UFO Italian Support
* Updated f0dders ReadMe per his request. (XcomUtil\bugfix-readme.txt)
* Add-on support added. see XcomUtil\XcomUtil.txt and XcomUtil\Addon\Example.txt 
* Prompted Terrain in BattleField Generator allows to abort and use of current setting. 
* "debug" command arugument createds XcomUtil\Debug.txt and adds debug info to XcomUtil\XcomUtil.log
* Original Sound Effects from UFO were re-sampled to work with 1.4 and CE.

## Removed from this version

* New Desert and Urban terrain. (Will be added once I have a C++ version of the Java Terrain Edit.)
* Expanded capacity Laviathan, Hammerhead and Avenger (maps available in XcomUtil\Patches)
* Unit placement for Alien Bases

## Fixed

* MIA Recovery on won combat only.
* MIA Recovery no longer recovering units that bleed to death.
* Auto Combat will not run on second half of two part using first parts saved data.
* Auto equip no longer triggers on second part of 2 stage missions.
* Combine clips skiped if between stages of 2-3 part missions.
* Improve randomness by using current time instead of game date/time in srand()

**NOTE:** If you use DosBox, this requires DosBox 0.74 (Does not work on 0.73 due to buffer overflow setting ERRORLVEL)
{: .notice--warning}
