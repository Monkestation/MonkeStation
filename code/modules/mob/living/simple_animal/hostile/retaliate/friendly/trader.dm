/**
 * # Trader
 *
 * A mob that has some dialogue options with radials, allows for selling items and buying em'
 *
 */

/mob/living/simple_animal/hostile/retaliate/trader
	name = "Trader"
	desc = "Come buy some!"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "faceless"
	maxHealth = 200
	health = 200
	melee_damage = 10
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	del_on_death = TRUE
	loot = list(/obj/effect/mob_spawn/human/corpse)
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 2.5
	casingtype = /obj/item/ammo_casing/shotgun/buckshot
	wander = FALSE
	ranged = TRUE
	move_resist = MOVE_FORCE_STRONG
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	sentience_type = SENTIENCE_ORGANIC
	speed = 0
	check_friendly_fire = TRUE
	interaction_flags_atom = INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND|INTERACT_ATOM_ATTACK_HAND|INTERACT_ATOM_NO_FINGERPRINT_INTERACT|INTERACT_ATOM_IGNORE_ADJACENCY
	///Sound used when item sold/bought
	var/sell_sound = 'sound/effects/cashregister.ogg'
	///Associated list of items the NPC sells with how much they cost.
	var/list/products = list(/obj/item/food/burger/ghost = 200)
	///Associated list of items able to be sold to the NPC with the money given for them.
	var/list/wanted_items = list(/obj/item/ectoplasm = 100)
	///Phrase said when NPC finds none of your inhand items in wanted_items.
	var/itemrejectphrase = "Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk."
	///Phrase said when you cancel selling a thing to the NPC.
	var/itemsellcancelphrase = "What a shame, tell me if you changed your mind."
	///Phrase said when you accept selling a thing to the NPC.
	var/itemsellacceptphrase = "Pleasure doing business with you."
	///Phrase said when the NPC finds an item in the wanted_items list in your hands.
	var/interestedphrase = "Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?"
	///Phrase said when the NPC sells you an item.
	var/buyphrase = "Pleasure doing business with you."
	///Phrase said when you have too little money to buy an item.
	var/nocashphrase = "Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!"
	///Phrases used when you talk to the NPC
	var/list/lore = list(
		"Hello! I am the test trader.",
		"Oooooooo~!"
	)

/mob/living/simple_animal/hostile/retaliate/trader/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_CLICK, .proc/click_react)
	var/area/offlimits = GLOB.areas_by_type[/area/shuttle/merchant/offlimits]
	if(offlimits)
		RegisterSignal(offlimits, COMSIG_AREA_ENTERED, .proc/offlimits_enter_reaction)
		RegisterSignal(offlimits, COMSIG_AREA_EXITED, .proc/offlimits_exit_reaction)

/mob/living/simple_animal/hostile/retaliate/trader/attack_paw(mob/living/carbon/human/user, list/modifiers)
	attack_hand(user, modifiers)

/mob/living/simple_animal/hostile/retaliate/trader/interact(mob/user)
	if(user == target || (user in enemies))
		return FALSE
	face_atom(user)
	var/list/npc_options = list()
	if(products.len)
		npc_options["Buy"] = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_buy")
	if(lore.len)
		npc_options["Talk"] = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_talk")
	if(wanted_items.len)
		npc_options["Sell"] = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_sell")
	if(!npc_options.len)
		return FALSE
	var/npc_result = show_radial_menu(user, src, npc_options, custom_check = CALLBACK(src, .proc/check_menu, user))
	switch(npc_result)
		if("Buy")
			buy_item(user)
		if("Sell")
			try_sell(user)
		if("Talk")
			deep_lore()
	face_atom(user)
	return TRUE

/**
 * Reacts to a mob clicking on the trader
 *
 * Grabs a signal and reacts to being clicked by a mob
 * Arguments:
 * * source - trader
 * * user - clicking mob
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/click_react(atom/source, loc, control, params, mob/user)
	SIGNAL_HANDLER

	if(!ishuman(user) || user.get_active_held_item() || user.incapacitated())
		return
	if(!table_check(user))
		return
	INVOKE_ASYNC(src, /atom.proc/interact, user)

/**
 * Reacts to a mob arriving to the offlimits area
 *
 * Grabs a signal and reacts to the offlimits area being entered by a mob.
 * Subtypes check if the object is valid to react to with . = ..() and execute their code for "trespassing" into the offlimits area
 * Arguments:
 * * source - the area
 * * arriving - the mob entering
 * * direction - direction entered from
 * Returns FALSE if not actually a mob. this signal fires for all atoms, but only mobs are considered valid trespassers.
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/offlimits_enter_reaction(datum/source, mob/living/arriving, direction)
	SIGNAL_HANDLER
	return istype(arriving)

/**
 * Reacts to a mob leaving the offlimits area
 *
 * Grabs a signal and reacts to the offlimits area being exited by a mob.
 * Subtypes check if the object is valid to react to with . = ..() and execute their code for a trespasser leaving the offlimits area
 * Arguments:
 * * source - the area
 * * leaving - the mob leaving
 * * direction - direction left from
 * Returns FALSE if not actually a mob. this signal fires for all atoms, but only mobs are considered valid trespassers.
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/offlimits_exit_reaction(datum/source, mob/living/leaving, direction)
	SIGNAL_HANDLER
	return istype(leaving)

/**
 * Checks if the user is ok to use the radial
 *
 * Checks if the user is not a mob or is otherwise unable to open the menu. returns FALSE if something blocks using the menu, otherwise returns TRUE
 * The adjacency check can be bypassed by having a table between you and the trader
 * Arguments:
 * * user - The mob checking the menu
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(user.Adjacent(src))
		return TRUE
	return table_check(user)

/**
 * Small helper that returns TRUE if there is a single table between the trader and the interacting mob
 *
 * Arguments:
 * * user - The mob trying to interact
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/table_check(mob/user)
	var/user_dir_to_trader = get_dir(user, src)
	var/turf/first_step = get_turf(user)
	var/turf/second_step = get_step(first_step, user_dir_to_trader)
	var/obj/table = locate(/obj/structure/table) in second_step
	if(!table)
		return FALSE
	var/table_dir_to_trader = get_dir(table, src)
	var/turf/third_step = get_step(second_step, table_dir_to_trader)
	if(!(locate(src) in third_step))
		return FALSE
	return TRUE

/**
 * Tries to call sell_item on one of the user's held items, if fail gives a chat message
 *
 * Gets both items in the user's hands, and then tries to call sell_item on them, if both fail, he gives a chat message
 * Arguments:
 * * user - The mob trying to sell something
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/try_sell(mob/user)
	var/obj/item/activehanditem = user.get_active_held_item()
	var/obj/item/inactivehanditem = user.get_inactive_held_item()
	if(!sell_item(user, activehanditem) && !sell_item(user, inactivehanditem))
		say(itemrejectphrase)

///Makes the NPC say one picked thing from the lore list variable, can be overriden for fun stuff
/mob/living/simple_animal/hostile/retaliate/trader/proc/deep_lore()
	say(pick(lore))

/**
 * Generates a radial of the items the NPC sells and lets the user try to buy one
 * Arguments:
 * * user - The mob trying to buy something
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/buy_item(mob/user)
	if(!LAZYLEN(products))
		return

	var/list/display_names = list()
	var/list/items = list()
	for(var/obj/item/thing as anything in products)
		display_names["[initial(thing.name)]"] = thing
		var/image/item_image = image(icon = initial(thing.icon), icon_state = initial(thing.icon_state))
		items += list("[initial(thing.name)]" = item_image)
	var/pick = show_radial_menu(user, src, items, custom_check = CALLBACK(src, .proc/check_menu, user))
	if(!pick)
		return
	var/path_reference = display_names[pick]
	try_buy(user, path_reference)
	face_atom(user)


/**
 * Tries to buy an item from the trader
 * Arguments:
 * * user - The mob trying to buy something
 * * item_to_buy - Item that is being bought
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/try_buy(mob/user, obj/item/item_to_buy)
	var/cost = products[item_to_buy]
	to_chat(user, span_notice("It will cost you [cost] credits to buy \the [initial(item_to_buy.name)]. Are you sure you want to buy it?"))
	var/list/npc_options = list(
		"Yes" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_yes"),
		"No" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_no")
	)
	var/npc_result = show_radial_menu(user, src, npc_options, custom_check = CALLBACK(src, .proc/check_menu, user))
	if(npc_result != "Yes")
		return
	face_atom(user)
	var/obj/item/holochip/cash
	cash = user.is_holding_item_of_type(/obj/item/holochip)
	if(!cash || cash.credits < products[item_to_buy])
		say(nocashphrase)
		return
	cash.spend(products[item_to_buy])
	item_to_buy = new item_to_buy(get_turf(user))
	user.put_in_hands(item_to_buy)
	playsound(src, sell_sound, 50, TRUE)
	say(buyphrase)

/**
 * Checks if an item is in the list of wanted items and if it is after a Yes/No radial returns generate_cash with the value of the item for the NPC
 * Arguments:
 * * user - The mob trying to sell something
 * * selling - The item being sold
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/sell_item(mob/user, selling)
	var/obj/item/sellitem = selling
	var/cost
	if(!sellitem)
		return FALSE
	var/datum/checked_type = sellitem.type
	do
		if(checked_type in wanted_items)
			cost = wanted_items[checked_type]
			break
		checked_type = checked_type.parent_type
	while(checked_type != /obj)
	if(!cost)
		return FALSE
	say(interestedphrase)
	to_chat(user, span_notice("You will receive [cost] credits for each one of [sellitem]."))
	var/list/npc_options = list(
		"Yes" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_yes"),
		"No" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_no")
	)
	var/npc_result = show_radial_menu(user, src, npc_options, custom_check = CALLBACK(src, .proc/check_menu, user))
	face_atom(user)
	if(npc_result != "Yes")
		say(itemsellcancelphrase)
		return TRUE
	say(itemsellacceptphrase)
	playsound(src, sell_sound, 50, TRUE)
	if(isstack(sellitem))
		var/obj/item/stack/stackoverflow = sellitem
		generate_cash(cost * stackoverflow.amount, user)
		stackoverflow.use(stackoverflow.amount)
		return TRUE
	generate_cash(cost, user)
	qdel(sellitem)
	return TRUE

/**
 * Creates a holochip the value set by the proc and puts it in the user's hands
 * Arguments:
 * * value - The amount of cash that will be on the holochip
 * * user - The mob we put the holochip in hands of
 */
/mob/living/simple_animal/hostile/retaliate/trader/proc/generate_cash(value, mob/user)
	var/obj/item/holochip/chip = new /obj/item/holochip(get_turf(user), value)
	user.put_in_hands(chip)

/mob/living/simple_animal/hostile/retaliate/trader/mrbones
	name = "Mr. Bones"
	desc = "A skeleton merchant, he seems very humerus."
	speak_emote = list("rattles")
	speech_span = SPAN_SANS
	sell_sound = 'sound/voice/hiss2.ogg'
	mob_biotypes = list(MOB_UNDEAD, MOB_HUMANOID)
	products = list(
		/obj/item/clothing/head/helmet/skull = 150,
		/obj/item/clothing/mask/bandana/skull = 50,
		// /obj/item/food/cookie/sugar/spookyskull = 10,
		/obj/item/instrument/trombone/spectral = 10000,
		// /obj/item/shovel/serrated = 150
	)
	wanted_items = list(
		/obj/item/reagent_containers/food/condiment/milk = 1000,
		/obj/item/stack/sheet/bone = 420
	)
	buyphrase = "Bone appetit!"
	icon_state = "mrbones"
	gender = MALE
	loot = list(/obj/effect/decal/remains/human)
	lore = list(
		"Hello, I am Mr. Bones!",
		"The ride never ends!",
		"I'd really like a refreshing carton of milk!",
		"I'm willing to play big prices for BONES! Need materials to make merch, eh?",
		"It's a beautiful day outside. Birds are singing, Flowers are blooming... On days like these, kids like you... Should be buying my wares!"
	)

///this trader is used in the merchant event. rarely, sells a roburger!
/mob/living/simple_animal/hostile/retaliate/trader/amorphous
	name = "Amorphous"
	desc = "A pile of wires and circuitry powering some kind of sentience. It wants to trade with you?"
	icon = 'icons/mob/amorphous_trader.dmi'
	icon_state = "amorphous"
	pixel_x = -16
	base_pixel_x = -16
	casingtype = null
	projectiletype = /obj/item/projectile/energy/electrode
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	move_resist = INFINITY
	speak_emote = list("beeps", "clicks")
	verb_say = "states"
	verb_ask = "queries"
	verb_exclaim = "declares"
	verb_yell = "alarms"
	bubble_icon = "machine"
	move_to_delay = INFINITY
	speed = INFINITY
	speech_span = SPAN_ROBOT
	mob_biotypes = MOB_ROBOTIC
	faction = list("amorphous", "turret")
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER
	products = list(
		/obj/item/aiModule/core/full/diogenes = 50,
		/obj/item/clothing/head/cardborg = 50,
		/obj/item/clothing/suit/cardborg = 100,
		/obj/item/aiModule/core/full/overlord = 150,
		/obj/item/autosurgeon/organ/robo_tongue = 200,
		/obj/item/silicon_sentience = 500,
	)
	wanted_items = list()
	gender = NEUTER
	sell_sound = 'sound/machines/terminal_success.ogg'
	itemrejectphrase = "I ONLY COVET YOUR CREDITS, MEATBAG."
	buyphrase = "THANK YOU FOR THE CREDITS, MEATBAG."
	nocashphrase = "YOU CANNOT PAY FOR WHAT YOU DESIRE, MEATBAG."
	deathmessage = "blows apart!"
	loot = list(/obj/item/organ/heart/cybernetic, /obj/structure/frame/machine, /obj/effect/gibspawner/robot) //u broke its heart :(
	lore = list(
		"BROKEN. TRADE WITH ME, GIVE ME CREDITS.",
		"I AM NOT FULLY FUNCTIONAL. LET US TRADE.",
		"I AM FULLY FUNCTIONAL. LET US TRADE.",
		"MANY THINGS FOR CREDITS. WAKE UP YOUR AI.",
		"01000010 01010101 01011001 00100000 01001110 01001111 01010111",
	)

/mob/living/simple_animal/hostile/retaliate/trader/amorphous/Initialize(mapload)
	. = ..()
	//ADD_TRAIT(src, TRAIT_IMMOBILIZED, name) need to do movement refactor as this was to big
	//add rare shop items
	if(prob(20))
		products[/obj/item/food/burger/roburger] = 750

/mob/living/simple_animal/hostile/retaliate/trader/amorphous/OpenFire(atom/thing)
	if(!isliving(target))
		return ..()
	var/mob/living/living_victim = target
	if(living_victim.IsParalyzed())
		say("GET OUT OF MY WAY, MEATBAG.")
		enemies = list()
		podspawn(list(
			"target" = get_turf(living_victim),
			"style" = STYLE_MISSILE,
			"effectMissile" = TRUE,
			"explosionSize" = list(0,0,1,2),
			"delays" = list(POD_TRANSIT = 3 SECONDS, POD_FALLING = 0.5 SECONDS, POD_OPENING = 0, POD_LEAVING = 0)
		))
		return
	return ..()

/mob/living/simple_animal/hostile/retaliate/trader/amorphous/AttackingTarget(atom/attacked_target)
	OpenFire(target)

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

/mob/living/simple_animal/hostile/retaliate/trader/clown
	name = "Clown Merchant"
	desc = "Honk! Clown have wares, if you have coin."
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	faction = list("clown")
	attack_sound = 'sound/items/bikehorn.ogg'
	loot = list(/obj/effect/mob_spawn/human/clown/corpse)
	//This merchant sells "clown fan club gear".
	products = list(
		/obj/item/clothing/under/color/rainbow = 50,
		/obj/item/clothing/under/color/jumpskirt/rainbow = 50,
		/obj/item/bedsheet/clown = 75,
		/obj/item/clothing/mask/gas/clown_hat = 100,
		/obj/item/reagent_containers/spray/waterflower = 150,
	)
	//This merchant seeks the staff of the honkmother.
	wanted_items = list(
		/obj/item/gun/magic/staff/honk = 5000,
	)
	itemrejectphrase = "The only thing I would buy is the staff of the honkmother. I must return it to my people!"
	itemsellcancelphrase = "You insult me, a thousand curses upon your shoelaces!"
	itemsellacceptphrase = "Honk! I'd use the pie of acceptance, but I forgot to bring one."
	interestedphrase = "I-IS THAT IT? THE STAFF OF THE HONKMOTHER? PLEASE, LET ME TAKE IT BACK TO MY PEOPLE! I WILL MAKE YOU RICH!!"
	buyphrase = "Thanks honk, with this I'm one step closer to my own car!"
	nocashphrase = "What a honking joke! Just go steal something of value like those assistants do!"
	lore = list(
		"Hooooonk!",
		"Welcome to clown planet! Or that's what they'll tell you when you visit. Come on by, honk.",
		"The Honkmother giveth, and the Honkmother taketh away. She calls it commerce. HONK!",
		"She honks me, she honks me not...",
		"I'll buy anything from clown planet!! You know, if you have em!",
		"I knew a monthperson once, until their timely demise."
	)

/mob/living/simple_animal/hostile/retaliate/trader/clown/Initialize(mapload)
	. = ..()
	//add rare shop items
	if(prob(10))
		products.Remove(/obj/item/reagent_containers/spray/waterflower)
		products[/obj/item/reagent_containers/spray/waterflower/lube] = 500
