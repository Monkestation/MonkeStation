/mob/living/simple_animal/hostile/alien_mimic/tier3/burning
	name = "burning mimic"
	real_name = "burning mimic"
	// icon_state = "burning"
	// icon_living = "burning"
	melee_damage = 9
	melee_damage_type = BURN
	maxbodytemp = INFINITY
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	hivemind_modifier = "burning"
	playstyle_string = "<span class='big bold'>You are a burning mimic,</span></b> can launch fire out.</b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/pointed/mimic/firestrike
	)

//Abilities
/obj/effect/proc_holder/spell/pointed/mimic/firestrike
	name = "Fire Strike"
	desc = "Shoot fire at a target."
	charge_max = 1 MINUTES

/obj/effect/proc_holder/spell/pointed/mimic/firestrike/cast(list/targets, mob/user = usr)
	. = ..()
	if(.)
		return

	for(var/target in targets)
		var/turf/target_turf = get_turf(target)
		var/turf/user_turf = get_turf(user)
		if(!(target_turf in view(7, user_turf)))
			revert_cast(user)
			return

		var/list/turfs = get_line(user_turf,target_turf)

		firestrike(turfs)
		return

	revert_cast(user)

/obj/effect/proc_holder/spell/pointed/mimic/firestrike/proc/firestrike(list/turf_list)
	for(var/turf/cur_turf in turf_list)
		new /obj/effect/hotspot(cur_turf)
		for(var/mob/living/victim in cur_turf)
			victim.adjustFireLoss(15)
			victim.IgniteMob()
		sleep(0.2)
