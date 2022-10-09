User documentation for GENMIDI.DRV driver - 12 May 1993
-------------------------------------------------------

Sierra On-Line provides after-market support for General MIDI, 
EMU Proteus/1, Roland D110, and Roland D10, D20 series 
synthesizers through the GENMIDI.DRV driver and the appropriate 
patch file (.PAT). This driver will work with the the games 
listed below.

To use the driver with your game you will need three files: 
GENMIDI.DRV, GENMIDI.HLP, and the patch file for the game and 
synth you are using. The patch files are named using four 
letters for the game name and the remaining letters for the 
synth type.  For example, the General MIDI patch for Space 
Quest IV would be named "SQ4_GM.PAT".  The Proteus/1 patch 
for Eco Quest 1 would be named "ECO1PRO1.PAT".  The D110 
patch for Hoyle 3 is called HOY3D110.PAT.

General Midi Patches:

ECO1GM.PAT	EcoQuest 1
HOY3GM.PAT	Hoyle 3
LL1_GM.PAT	Leisure Suit Larry 1 (Enhanced Version)
LL5_GM.PAT	Leisure Suit Larry 5
ROBNGM.PAT	Robin Hood: Conquest of the Longbow
SQ1_GM.PAT	Space Quest 1 (Enhanced Version)
SQ4_GM.PAT	Space Quest 4
TALEGM.PAT	Mixed Up Fairy Tales

EMU Proteus/1 Patches:

ECO1PRO1.PAT	EcoQuest 1
HOY3PRO1.PAT	Hoyle 3
LB2_PRO1.PAT	Laura Bow II: The Dagger of Amon Ra
LL1_PRO1.PAT	Leisure Suit Larry 1 (Enhanced Version)
LL5_PRO1.PAT	Leisure Suit Larry 5
PQ1_PRO1.PAT	Police Quest 1 (Enhanced Version)
PQ3_PRO1.PAT	Police Quest 3
QG1_PRO1.PAT	Quest for Glory 1 (Enhanced Version)
ROBNPRO1.PAT	Robin Hood: Conquest of the Longbow
SQ1_PRO1.PAT	Space Quest 1 (Enhanced Version)
SQ4_PRO1.PAT	Space Quest 4
TALEPRO1.PAT	Mixed Up Fairy Tales

D10/20/110 Patches:

ECO1D110.PAT	EcoQuest 1
HOY3D110.PAT	Hoyle 3
LB2_D110.PAT	Laura Bow II: The Dagger of Amon Ra
LL1_D110.PAT	Leisure Suit Larry 1 (Enhanced Version)
LL5_D110.PAT	Leisure Suit Larry 5
PQ1_D110.PAT	Police Quest 1 (Enhanced Version)
PQ3_D110.PAT	Police Quest 3
QG1_D110.PAT	Quest for Glory 1 (Enhanced Version)
ROBND110.PAT	Robin Hood: Conquest of the Longbow
SQ1_D110.PAT	Space Quest 1 (Enhanced Version)
SQ4_D110.PAT	Space Quest 4
TALED110.PAT	Mixed Up Fairy Tales

If using a D10/20/110 you must set your unit number to 18.  If 
using a Proteus you must set your unit number to 0.

NOTE: The D10/20/110 and Proteus drivers will overwrite your 
existing patches via a sysex message.  Make sure you back up 
your unit before running the game!  If you need a sysex 
loader/saver there is one on the Sierra BBS called MIDI.EXE.

Place GENMIDI.DRV, GENMIDI.HLP, and the patch file in the game 
directory on your hard disk, or on game disk #1 if playing from 
floppies. The driver will expect the patch file to be named 
"4.PAT" so you must rename the appropriate patch file for each 
game to "4.PAT" (The Space Quest IV patch must be named PATCH.004 
rather than 4.PAT).  Now run the install program and select the 
GENERAL MIDI option when asked to choose a music device.  When 
the installation is complete, you may run your game normally and 
enjoy the music!

NOTES:  
1) The GENMIDI.DRV driver is designed to work with a Roland 
MPU-401/IPC or compatible MIDI interface.  If you wish 
to use a Pro Audio Spectrum MIDI interface with your MediaVision 
ProAudio Spectrum card, you will need to use the GENMIDMV.DRV 
driver instead of the GENMIDI.DRV driver.

2) All of Sierra's newest adventure games include a General Midi 
driver.  If you have an EMU PROTEUS/1 or a Roland D110, D10 or D20, 
you can use the included General MIDI driver on these newer games 
if you re-map your synth to the General Midi standard.

General MIDI Patch Mapping:

1   Acoustic Piano	44  Contra Bass		87  5th Saw Wave
2   Bright Piano	45  Tremolo Bass	88  Bass & Lead
3   Electric Piano	46  Pizzicato strings	89  Fantasia
4   Honky Tonk Piano	47  Orchestral Harp	90  Warm Pad
5   Rhodes Piano	48  Timpani		91  Polysynth
6   Chorus Piano	49  String Ensemble 1	92  Space Voice
7   Harpsichord		50  String Ensemble 2	93  Bowed Glass
8   Clavinet		51  Synth Strings 1	94  Metal Pad
9   Celesta		52  Synth Strings 2	95  Halo Pad
10  Glockenspiel	53  Choir Aahs		96  Sweep Pad
11  Music Box		54  Voice Ooohs		97  Ice Rain
12  Vibraphone		55  Synth Voice		98  Soundtrack
13  Marimba		56  Orchestra Hit	99  Crystal
14  Xylophone		57  Trumpet		100 Atmosphere
15  Tubular bells	58  Trombone		101 Brightness
16  Dulcimer		59  Tuba		102 Goblin
17  Organ 1		60  Muted Trumpet	103 Echo Drops
18  Organ 2		61  French Horn		104 Star Theme
19  Organ 3		62  Brass 1		105 Sitar
20  Church Organ 1	63  Synth Brass 1	106 Banjo
21  Reed Organ		64  Synth Brass 2	107 Shamisen
22  Accordian Fr	65  Soprano Sax		108 Koto
23  Harmonica		66  Alto Sax		109 Kalimba
24  Bandneon		67  Tenor Sax		110 Bag Pipe
25  Nylon-str. Gt	68  Baritone Sax	111 Fiddle
26  Steel-str. Gt	69  Oboe		112 Shanai
27  Jazz Gt		70  English Horn	113 Tinkle Bell
28  Clean Gt		71  Bassoon		114 Agogo
29  Muted Gt		72  Clarinet		115 Steel Drums
30  Overdrive Gt	73  Piccolo		116 Woodblock
31  Distortion Gt	74  Flute		117 Taiko
32  Gt Harmonics	75  Recorder		118 Melo Tom 1
33  Acoustic Bs		76  Pan Flute		119 Synth Drum
34  Fingered Bs		77  Bottle Blow		120 Reverse Cym
35  Picked Bs		78  Shakuhachi		121 Gt FretNoise
36  Fretless Bs		79  Whistle		122 Breath Noise
37  Slap Bass 1		80  Ocarina		123 Seashore
38  Slap Bass 2		81  Square Wave		124 Bird
39  Synth Bass 1	82  Saw Wave		125 Telephone 1
40  Synth Bass 2	83  Syn Calliope	126 Helicopter
41  Violin		84  Chiffer Lead	127 Applause
42  Viola		85  Charang		128 Gun Shot
43  Cello		86  Solo Vox	
