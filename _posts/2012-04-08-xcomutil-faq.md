---
layout: single
title: XcomUtil FAQ
date: 2012-04-08 16:06 -0500
categories: [XcomUtil]
---

## Will XcomUtil work with 64 bit windows?

Version 9.6 and earlier will not. 
While it works in Dosbox on x64 windows. 
the setup file does not run in DosBox.  
9.7 Has been compiled with both 16bit (for dosbox) and 32bit executable.

## Does XcomUtil work on Vista or Windows 7? 

The DOS versions of UFO and TFTD work with XcomUtil using DOSBox. However the xcusetup.bat does not currently work in DosBox. You have to run the setup in windows and then run the games from DOSBox.

XCOM CE runs in Vista and Windows 7 if you install a Application Compatibility Toolkit Shim that disables Direct Draw Acceleration. I have created a installer to set this up.  The installer is included with XcomUtil 9.7 and later.

## Will you release the source code?
I wish I could.  Scott has been verry clear on this point. The situation under what he created XcomUtil does not allow him to allow it into the public domain.

## What is XcomUtil?
XcomUtil is a game enhancer. It is not really an editor and it is certainly not a cheat program. The original purpose of XcomUtil was to make the game more difficult, because there was a bug in the original game that forced all games to the Beginner difficulty level, regardless of what level you chose.

Today, XcomUtil not only fixes the Difficulty Bug and several others, but it enables you to use all five ships to carry troops, it can randomly redesign the alien ships before each battle, and it can allow you to pick your terrain and the type of alien ship before each battle. The image below is an OS/2 screen capture of the new XCOM Interceptor. It holds up to 6 soldiers, with the possibility of one tank. 

The latest version allows you to merge the terrains from both XCOM and TFTD so that the terrains from either game are available in both games.

The original XcomUtil was a command line utility with a confusing set of options. Today, the XCUSETUP batch file prompts you for the most popular features and provides defaults for everything. The average user can just keep pressing enter and probably get what he or she wants. You can safely run XCUSETUP again and again to change the features whenever you like. The RUNXCOM batch file is used in both games to control the many runtime features of XcomUtil, such as new human ships, random terrains, and random ship generation.

XcomUtil supports all known versions of X-COM:UFO Defense and X-COM:Terror from the Deep (sometimes called TFTD or XCOM2) by MicroProse. It also supports all foreign versions of these games, including UFO:Enemy Unknown, the original European version of XCOM.

XcomUtil always allows you to view and modify your enemies and their equipment, dynamically change your money, score, or level of difficulty, and even switch sides with the enemy to allow two-player battles.

Use these programs at your own risk, only after making backups of the directories containing the files they modify. I am not liable for any damages they may cause. You may freely distribute these ZIP files only if they are not modified and no money is charged for their distribution. However, to allow me to easily update XcomUtil, you should link to this page rather than allow downloading of the files from your own pages.

XcomUtil has always been a DOS program because XCOM has always been a DOS program and XcomUtil must be able to run everywhere that XCOM runs. Therefore, XcomUtil run equally well under true DOS or in a DOS window.