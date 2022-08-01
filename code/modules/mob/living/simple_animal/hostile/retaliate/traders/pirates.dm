///base prototype of the pirates that handles lines they all have.
/mob/living/simple_animal/hostile/retaliate/trader/pirate
	name = "Pirate"
	desc = "A space pirate looking to flip some mysteriously procured wares for a quick buck."
	icon_state = "piratemerchant"
	loot = list(/obj/effect/mob_spawn/human/corpse/pirate)
	faction = list("pirate")
	itemsellcancelphrase = "Fine, keep it. But you should know i'm the only one here who will take it."
	buyphrase = "Heh, here you go. No refunds!"
	nocashphrase = "Hey, this isn't a giveaway! Earn some credits or don't come back."
	///Phrase said when entering an off limits area
	var/offlimitsphrase = "Hey, get out of here! Off limits!"
	///Phrase said when leaving an off limits area
	var/exitofflimitsphrase = "That's right, stay on YOUR side of the counter."
	lore = list(
		"A pirate's life for me... er, no, I'm not a pirate. Who's asking?",
		"We need some damn cryopods on this ship. You know how boring it gets when the FTL is long distance?",
		"Nanotrasen's funny. In the core sectors, they'll blow your ship apart because it isn't painted white. \
		But out here? Way different vibe.",
		"This old junker is originally a transport ship, until we acquired it. Legally, though.",
		"If we get enough credits, maybe we can get one of those ship weapons working.",
		"Have you heard of the Silver-Scales? They go around demanding tribute from stations like yours."
	)

/mob/living/simple_animal/hostile/retaliate/trader/pirate/offlimits_enter_reaction(datum/source, mob/living/arriving)
	. = ..()
	if(!.)
		return
	if(!faction_check_mob(arriving))
		INVOKE_ASYNC(src, .proc/aggro_intruder, arriving)

/mob/living/simple_animal/hostile/retaliate/trader/pirate/offlimits_exit_reaction(datum/source, mob/living/leaving)
	. = ..()
	if(!.)
		return
	if(!faction_check_mob(leaving))
		INVOKE_ASYNC(src, .proc/deaggro_intruder, leaving)

///small helper proc that does the part of the area enter signal that sleeps
/mob/living/simple_animal/hostile/retaliate/trader/pirate/proc/aggro_intruder(mob/living/intruder)
	say(offlimitsphrase)
	enemies += WEAKREF(intruder)

///small helper proc that does the part of the area exit signal that sleeps
/mob/living/simple_animal/hostile/retaliate/trader/pirate/proc/deaggro_intruder(mob/living/intruder)
	say(exitofflimitsphrase)
	enemies -= WEAKREF(intruder)

///this trader is used in the merchant event.
/mob/living/simple_animal/hostile/retaliate/trader/pirate/oddities
	name = "Pirate Curio Collector"
	desc = "A space pirate looking to buy and sell miscellaneous curios."
	//This merchant sells weird shit.
	products = list(
		// /obj/item/flashlight/lantern/jade = 200,
		/obj/item/seeds/random = 350,
		/obj/item/pda/clear = 400,
		/obj/item/reagent_containers/food/drinks/bottle/holywater = 500,
		/obj/item/lfline = 1500,
	)
	//This merchant wants rare maintenance loot
	wanted_items = list(
		/obj/item/throwing_star = 400,
		// /obj/item/pen/survival = 500,
		/obj/item/storage/box/hug = 500,
		/obj/item/flashlight/flashdark = 600,
		/obj/item/assembly/flash/memorizer = 600,
		// /obj/item/book/granter/crafting_recipe/pipegun_prime = 800,
		/obj/item/paint/anycolor = 1000,
		/obj/item/shadowcloak = 15000,
		/obj/item/clothing/suit/armor/reactive/table = 15000,
	)
	itemrejectphrase = "I'm only looking for curios. You should try digging through maintenance, or maybe from that lava planet nearby?"
	itemsellacceptphrase = "Cool stuff. I just like collecting them."
	interestedphrase = "Hey, that's an interesting oddity you have there."

/mob/living/simple_animal/hostile/retaliate/trader/pirate/oddities/Initialize(mapload)
	. = ..()
	//add rare shop items
	if(prob(20))
		products[/obj/item/clothing/mask/gas/space_ninja] = 750
	if(prob(10))
		products[/obj/item/sord] = 2500

/mob/living/simple_animal/hostile/retaliate/trader/pirate/quartermaster
	name = "Pirate Quartermaster"
	desc = "A space pirate looking to buy and sell pirate gear. It's an aesthetic!"
	//This merchant sells pirate gear.
	products = list(
		/obj/item/clothing/glasses/eyepatch = 40,
		/obj/item/clothing/under/costume/pirate = 60,
		/obj/item/clothing/suit/pirate = 100,
		/obj/item/clothing/head/helmet/space/pirate/bandana = 150,
		/obj/item/clothing/head/helmet/space/pirate = 250,
		/obj/item/clothing/suit/space/pirate = 250,
	)
	//This merchant wants pirate gear they do not sell (yeah, we're talking the cutlass basically)
	wanted_items = list(
		/obj/item/melee/transforming/energy/sword/pirate = 2000,
	)
	itemrejectphrase = "I'd buy some pirate weapons, if ye had em. But not that."
	itemsellacceptphrase = "Now you'll look the part!"
	interestedphrase = "Some wonderful pirate gear there... I would like to take it off your hands!"
