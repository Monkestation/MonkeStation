/mob/living/simple_animal/bot/secbot/pizzky
	name = "\improper Shitcuritron"
	desc = "he smells like garbage"
	icon = 'monkestation/icons/mob/aibots.dmi'
	icon_state = "secbot"
	chasesounds = list('monkestation/sound/voice/pizzky/criminal.ogg','monkestation/sound/voice/pizzky/freeze.ogg','monkestation/sound/voice/pizzky/justice.ogg')
	arrestsounds = "pizzky"
	auto_patrol = TRUE
	verb_whisper = "grumbles"
	var/last_grumble_speak = 0

/mob/living/simple_animal/bot/secbot/pizzky/bot_patrol()
	..()
	if((last_grumble_speak + 100 SECONDS) < world.time) //these messages should be fairly rare
		var/list/messagevoice = list("I can't take it anymore I'm gonna beat the fucking piss out of the clown.\
									  I'm gonna beat him within an inch of his fucking life.  I fucking hate that \
									  honking bitch." = 'monkestation/sound/voice/pizzky/mumble1.ogg',
									"If I had a mouth I think I'd really like apple juice boxes.  I really wish the \
									vending machines had apple juice boxes." = 'monkestation/sound/voice/pizzky/mumble2.ogg',
									"Holy crap do not get hired for nanotrasen security, worst mistake I have ever \
									 made." = 'monkestation/sound/voice/pizzky/mumble3.ogg',
									 "I swear to got these vending machines give people botulism.  I don't know how these \
									 people keep walking around." = 'monkestation/sound/voice/pizzky/mumble4.ogg')
		var/message = pick(messagevoice)
		whisper(message)
		playsound(src, messagevoice[message], 40, 0) //and pretty quiet
		last_grumble_speak = world.time

/mob/living/simple_animal/bot/secbot/pizzky/Initialize(mapload)
	. = ..()
	last_grumble_speak = world.time //so he doesn't grumble on spawn
	var/list/messagevoice = list("I AM NOW ALIVE AND I'M ABOUT TO MAKE IT EVERYONE ELSE'S PROBLEM!" = 'monkestation/sound/voice/pizzky/spawn1.ogg',
								 "WHY THE FUCK WOULD YOU BUILD THIS? WHAT THE FUCK IS WRONG WITH YOU?!" = 'monkestation/sound/voice/pizzky/spawn2.ogg')
	var/message = pick(messagevoice)
	say(message)
	playsound(src,messagevoice[message], 100, 0)

/mob/living/simple_animal/bot/secbot/pizzky/explode()
	var/atom/Tsec = drop_location()
	new /obj/item/food/pizzaslice/meat(Tsec)
	var/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/S = new(Tsec)
	S.reagents.add_reagent(/datum/reagent/consumable/ethanol/moonshine, 15)
	S.on_reagent_change(ADD_REAGENT)
	..()

/mob/living/simple_animal/bot/secbot/dagsky
	name = "\improper Officer Dag'sky"
	desc = "Oh, sweet Nerevar..."
	icon = 'monkestation/icons/mob/aibots.dmi'
	icon_state = "dagsky"
	chasesounds = list('monkestation/sound/voice/dagsky/chase1.ogg',
						'monkestation/sound/voice/dagsky/chase2.ogg',
						'monkestation/sound/voice/dagsky/chase3.ogg',
						'monkestation/sound/voice/dagsky/chase4.ogg',
						'monkestation/sound/voice/dagsky/chase5.ogg',
						'monkestation/sound/voice/dagsky/chase6.ogg')
	arrestsounds = "dagsky"
	auto_patrol = TRUE
	verb_say = "muses"
	var/last_grumble_speak = 0

/mob/living/simple_animal/bot/secbot/dagsky/bot_patrol()
	..()
	if((last_grumble_speak + 100 SECONDS) < world.time) //these messages should be fairly rare
		var/list/messagevoice = list("That damned clown. I must find that damned clown." = 'monkestation/sound/voice/dagsky/grumble1.ogg',
									"Criminals are the dredges of our society. \
									 Our space society. \
									 In space..." = 'monkestation/sound/voice/dagsky/grumble2.ogg',
									"Oh moon and star..." = 'monkestation/sound/voice/dagsky/grumble3.ogg',
									"Which way is the bar? I need a drink, Nerevar." = 'monkestation/sound/voice/dagsky/grumble4.ogg',
									"Why did they not make me the Captain? I am a God. I deserve to be the Captain." = 'monkestation/sound/voice/dagsky/grumble5.ogg',
									"The alchemists on this station are awful. The only potions they make intoxicate you." = 'monkestation/sound/voice/dagsky/grumble6.ogg',
									"All these assistants are useless. Useless!" = 'monkestation/sound/voice/dagsky/grumble7.ogg')
		var/message = pick(messagevoice)
		say(message)
		playsound(src, messagevoice[message], 100, 0) //a god need not whisper, he must proclaim!
		last_grumble_speak = world.time

/mob/living/simple_animal/bot/secbot/dagsky/Initialize(mapload)
	. = ..()
	last_grumble_speak = world.time //so he doesn't grumble on spawn
	var/list/messagevoice = list("Ah, moon and stars. You made the right choice bringing me here. I'm a God, how could they run from a God?" = 'monkestation/sound/voice/dagsky/spawn1.ogg',
								 "Oh sweet Nerevar... You have made a wise choice." = 'monkestation/sound/voice/dagsky/spawn2.ogg',
								 "The presence of Dagoth Ur is here. They shall not run from a god." = 'monkestation/sound/voice/dagsky/spawn3.ogg',
								 "I am here, sweet moon and star." = 'monkestation/sound/voice/dagsky/spawn4.ogg',
								 "This... does not look like Morrowind. Where am I?" = 'monkestation/sound/voice/dagsky/spawn5.ogg')
	var/message = pick(messagevoice)
	say(message)
	playsound(src,messagevoice[message], 100, 0)

/mob/living/simple_animal/bot/secbot/dagsky/explode()
	var/atom/Tsec = drop_location()
	new /obj/item/clothing/mask/dagoth(Tsec)
	..()
