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
