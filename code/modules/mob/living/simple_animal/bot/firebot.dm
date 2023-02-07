//Firebot

#define SPEECH_INTERVAL 300  // Time between idle speeches
#define DETECTED_VOICE_INTERVAL 300  // Time between fire detected callouts
#define FOAM_INTERVAL 50  // Time between deployment of fire fighting foam

/mob/living/simple_animal/bot/firebot
	name = "\improper Firebot"
	desc = "A little fire extinguishing bot. He looks rather anxious."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "firebot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	spacewalk = TRUE

	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_CONSTRUCTION)
	radio_key = /obj/item/encryptionkey/headset_eng
	radio_channel = RADIO_CHANNEL_ENGINEERING
	bot_type = FIRE_BOT
	hackables = "fire safety protocols"
	path_image_color = "#FFA500"

	var/atom/target_fire
	var/atom/old_target_fire

	var/obj/item/extinguisher/internal_ext

	var/last_found = 0

	var/speech_cooldown = 0
	var/detected_cooldown = 0
	var/foam_cooldown = 0

	var/extinguish_people = TRUE
	var/extinguish_fires = TRUE
	var/stationary_mode = FALSE

/mob/living/simple_animal/bot/firebot/Initialize(mapload)
	. = ..()
	update_icon()
	var/datum/job/engineer/J = new/datum/job/engineer
	access_card.access += J.get_access()
	prev_access = access_card.access

	create_extinguisher()

/mob/living/simple_animal/bot/firebot/bot_reset()
	create_extinguisher()

/mob/living/simple_animal/bot/firebot/proc/create_extinguisher()
	internal_ext = new /obj/item/extinguisher(src)
	internal_ext.safety = FALSE
	internal_ext.precision = TRUE
	internal_ext.max_water = INFINITY
	internal_ext.refill()

/mob/living/simple_animal/bot/firebot/UnarmedAttack(atom/A)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(internal_ext)
		internal_ext.afterattack(A, src)
	else
		return ..()

/mob/living/simple_animal/bot/firebot/RangedAttack(atom/A)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(internal_ext)
		internal_ext.afterattack(A, src)
	else
		return ..()

/mob/living/simple_animal/bot/firebot/turn_on()
	. = ..()
	update_icon()

/mob/living/simple_animal/bot/firebot/turn_off()
	..()
	update_icon()

/mob/living/simple_animal/bot/firebot/bot_reset()
	..()
	target_fire = null
	old_target_fire = null
	ignore_list = list()
	anchored = FALSE
	update_icon()

/mob/living/simple_animal/bot/firebot/proc/soft_reset()
	path = list()
	target_fire = null
	mode = BOT_IDLE
	last_found = world.time
	update_icon()

/mob/living/simple_animal/bot/firebot/emag_act(mob/user)
	..()
	if(!(bot_cover_flags & BOT_COVER_EMAGGED))
		return
	if(user)
		to_chat(user, span_danger("[src] buzzes and beeps."))
	audible_message(span_danger("[src] buzzes oddly!"))
	playsound(src, "sparks", 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	if(user)
		old_target_fire = user
	extinguish_fires = FALSE
	extinguish_people = TRUE

	internal_ext = new /obj/item/extinguisher(src)
	internal_ext.chem = /datum/reagent/clf3 //Refill the internal extinguisher with liquid fire
	internal_ext.power = 3
	internal_ext.safety = FALSE
	internal_ext.precision = FALSE
	internal_ext.max_water = INFINITY
	internal_ext.refill()

// Variables sent to TGUI
/mob/living/simple_animal/bot/firebot/ui_data(mob/user)
	var/list/data = ..()
	if(!(bot_cover_flags & BOT_COVER_LOCKED) || issilicon(user) || IsAdminGhost(user))
		data["custom_controls"]["extinguish_fires"] = extinguish_fires
		data["custom_controls"]["extinguish_people"] = extinguish_people
		data["custom_controls"]["stationary_mode"] = stationary_mode
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/firebot/ui_act(action, params)
	. = ..()
	if(. || (bot_cover_flags & BOT_COVER_LOCKED && !usr.has_unlimited_silicon_privilege))
		return
	switch(action)
		if("extinguish_fires")
			extinguish_fires = !extinguish_fires
		if("extinguish_people")
			extinguish_people = !extinguish_people
		if("stationary_mode")
			stationary_mode = !stationary_mode
			update_appearance()
	return

/mob/living/simple_animal/bot/firebot/proc/is_burning(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.on_fire || (bot_cover_flags & BOT_COVER_EMAGGED && !M.on_fire))
			return TRUE

	else if(isturf(target))
		var/turf/open/T = target
		if(T.active_hotspot)
			return TRUE

	return FALSE

/mob/living/simple_animal/bot/firebot/handle_automated_action()
	if(!..())
		return

	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		old_target_fire = target_fire
		target_fire = null
		mode = BOT_IDLE
		return

	if(prob(1) && target_fire == null)
		var/list/messagevoice = list("No fires detected." = 'sound/voice/firebot/nofires.ogg',
		"Only you can prevent station fires." = 'sound/voice/firebot/onlyyou.ogg',
		"Temperature nominal." = 'sound/voice/firebot/tempnominal.ogg',
		"Keep it cool." = 'sound/voice/firebot/keepitcool.ogg')
		var/message = pick(messagevoice)
		speak(message)
		playsound(src, messagevoice[message], 50)

	// Couldn't reach the target, reset and try again ignoring the old one
	if(frustration > 8)
		old_target_fire = target_fire
		soft_reset()

	// We extinguished our target or it was deleted
	if(QDELETED(target_fire) || !is_burning(target_fire) || isdead(target_fire))
		target_fire = null
		var/scan_range = (stationary_mode ? 1 : DEFAULT_SCAN_RANGE)

		var/list/things_to_extinguish = list()
		if(extinguish_people)
			things_to_extinguish += list(/mob/living)

		if(target_fire == null && extinguish_fires)
			things_to_extinguish += list(/turf/open)

		target_fire = scan(things_to_extinguish, old_target_fire, scan_range) // Scan for burning turfs second
		old_target_fire = target_fire

	// Target reached ENGAGE WATER CANNON
	if(target_fire && (get_dist(src, target_fire) <= (bot_cover_flags & BOT_COVER_EMAGGED ? 1 : 2))) // Make the bot spray water from afar when not emagged
		if((speech_cooldown + SPEECH_INTERVAL) < world.time)
			if(ishuman(target_fire))
				speak("Stop, drop and roll!")
				playsound(src, "sound/voice/firebot/stopdropnroll.ogg", 50, 0)
			else
				speak("Extinguishing!")
				playsound(src, "sound/voice/firebot/extinguishing.ogg", 50, 0)
			speech_cooldown = world.time

			flick("firebot1_use", src)
			spray_water(target_fire, src)

		soft_reset()

	// Target ran away
	else if(target_fire && path.len && (get_dist(target_fire,path[path.len]) > 2))
		path = list()
		mode = BOT_IDLE
		last_found = world.time

	else if(target_fire && stationary_mode)
		soft_reset()
		return

	if(target_fire && (get_dist(src, target_fire) > 2))

		path = get_path_to(src, target_fire, 30, 1, id=access_card)
		mode = BOT_MOVING
		if(!path.len)
			soft_reset()

	if(path.len > 0 && target_fire)
		if(!bot_move(path[path.len]))
			old_target_fire = target_fire
			soft_reset()
		return

	// We got a target but it's too far away from us
	if(path.len > 8 && target_fire)
		frustration++

	if(bot_mode_flags & BOT_MODE_AUTOPATROL && !target_fire)
		if(mode == BOT_IDLE || mode == BOT_START_PATROL)
			start_patrol()

		if(mode == BOT_PATROL)
			bot_patrol()


//Look for burning people or turfs around the bot
/mob/living/simple_animal/bot/firebot/process_scan(atom/scan_target)
	var/result

	if(scan_target == src)
		return result

	if(is_burning(scan_target))
		if((detected_cooldown + DETECTED_VOICE_INTERVAL) < world.time)
			speak("Fire detected!")
			playsound(src, "sound/voice/firebot/detected.ogg", 50, 0)
			detected_cooldown = world.time
		result = scan_target

	return result

/mob/living/simple_animal/bot/firebot/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if((temperature > T0C + 200 || temperature < BODYTEMP_COLD_DAMAGE_LIMIT) && foam_cooldown + FOAM_INTERVAL < world.time)
		new /obj/effect/particle_effect/foam/firefighting(loc)
		foam_cooldown = world.time
	..()

/mob/living/simple_animal/bot/firebot/proc/spray_water(atom/target, mob/user)
	if(stationary_mode)
		flick("firebots_use", user)
	else
		flick("firebot1_use", user)
	internal_ext.afterattack(target, user, null)

/mob/living/simple_animal/bot/firebot/update_icon()
	if(!(bot_mode_flags & BOT_MODE_ON))
		icon_state = "firebot0"
		return
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		icon_state = "firebots1"
	else if(stationary_mode) //Bot has yellow light to indicate stationary mode.
		icon_state = "firebots1"
	else
		icon_state = "firebot1"


/mob/living/simple_animal/bot/firebot/explode()
	bot_mode_flags &= ~BOT_MODE_ON
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")

	var/atom/Tsec = drop_location()

	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/clothing/head/hardhat/red(Tsec)

	var/turf/T = get_turf(Tsec)

	if(isopenturf(T))
		var/turf/open/theturf = T
		theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

	do_sparks(3, TRUE, src)
	..()

#undef SPEECH_INTERVAL
#undef DETECTED_VOICE_INTERVAL
#undef FOAM_INTERVAL

