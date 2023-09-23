/mob/living/simple_animal/hostile/alien_mimic/tier2/shifty
	name = "shifty mimic"
	real_name = "shifty mimic"
	// icon_state = "shifty"
	// icon_living = "shifty"
	hivemind_modifier = "Shifty"
	melee_damage = 5
	playstyle_string = "<span class='big bold'>You are a shifty mimic,</span></b> you can teleport around, bringing whoever you're latched onto with you<b>"
	possible_evolutions = list(
		"transportive - teleport to and summon other mimics" = /mob/living/simple_animal/hostile/alien_mimic/tier3/transportive
	)
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/pointed/mimic/phantom_shift
	)

/obj/effect/proc_holder/spell/pointed/mimic/phantom_shift
	name = "Phantom Shift"
	desc = "Quickly reform at another position, and bring anyone you're latched on to."
	charge_max = 30 SECONDS
	can_use_disguised = TRUE

/obj/effect/proc_holder/spell/pointed/mimic/phantom_shift/cast(list/targets,mob/user = usr)
	. = ..()
	if(.)
		return

	for(var/target in targets)
		var/turf/target_turf = get_turf(target)
		if(!(target_turf in view(7, get_turf(user))))
			revert_cast(user)
			return
		if(target_turf.density)
			to_chat(user,"<span class='notice'>You can't teleport there!</span>")
			revert_cast(user)
			return
		var/mob/living/teleport_with
		if(user.buckled)
			teleport_with = user.buckled
		user.add_emitter(/obj/emitter/mimic/phantom_shift,"phantom_shift",burst_mode=TRUE)
		do_teleport(user, target_turf)
		if(teleport_with)
			do_teleport(teleport_with, target_turf)
			teleport_with.buckle_mob(user,TRUE)
		return
	revert_cast(user)
