/mob/living/simple_animal/hostile/alien_mimic/tier2/kinetic
	name = "kinetic mimic"
	real_name = "kinetic mimic"
	// icon_state = "kinetic"
	// icon_living = "kinetic"
	hivemind_modifier = "Kinetic"
	melee_damage = 6
	secondary_damage_type = BRUTE
	playstyle_string = "<span class='big bold'>You are a kinetic mimic,</span></b> you only deal brute damage, and can push things away with your kinetic blast.<b>"
	possible_evolutions = list(
		"present - force everyone nearby down" = /mob/living/simple_animal/hostile/alien_mimic/tier3/present
	)
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/kinetic_blast
	)

/obj/effect/proc_holder/spell/self/mimic/kinetic_blast
	name = "Kinetic Blast"
	desc = "Knock everything away."
	charge_max = 45 SECONDS

/obj/effect/proc_holder/spell/self/mimic/kinetic_blast/cast(mob/user)
	. = ..()
	if(.)
		return

	var/turf/user_turf = get_turf(user)

	playsound(user_turf,'sound/magic/repulse.ogg', 100, 1)
	user.add_emitter(/obj/emitter/mimic/kinetic_blast,"kinetic_blast",burst_mode=TRUE)
	user.visible_message("<span class='danger'>[user] sends out a wave of dark energy, knocking everything around!</span>","<span class='danger'>You push everything away!</span>")

	var/list/thrown_items = list()

	for(var/atom/movable/to_throw as mob|obj in orange(7, user_turf))
		if(to_throw.anchored || thrown_items[to_throw])
			continue
		var/throwtarget = get_edge_target_turf(user_turf, get_dir(user_turf, get_step_away(to_throw, user_turf)))
		to_throw.safe_throw_at(throwtarget, 10, 1, force = MOVE_FORCE_EXTREMELY_STRONG)
		thrown_items[to_throw] = to_throw
