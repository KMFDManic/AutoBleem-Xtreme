Sierra On-Line Drivers for Sound Blaster AWE32
==============================================

*** Last updated: January 25, 1995 ***

This ZIP files contains the following files:
AWE32.DRV	(Driver for 32-bit Protected Mode titles)
AWE16.DRV	(Driver for 16-bit titles with GM support built-in)
AWE16_P.DRV	(Driver for 16-bit titles that requiring a patch)
README.TXT	(This file)
AWEUTIL.COM	(Version 1.20, which is required for 16-bit Sierra titles)
GENMIDI.ZIP	(GM patches for older Sierra titles)


Creative Labs & Sierra On-Line have gotten together to provide after market
support for the AWE32 and some of Sierra's titles.  Three drivers were
written to support the AWE32 in its' native mode rather than through General
MIDI emulation.  The first driver, AWE32.DRV, is for Sierra's 32-bit protected
mode titles where the second and third drivers, AWE16.DRV & AWE16_P.DRV, are
for Sierra's 16-bit titles and these two require the use of AWEUTIL.COM.

In the case of the 16-bit titles, AWEUTIL.COM is used in conjunction with
Sierra's 16-bit drivers to provide support because Sierra's older titles
require a large amount of conventional memory.  This version of AWEUTIL.COM
will load itself high if enough high memory is available.


Native GM Titles (using the AWE16.DRV driver)
---------------------------------------------
EcoQuest 1 (CD-ROM version only)
EcoQuest 2
Freddie Pharkas, Frontier Pharmacist (Diskette & CD-ROM)
Hoyle Classic Card Games
Island of Dr. Brain
King's Quest 6 (Diskette & CD-ROM. CD-ROM requires the large installation)
Laura Bow 2 (Diskette & CD-ROM. CD-ROM requires the full installation)
Leisure Suit Larry 6 (Diskette version only)
Quest for Glory 1 (VGA Version)
Quest for Glory 3
Slater & Charlie Go Camping
Space Quest 4 (CD-ROM version only)
Space Quest 5

This driver requires the use of AWEUTIL.COM to provide support for the AWE32.
To use this driver with your game, do the following:

1) Install the game choosing GENERAL MIDI for music.
2) Copy the AWE16.DRV file into the game's directory.
3) Edit the RESOURCE.CFG file and change the soundDrv from
		soundDrv = GENMIDI.DRV
		to
		soundDrv = AWE16.DRV
4) Run AWEUTIL.COM /EM:GM.
5) After quitting the game, run AWEUTIL.COM /U to unload the TSR.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Patched GM Titles (using the AWE16_P.DRV driver)
------------------------------------------------
Title                                           Patch Name
-----                                           ----------
Conquests of the Longbow                        ROBNGM.PAT
EcoQuest 1 (Diskette version only)              ECO1GM.PAT
Hoyle's Book of Games 3                         HOY3GM.PAT
Leisure Suit Larry 1 (VGA Version)              LL1_GM.PAT
Leisure Suit Larry 5                            LL5_GM.PAT
Mixed-Up Fairy Tales                            TALEGM.PAT
Space Quest 1 (VGA version)                     SQ1_GM.PAT
Space Quest 4 (Diskette version only)           SQ4_GM.PAT

This driver requires the use of AWEUTIL.COM to provide support for the AWE32.
To use this driver with your game, do the following:

1) Install the game choosing GENERAL MIDI for music.
2) Copy the AWE16_P.DRV file into the game's directory.
3) Copy the required GM patch in the game's directory.
4) Rename the General MIDI patch in the following manner:
	ren <patch name> 4.PAT  (for all games except Space Quest 4)
*Note* (For Space Quest 4, do the following)
	ren SQ4_GM.PAT PATCH.004
5) Edit the RESOURCE.CFG file and change the soundDrv from
	soundDrv = GENMIDI.DRV
	to
	soundDrv = AWE16.DRV
6) Run AWEUTIL.COM /EM:GM.
7) After quitting the game, run AWEUTIL.COM /U to unload the TSR.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Native GM Protected Mode Titles (using the SBAWE32.DRV)
-------------------------------------------------------
Gabriel Knight (Diskette & CD-ROM)
Leisure Suit Larry 6 (CD-ROM version only)
Police Quest 4 (Diskette & CD-ROM)
Quest for Glory 4 (Diskette & CD-ROM)

To use this driver with your game, do the following:

1) Install the game choosing GENERAL MIDI for music.
2) Copy the AWE32.DRV file into the game's directory.
3) Edit the RESOURCE.CFG file and change the soundDrv from
		soundDrv = GENMIDI.DRV
		to
		soundDrv = AWE32.DRV

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
That's it!  We will continue to update this list as new titles are tested.  If
you have any questions or problems regarding this list, please contact Creative
Labs Technical Support at 405-742-6622, by fax at 405-742-6633, or contact us
on CompuServe by going to the BLASTER forum.