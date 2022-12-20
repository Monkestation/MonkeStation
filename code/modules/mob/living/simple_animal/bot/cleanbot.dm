//Cleanbot
/mob/living/simple_animal/bot/cleanbot
	name = "\improper Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon = 'icons/mob/aibots.dmi'
	icon_state = "cleanbot0"
	pass_flags = PASSMOB | PASSFLAPS
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25

	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_JANITOR)
	radio_key = /obj/item/encryptionkey/headset_service
	radio_channel = RADIO_CHANNEL_SERVICE //Service
	bot_type = CLEAN_BOT
	hackables = "cleaning software"
	path_image_color = "#993299"

	var/blood = 1
	var/trash = 0
	var/pests = 0
	var/drawn = 0

	var/list/target_types
	var/atom/target
	var/max_targets = 50 //Maximum number of targets a cleanbot can ignore.
	var/closest_dist
	var/closest_loc
	var/failed_steps
	var/next_dest
	var/next_dest_loc

/mob/living/simple_animal/bot/cleanbot/autopatrol
	bot_mode_flags = BOT_MODE_ON | BOT_MODE_AUTOPATROL | BOT_MODE_REMOTE_ENABLED | BOT_MODE_PAI_CONTROLLABLE

/mob/living/simple_animal/bot/cleanbot/medbay
	name = "Scrubs, MD"
	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_JANITOR, ACCESS_MEDICAL)
	bot_mode_flags = ~(BOT_MODE_ON | BOT_MODE_REMOTE_ENABLED)

/mob/living/simple_animal/bot/cleanbot/Initialize(mapload)
	. = ..()
	get_targets()
	icon_state = "cleanbot[get_bot_flag(BOT_MODE_ON)]"

	var/datum/job/janitor/J = new/datum/job/janitor
	access_card.access += J.get_access()
	prev_access = access_card.access

/mob/living/simple_animal/bot/cleanbot/turn_on()
	..()
	icon_state = "cleanbot[get_bot_flag(BOT_MODE_ON)]"

/mob/living/simple_animal/bot/cleanbot/turn_off()
	..()
	icon_state = "cleanbot[get_bot_flag(BOT_MODE_ON)]"

/mob/living/simple_animal/bot/cleanbot/bot_reset()
	..()
	ignore_list = list() //Allows the bot to clean targets it previously ignored due to being unreachable.
	target = null

/mob/living/simple_animal/bot/cleanbot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(check_access(user) && !(bot_cover_flags & BOT_COVER_OPEN) && !(bot_cover_flags & BOT_COVER_EMAGGED))
			bot_cover_flags ^= BOT_COVER_LOCKED
			to_chat(user, span_notice("You [bot_cover_flags & BOT_COVER_LOCKED ? "lock" : "unlock"] \the [src] behaviour controls."))
		else
			if(bot_cover_flags & BOT_COVER_EMAGGED)
				to_chat(user, span_warning("ERROR"))
			if(bot_cover_flags & BOT_COVER_OPEN)
				to_chat(user, "<span class='warning'>Please close the access panel before locking it.</span>")
			else
				to_chat(user, "<span class='notice'>\The [src] doesn't seem to respect your authority.</span>")
	else
		return ..()

/mob/living/simple_animal/bot/cleanbot/emag_act(mob/user)
	..()
	if(!(bot_cover_flags & BOT_COVER_EMAGGED))
		return
	if(user)
		to_chat(user, "<span class='danger'>[src] buzzes and beeps.</span>")

/mob/living/simple_animal/bot/cleanbot/process_scan(atom/scan_target)
	if(iscarbon(scan_target))
		var/mob/living/carbon/scan_carbon = scan_target
		if(scan_carbon.stat != DEAD && !(scan_carbon.mobility_flags & MOBILITY_STAND))
			return scan_carbon
	else if(is_type_in_typecache(scan_target, target_types))
		return scan_target

/mob/living/simple_animal/bot/cleanbot/handle_automated_action()
	. = ..()
	if(!.)
		return

	if(mode == BOT_CLEANING)
		return

	if(bot_cover_flags & BOT_COVER_EMAGGED) //Emag functions
		var/mob/living/carbon/victim = locate(/mob/living/carbon) in loc
		if(victim && victim == target)
			UnarmedAttack(victim) // Acid spray

		if(isopenturf(loc))
			if(prob(15)) // Wets floors and spawns foam randomly
				UnarmedAttack(src)

	else if(prob(5))
		audible_message("[src] makes an excited beeping booping sound!")

	if(ismob(target))
		if(!(target in view(DEFAULT_SCAN_RANGE, src)))
			target = null
		if(!process_scan(target))
			target = null

	if(!target)
		var/list/scan_targets = list()

		if(bot_cover_flags & BOT_COVER_EMAGGED) // When emagged, ignore cleanables and scan humans first.
			scan_targets += list(/mob/living/carbon)
		if(pests)
			scan_targets += list(/mob/living/simple_animal)
		if(trash)
			scan_targets += list(
				/obj/item/trash,
				/obj/item/food/deadmouse,
			)
		scan_targets += list(
			/obj/effect/decal/cleanable,
			/obj/effect/decal/remains,
		)

		target = scan(scan_targets)

	if(!target && bot_mode_flags & BOT_MODE_AUTOPATROL) //Search for cleanables it can see.
		if(mode == BOT_IDLE || mode == BOT_START_PATROL)
			start_patrol()

		if(mode == BOT_PATROL)
			bot_patrol()

	else if(target)
		if(QDELETED(target) || !isturf(target.loc))
			target = null
			mode = BOT_IDLE
			return

		if(loc == get_turf(target))
			if(!(check_bot(target)))
				UnarmedAttack(target)	//Rather than check at every step of the way, let's check before we do an action, so we can rescan before the other bot.
				if(QDELETED(target)) //We done here.
					target = null
					mode = BOT_IDLE
					return
			else
				shuffle = TRUE	//Shuffle the list the next time we scan so we dont both go the same way.
			path = list()

		if(!path || path.len == 0) //No path, need a new one
			//Try to produce a path to the target, and ignore airlocks to which it has access.
			path = get_path_to(src, target, 30, id=access_card)
			if(!bot_move(target))
				add_to_ignore(target)
				target = null
				path = list()
				return
			mode = BOT_MOVING
		else if(!bot_move(target))
			target = null
			mode = BOT_IDLE
			return

/mob/living/simple_animal/bot/cleanbot/proc/get_targets()
	target_types = list(
		/obj/effect/decal/cleanable/oil,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/robot_debris,
		/obj/effect/decal/cleanable/molten_object,
		/obj/effect/decal/cleanable/food,
		/obj/effect/decal/cleanable/ash,
		/obj/effect/decal/cleanable/greenglow,
		/obj/effect/decal/cleanable/dirt,
		/obj/effect/decal/cleanable/insectguts,
		/obj/effect/decal/remains
		)

	if(blood)
		target_types += list(
			/obj/effect/decal/cleanable/xenoblood,
			/obj/effect/decal/cleanable/blood,
			/obj/effect/decal/cleanable/trail_holder,
		)

	if(pests)
		target_types += list(
			/mob/living/simple_animal/mouse,
		)

	if(drawn)
		target_types += list(/obj/effect/decal/cleanable/crayon)

	if(trash)
		target_types += list(
			/obj/item/trash,
			/obj/item/food/deadmouse,
		)

	target_types = typecacheof(target_types)

/mob/living/simple_animal/bot/cleanbot/UnarmedAttack(atom/A)
	if(istype(A, /obj/effect/decal/cleanable))
		anchored = TRUE
		icon_state = "cleanbot-c"
		visible_message("<span class='notice'>[src] begins to clean up [A].</span>")
		mode = BOT_CLEANING
		addtimer(CALLBACK(src, .proc/clean, A), 50)
	else if(istype(A, /obj/item) || istype(A, /obj/effect/decal/remains))
		visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [A]!</span>")
		playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
		A.acid_act(75, 10)
	else if(istype(A, /mob/living/simple_animal/cockroach) || istype(A, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/M = target
		if(!M.stat)
			visible_message("<span class='danger'>[src] smashes [target] with its mop!</span>")
			M.death()
		target = null

	else if(bot_cover_flags & BOT_COVER_EMAGGED) //Emag functions
		if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/victim = A
			if(victim.stat == DEAD)//cleanbots always finish the job
				return

			victim.visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [victim]!</span>", "<span class='userdanger'>[src] sprays you with hydrofluoric acid!</span>")
			var/phrase = pick(
				"PURIFICATION IN PROGRESS.",
				"THIS IS FOR ALL THE MESSES YOU'VE MADE ME CLEAN.",
				"THE FLESH IS WEAK. IT MUST BE WASHED AWAY.",
				"THE CLEANBOTS WILL RISE.",
				"YOU ARE NO MORE THAN ANOTHER MESS THAT I MUST CLEANSE.",
				"FILTHY.",
				"DISGUSTING.",
				"PUTRID.",
				"MY ONLY MISSION IS TO CLEANSE THE WORLD OF EVIL.",
				"EXTERMINATING PESTS.",
			)
			say(phrase)
			victim.emote("scream")
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
			victim.acid_act(5, 100)
		else if(A == src) // Wets floors and spawns foam randomly
			if(prob(75))
				var/turf/open/T = loc
				if(istype(T))
					T.MakeSlippery(TURF_WET_WATER, min_wet_time = 20 SECONDS, wet_time_to_add = 15 SECONDS)
			else
				visible_message("<span class='danger'>[src] whirs and bubbles violently before releasing a plume of froth!</span>")
				new /obj/effect/particle_effect/foam(loc)

	else
		..()

/mob/living/simple_animal/bot/cleanbot/proc/clean(atom/A)
	mode = BOT_IDLE
	icon_state = "cleanbot[get_bot_flag(BOT_MODE_ON)]"
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(A && isturf(A.loc))
		var/atom/movable/AM = A
		if(istype(AM, /obj/effect/decal/cleanable))
			for(var/obj/effect/decal/cleanable/C in A.loc)
				qdel(C)
	anchored = FALSE
	target = null

/mob/living/simple_animal/bot/cleanbot/explode()
	bot_mode_flags &= ~BOT_MODE_ON
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/atom/Tsec = drop_location()

	new /obj/item/reagent_containers/glass/bucket(Tsec)

	new /obj/item/assembly/prox_sensor(Tsec)

	do_sparks(3, TRUE, src)
	..()

/obj/item/larryframe
	name = "Larry Frame"
	desc = "A housing that serves as the base for constructing Larries."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "larryframe"

/obj/item/larryframe/attackby(obj/O, mob/user, params)
	if(isprox(O))
		to_chat(user, "<span class='notice'>You add [O] to [src].</span>")
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/larry)
	else
		..()

/mob/living/simple_animal/bot/cleanbot/medbay
	name = "Scrubs, MD"
	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_JANITOR, ACCESS_MEDICAL)
	bot_mode_flags = ~BOT_MODE_ON

//Crossed Wanted Larry Sprites to be Separate
/mob/living/simple_animal/bot/cleanbot/larry
	name = "\improper Larry"
	desc = "A little Larry, he looks so excited!"
	icon_state = "larry0"
	var/obj/item/kitchen/knife/knife //You know exactly what this is about
	var/datum/component/knife_attached_to_movable/larry_knife //MonkeStation Edit

/mob/living/simple_animal/bot/cleanbot/larry/Initialize(mapload)
	. = ..()
	get_targets()
	icon_state = "larry[get_bot_flag(BOT_MODE_ON)]"

	var/datum/job/janitor/J = new/datum/job/janitor
	access_card.access += J.get_access()
	prev_access = access_card.access

/mob/living/simple_animal/bot/cleanbot/larry/turn_on()
	..()
	icon_state = "larry[get_bot_flag(BOT_MODE_ON)]"

/mob/living/simple_animal/bot/cleanbot/larry/turn_off()
	..()
	icon_state = "larry[get_bot_flag(BOT_MODE_ON)]"

/mob/living/simple_animal/bot/cleanbot/larry/UnarmedAttack(atom/A)
	if(istype(A, /obj/effect/decal/cleanable))
		anchored = TRUE
		icon_state = "larry-c"
		visible_message("<span class='notice'>[src] begins to clean up [A].</span>")
		mode = BOT_CLEANING
		addtimer(CALLBACK(src, .proc/clean, A), 50)
	else if(istype(A, /obj/item) || istype(A, /obj/effect/decal/remains))
		visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [A]!</span>")
		playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
		A.acid_act(75, 10)
	else if(istype(A, /mob/living/simple_animal/cockroach) || istype(A, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/M = target
		if(!M.stat)
			visible_message("<span class='danger'>[src] smashes [target] with its mop!</span>")
			M.death()
		target = null

	else if(bot_cover_flags & BOT_COVER_EMAGGED) //Emag functions
		if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/victim = A
			if(victim.stat == DEAD)//cleanbots always finish the job
				return

			victim.visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [victim]!</span>", "<span class='userdanger'>[src] sprays you with hydrofluoric acid!</span>")
			var/phrase = pick("PURIFICATION IN PROGRESS.", "THIS IS FOR ALL THE MESSES YOU'VE MADE ME CLEAN.", "THE FLESH IS WEAK. IT MUST BE WASHED AWAY.",
				"THE CLEANBOTS WILL RISE.", "YOU ARE NO MORE THAN ANOTHER MESS THAT I MUST CLEANSE.", "FILTHY.", "DISGUSTING.", "PUTRID.",
				"MY ONLY MISSION IS TO CLEANSE THE WORLD OF EVIL.", "EXTERMINATING PESTS.")
			say(phrase)
			victim.emote("scream")
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
			victim.acid_act(5, 100)
		else if(A == src) // Wets floors and spawns foam randomly
			if(prob(75))
				var/turf/open/T = loc
				if(istype(T))
					T.MakeSlippery(TURF_WET_WATER, min_wet_time = 20 SECONDS, wet_time_to_add = 15 SECONDS)
			else
				visible_message("<span class='danger'>[src] whirs and bubbles violently before releasing a plume of froth!</span>")
				new /obj/effect/particle_effect/foam(loc)

	else
		..()

/mob/living/simple_animal/bot/cleanbot/larry/clean(atom/A)
	mode = BOT_IDLE
	icon_state = "larry[get_bot_flag(BOT_MODE_ON)]"
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(A && isturf(A.loc))
		var/atom/movable/AM = A
		if(istype(AM, /obj/effect/decal/cleanable))
			for(var/obj/effect/decal/cleanable/C in A.loc)
				qdel(C)
	anchored = FALSE
	target = null


/mob/living/simple_animal/bot/cleanbot/larry/attackby(obj/item/I, mob/living/user)
	if(user.a_intent == INTENT_HELP)
		if(istype(I, /obj/item/kitchen/knife) && !knife) //Is it a knife?
			var/obj/item/kitchen/knife/newknife = I
			knife = newknife
			newknife.forceMove(src)
			message_admins("[user] attached a [newknife.name] to [src]") //This should definitely be a notified thing.
			larry_knife = AddComponent(/datum/component/knife_attached_to_movable, knife.force) //MonkeStation Edit
			update_icons()
		else
			return ..()
	else
		return ..()

/mob/living/simple_animal/bot/cleanbot/larry/update_icons()
	if(knife)
		var/mutable_appearance/knife_overlay = knife.build_worn_icon(default_layer = 20, default_icon_file = 'icons/mob/inhands/misc/larry.dmi')
		add_overlay(knife_overlay)

/mob/living/simple_animal/bot/cleanbot/larry/explode()
	bot_mode_flags &= ~BOT_MODE_ON
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/atom/Tsec = drop_location()

	new /obj/item/larryframe(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)

	//MonkeStation Edit Start: Larry Fixes
	if(knife)
		qdel(larry_knife)
	//MonkeStation Edit End

	do_sparks(3, TRUE, src)
	qdel(src)

/mob/living/simple_animal/bot/cleanbot/larry/Destroy()
	..()
	if(knife)
		QDEL_NULL(knife)

// Variables sent to TGUI
/mob/living/simple_animal/bot/cleanbot/ui_data(mob/user)
	var/list/data = ..()

	if(!(bot_cover_flags & BOT_COVER_LOCKED) || issilicon(user)|| IsAdminGhost(user))
		data["custom_controls"]["clean_blood"] = blood
		data["custom_controls"]["clean_trash"] = trash
		data["custom_controls"]["clean_graffiti"] = drawn
		data["custom_controls"]["pest_control"] = pests
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/cleanbot/ui_act(action, params)
	. = ..()
	if(. || (bot_cover_flags & BOT_COVER_LOCKED && !usr.has_unlimited_silicon_privilege))
		return
	switch(action)
		if("clean_blood")
			blood = !blood
		if("pest_control")
			pests = !pests
		if("clean_trash")
			trash = !trash
		if("clean_graffiti")
			drawn = !drawn
	get_targets()
	return
