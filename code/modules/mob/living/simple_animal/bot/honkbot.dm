/mob/living/simple_animal/bot/honkbot
	name = "\improper honkbot"
	desc = "A little robot. It looks happy with its bike horn."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "honkbot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	pass_flags = PASSMOB

	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_THEATRE)
	radio_key = /obj/item/encryptionkey/headset_service //doesn't have security key
	radio_channel = RADIO_CHANNEL_SERVICE //Doesn't even use the radio anyway.
	bot_type = HONK_BOT
	data_hud_type = DATA_HUD_SECURITY_BASIC // show jobs
	hackables = "sound control systems"
	path_image_color = "#FF69B4"

	var/honksound = 'sound/items/bikehorn.ogg' //customizable sound
	var/spam_flag = FALSE
	var/cooldowntime = 30
	var/cooldowntimehorn = 10
	var/mob/living/carbon/target
	var/oldtarget_name
	var/target_lastloc = FALSE	//Loc of target when arrested.
	var/last_found = FALSE	//There's a delay
	var/threatlevel = FALSE
	var/declare_arrests = FALSE // speak, you shall not, unless to Honk
	var/idcheck = TRUE
	var/fcheck = TRUE
	var/check_records = TRUE
	var/arrest_type = FALSE
	var/weaponscheck = TRUE
	var/bikehorn = /obj/item/bikehorn

/mob/living/simple_animal/bot/honkbot/Initialize(mapload)
	. = ..()
	update_icon()
	bot_mode_flags |= BOT_MODE_AUTOPATROL
	var/datum/job/clown/J = new/datum/job/clown
	access_card.access += J.get_access()
	prev_access = access_card.access

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/mob/living/simple_animal/bot/honkbot/proc/spam_flag_false() //used for addtimer
	spam_flag = FALSE

/mob/living/simple_animal/bot/honkbot/proc/sensor_blink()
	icon_state = "honkbot-c"
	addtimer(CALLBACK(src, /atom/.proc/update_icon), 5, TIMER_OVERRIDE|TIMER_UNIQUE)

//honkbots react with sounds.
/mob/living/simple_animal/bot/honkbot/proc/react_ping()
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE, -1) //the first sound upon creation!
	spam_flag = TRUE
	sensor_blink()
	addtimer(CALLBACK(src, .proc/spam_flag_false), 18) // calibrates before starting the honk

/mob/living/simple_animal/bot/honkbot/proc/react_buzz()
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE, -1)
	sensor_blink()

/mob/living/simple_animal/bot/honkbot/bot_reset()
	..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	SSmove_manager.stop_looping(src)
	last_found = world.time
	spam_flag = FALSE

/mob/living/simple_animal/bot/honkbot/proc/judgment_criteria()
	var/final = NONE
	if(check_records)
		final |= JUDGE_RECORDCHECK
	if(bot_cover_flags & BOT_COVER_EMAGGED)
		final |= JUDGE_EMAGGED
	return final

/mob/living/simple_animal/bot/honkbot/proc/retaliate(mob/living/carbon/human/H)
	var/judgment_criteria = judgment_criteria()
	threatlevel = H.assess_threat(judgment_criteria)
	threatlevel += 6
	if(threatlevel >= 4)
		target = H
		mode = BOT_HUNT

/mob/living/simple_animal/bot/honkbot/attack_hand(mob/living/carbon/human/H)
	if(H.a_intent == "harm")
		retaliate(H)
		addtimer(CALLBACK(src, .proc/react_buzz), 5)
	return ..()


/mob/living/simple_animal/bot/honkbot/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour != TOOL_SCREWDRIVER && (W.force) && (!target) && (W.damtype != STAMINA) )
		retaliate(user)
		addtimer(CALLBACK(src, .proc/react_buzz), 5)
	..()

/mob/living/simple_animal/bot/honkbot/emag_act(mob/user)
	..()
	if(!(bot_cover_flags & BOT_COVER_EMAGGED))
		return
	if(user)
		to_chat(user, span_danger("You short out [src]'s sound control system. It gives out an evil laugh!!"))
		oldtarget_name = user.name
	audible_message(span_danger("[src] gives out an evil laugh!"))
	playsound(src, 'sound/machines/honkbot_evil_laugh.ogg', 75, TRUE, -1) // evil laughter
	update_appearance()

/mob/living/simple_animal/bot/honkbot/bullet_act(obj/item/projectile/Proj)
	if((istype(Proj,/obj/item/projectile/beam)) || (istype(Proj,/obj/item/projectile/bullet) && (Proj.damage_type == BURN))||(Proj.damage_type == BRUTE) && (!Proj.nodamage && Proj.damage < health && ishuman(Proj.firer)))
		retaliate(Proj.firer)
	return ..()

/mob/living/simple_animal/bot/honkbot/UnarmedAttack(atom/A)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(bot_cover_flags & BOT_COVER_EMAGGED)
			honk_attack(A)
		else
			if(!C.IsParalyzed() || arrest_type)
				stun_attack(A)
		..()
	else if (!spam_flag) //honking at the ground
		bike_horn(A)


/mob/living/simple_animal/bot/honkbot/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(istype(AM, /obj/item))
		playsound(src, honksound, 50, TRUE, -1)
		var/obj/item/I = AM
		var/mob/thrown_by = I.thrownby?.resolve()
		if(I.throwforce < health && thrown_by && (istype(thrown_by, /mob/living/carbon/human)))
			var/mob/living/carbon/human/H = thrown_by
			retaliate(H)
	..()

/mob/living/simple_animal/bot/honkbot/proc/bike_horn() //use bike_horn
	if(bot_cover_flags & BOT_COVER_EMAGGED) //emagged honkbots will spam short and memorable sounds.
		if (!spam_flag)
			playsound(src, "honkbot_e", 50, FALSE)
			spam_flag = TRUE // prevent spam
			icon_state = "honkbot-e"
			addtimer(CALLBACK(src, /atom/.proc/update_appearance), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)
		addtimer(CALLBACK(src, .proc/spam_flag_false), cooldowntimehorn)
		return
	if (!spam_flag)
		playsound(src, honksound, 50, TRUE, -1)
		spam_flag = TRUE //prevent spam
		sensor_blink()
		addtimer(CALLBACK(src, .proc/spam_flag_false), cooldowntimehorn)

/mob/living/simple_animal/bot/honkbot/proc/honk_attack(mob/living/carbon/C) // horn attack
	if(!spam_flag)
		playsound(loc, honksound, 50, TRUE, -1)
		spam_flag = TRUE // prevent spam
		sensor_blink()
		addtimer(CALLBACK(src, .proc/spam_flag_false), cooldowntimehorn)

/mob/living/simple_animal/bot/honkbot/proc/stun_attack(mob/living/carbon/C) // airhorn stun
	if(!spam_flag)
		playsound(src, 'sound/items/AirHorn.ogg', 100, TRUE, -1) //HEEEEEEEEEEEENK!!
		sensor_blink()
	if(spam_flag == 0)
		if(ishuman(C))
			C.stuttering = 20
			C.adjustEarDamage(0, 5) //far less damage than the H.O.N.K.
			C.Jitter(50)
			C.Paralyze(60)
			var/mob/living/carbon/human/H = C
			if(client) //prevent spam from players..
				spam_flag = TRUE
			if(bot_cover_flags & BOT_COVER_EMAGGED) // you really don't want to hit an emagged honkbot
				threatlevel = 6 // will never let you go
			else
				//HONK once, then leave
				var/judgment_criteria = judgment_criteria()
				threatlevel = H.assess_threat(judgment_criteria)
				threatlevel -= 6
				target = oldtarget_name
			addtimer(CALLBACK(src, .proc/spam_flag_false), cooldowntime)

			log_combat(src,C,"honked")

			C.visible_message("<span class='danger'>[src] has honked [C]!</span>",\
					"<span class='userdanger'>[src] has honked you!</span>")
		else
			C.stuttering = 20
			C.Paralyze(80)
			addtimer(CALLBACK(src, .proc/spam_flag_false), cooldowntime)


/mob/living/simple_animal/bot/honkbot/handle_automated_action()
	if(!..())
		return

	switch(mode)

		if(BOT_IDLE)		// idle

			SSmove_manager.stop_looping(src)
			look_for_perp()
			if(!mode && bot_mode_flags & BOT_MODE_AUTOPATROL)
				mode = BOT_START_PATROL

		if(BOT_HUNT)

			// if can't reach perp for long enough, go idle
			if(frustration >= 5) //gives up easier than beepsky
				SSmove_manager.stop_looping(src)
				back_to_idle()
				return

			if(target)		// make sure target exists
				if(Adjacent(target) && isturf(target.loc))

					if(threatlevel <= 4)
						honk_attack(target)
					else
						if(threatlevel >= 6)
							set waitfor = 0
							stun_attack(target)
							anchored = FALSE
							target_lastloc = target.loc
					return

				else	// not next to perp
					var/turf/olddist = get_dist(src, target)
					SSmove_manager.move_to(src, target, 1, 4)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0
			else
				back_to_idle()


		if(BOT_START_PATROL)
			look_for_perp()
			start_patrol()

		if(BOT_PATROL)
			look_for_perp()
			bot_patrol()

	return

/mob/living/simple_animal/bot/honkbot/proc/back_to_idle()
	anchored = FALSE
	mode = BOT_IDLE
	target = null
	last_found = world.time
	frustration = 0
	INVOKE_ASYNC(src, .proc/handle_automated_action) //responds quickly

/mob/living/simple_animal/bot/honkbot/proc/back_to_hunt()
	anchored = FALSE
	frustration = 0
	mode = BOT_HUNT
	INVOKE_ASYNC(src, .proc/handle_automated_action) // responds quickly

/mob/living/simple_animal/bot/honkbot/proc/look_for_perp()
	anchored = FALSE
	for (var/mob/living/carbon/C in view(7,src))
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		var/judgment_criteria = judgment_criteria()
		threatlevel = C.assess_threat(judgment_criteria)

		if(threatlevel <= 3 && get_dist(C, src) <= 4 && !spam_flag)
			bike_horn()

		else if(threatlevel >= 10)
			bike_horn() //just spam the shit outta this

		else if(threatlevel >= 4)
			if(!spam_flag)
				target = C
				oldtarget_name = C.name
				bike_horn()
				speak("Honk!")
				visible_message("<b>[src]</b> starts chasing [C.name]!")
				mode = BOT_HUNT
				INVOKE_ASYNC(src, .proc/handle_automated_action)
				break
			else
				continue

/mob/living/simple_animal/bot/honkbot/explode()
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/atom/Tsec = drop_location()
	//doesn't drop cardboard nor its assembly, since its a very frail material.
	new bikehorn(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)

	var/datum/effect_system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	..()

/mob/living/simple_animal/bot/honkbot/attack_alien(var/mob/living/carbon/alien/user as mob)
	..()
	if(!isalien(target))
		target = user
		mode = BOT_HUNT

/mob/living/simple_animal/bot/honkbot/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(ismob(AM) && (bot_mode_flags & BOT_MODE_ON)) //only if its online
		if(prob(30)) //you're far more likely to trip on a honkbot
			var/mob/living/carbon/C = AM
			if(!istype(C) || !C || in_range(src, target))
				return
			C.visible_message("<span class='warning'>[pick( \
						  	"[C] dives out of [src]'s way!", \
						  	"[C] stumbles over [src]!", \
						  	"[C] jumps out of [src]'s path!", \
						  	"[C] trips over [src] and falls!", \
						  	"[C] topples over [src]!", \
						  	"[C] leaps out of [src]'s way!")]</span>")
			C.Paralyze(10)
			playsound(loc, 'sound/misc/sadtrombone.ogg', 50, 1, -1)
			if(!client)
				INVOKE_ASYNC(src, /mob/living/simple_animal/bot/proc/speak, "Honk!")
			sensor_blink()
			return
