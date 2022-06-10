// These are default laughs and screams so that newly added races or old races need not worry about having a mouth but being unable to use it.
// Defaults are human noises from 6/9/2022, any other additional vocalizations can be appended to the humans list i guess
GLOBAL_LIST_INIT(default_emote_sounds, list(
						"default_male_laughs" = list('sound/voice/human/manlaugh1.ogg','sound/voice/human/manlaugh2.ogg'),
						"default_female_laughs" = list('sound/voice/human/womanlaugh.ogg'),
						"default_male_screams" = list('sound/voice/human/malescream_1.ogg','sound/voice/human/malescream_2.ogg','sound/voice/human/malescream_3.ogg','sound/voice/human/malescream_4.ogg','sound/voice/human/malescream_5.ogg'),
						"default_female_screams" = list('sound/voice/human/femalescream_1.ogg','sound/voice/human/femalescream_2.ogg','sound/voice/human/femalescream_3.ogg','sound/voice/human/femalescream_4.ogg')
))

GLOBAL_LIST_INIT(male_laughs, list(
						"apid" 		= 	new/list(GLOB.default_emote_sounds['default_male_laughs']),
						"ethereal" 	= 	GLOB.default_emote_sounds['default_male_laughs'],
						"human" 	= 	GLOB.default_emote_sounds['default_male_laughs'],
						"ipc" 		= 	list('monkestation/sound/voice/laugh/silicon/laugh_siliconE1M0.ogg','monkestation/sound/voice/laugh/silicon/laugh_siliconE1M1.ogg','monkestation/sound/voice/laugh/silicon/laugh_siliconM2.ogg'),
						"jelly" 	= 	GLOB.default_emote_sounds['default_male_laughs'],
						"lizard" 	= 	list('monkestation/sound/voice/laugh/lizard/lizard_laugh.ogg'),
						"ashlizard" = 	list('monkestation/sound/voice/laugh/lizard/lizard_laugh.ogg'),
						"moth" 		= 	list('monkestation/sound/voice/laugh/moth/mothchitter.ogg','monkestation/sound/voice/laugh/moth/mothlaugh.ogg','monkestation/sound/voice/laugh/moth/mothsqueak.ogg'),
						"plasmaman" = 	list('monkestation/sound/voice/laugh/skeleton/skeleton_laugh.ogg'),
						"skeleton" 	= 	list('monkestation/sound/voice/laugh/skeleton/skeleton_laugh.ogg'),
						"simian"	=	list('monkestation/sound/voice/laugh/simian/monkey_laugh_1.ogg')
))

GLOBAL_LIST_INIT(female_laughs, list(
						"apid" 		= 	GLOB.default_emote_sounds['default_female_laughs'],
						"ethereal" 	= 	GLOB.default_emote_sounds['default_female_laughs'],
						"human" 	= 	GLOB.default_emote_sounds['default_female_laughs'],
						"ipc" 		= 	list('monkestation/sound/voice/laugh/silicon/laugh_siliconF0.ogg','monkestation/sound/voice/laugh/silicon/laugh_siliconF1.ogg','monkestation/sound/voice/laugh/silicon/laugh_siliconF2.ogg'),
						"jelly" 	= 	GLOB.default_emote_sounds['default_female_laughs'],
						"lizard" 	= 	list('monkestation/sound/voice/laugh/lizard/lizard_laugh.ogg'),
						"ashlizard" = 	list('monkestation/sound/voice/laugh/lizard/lizard_laugh.ogg'),
						"moth" 		= 	list('monkestation/sound/voice/laugh/moth/mothchitter.ogg','monkestation/sound/voice/laugh/moth/mothlaugh.ogg','monkestation/sound/voice/laugh/moth/mothsqueak.ogg'),
						"plasmaman" = 	list('monkestation/sound/voice/laugh/skeleton/skeleton_laugh.ogg'),
						"skeleton" 	= 	list('monkestation/sound/voice/laugh/skeleton/skeleton_laugh.ogg'),
						"simian"	=	list('monkestation/sound/voice/laugh/simian/monkey_laugh_1.ogg')
))

GLOBAL_LIST_INIT(male_screams, list(
						"apid" 		= 	GLOB.default_emote_sounds['default_male_screams'],
						"ethereal" 	= 	GLOB.default_emote_sounds['default_male_screams'],
						"human" 	= 	GLOB.default_emote_sounds['default_male_screams'],
						"ipc" 		= 	list('monkestation/sound/voice/screams/silicon/scream_silicon.ogg'),
						"jelly" 	= 	GLOB.default_emote_sounds['default_male_screams'],
						"lizard" 	= 	list('sound/voice/lizard/lizard_scream_1.ogg','sound/voice/lizard/lizard_scream_3.ogg','sound/voice/lizard/lizard_scream_4.ogg'),
						"ashlizard" = 	list('sound/voice/lizard/lizard_scream_1.ogg','sound/voice/lizard/lizard_scream_3.ogg','sound/voice/lizard/lizard_scream_4.ogg'),
						"moth" 		= 	list('sound/voice/moth/scream_moth.ogg'),
						"plasmaman" = 	list('monkestation/sound/voice/screams/skeleton/scream_skeleton.ogg'),
						"skeleton" 	= 	list('monkestation/sound/voice/screams/skeleton/scream_skeleton.ogg'),
						"simian"	=	list('sound/creatures/monkey/monkey_screech_1.ogg','sound/creatures/monkey/monkey_screech_2.ogg','sound/creatures/monkey/monkey_screech_3.ogg','sound/creatures/monkey/monkey_screech_4.ogg')
))

GLOBAL_LIST_INIT(female_screams, list(
						"apid" 		= 	GLOB.default_emote_sounds['default_female_screams'],
						"ethereal" 	= 	GLOB.default_emote_sounds['default_female_screams'],
						"human" 	= 	GLOB.default_emote_sounds['default_female_screams'],
						"ipc" 		= 	list('monkestation/sound/voice/screams/silicon/scream_silicon.ogg'),
						"jelly" 	= 	GLOB.default_emote_sounds['default_female_screams'],
						"lizard" 	= 	list('sound/voice/lizard/lizard_scream_2.ogg','sound/voice/lizard/lizard_scream_3.ogg','monkestation/sound/voice/screams/lizard/lizard_scream_5.ogg'),
						"ashlizard" = 	list('sound/voice/lizard/lizard_scream_2.ogg','sound/voice/lizard/lizard_scream_3.ogg','monkestation/sound/voice/screams/lizard/lizard_scream_5.ogg'),
						"moth" 		= 	list('sound/voice/moth/scream_moth.ogg'),
						"plasmaman" = 	list('monkestation/sound/voice/screams/skeleton/scream_skeleton.ogg'),
						"skeleton" 	= 	list('monkestation/sound/voice/screams/skeleton/scream_skeleton.ogg'),
						"simian"	=	list('sound/creatures/monkey/monkey_screech_5.ogg','sound/creatures/monkey/monkey_screech_6.ogg','sound/creatures/monkey/monkey_screech_7.ogg')
))
