/mob/living/simple_animal/hostile/alien_mimic/tier3/launching
	name = "launching mimic"
	real_name = "launching mimic"
	// icon_state = "greater"
	// icon_living = "greater"
	hivemind_modifier = "launching"
	melee_damage = 8
	secondary_damage_type = BRUTE
	playstyle_string = "<span class='big bold'>You are a launching mimic,</span></b> you can launch yourself in a direction, dealing damage based on the distance.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/launch
	)


/mob/living/simple_animal/hostile/alien_mimic/tier3/launching/allowed(atom/movable/target_item)
	return isitem(target_item) || (get_dist(src,target_item) > 1 && ismachinery(target_item) && !istype(target_item,/obj/machinery/atmospherics)) //dist check so you can still break things

//Abilities
/obj/effect/proc_holder/spell/self/mimic/launch
	name = "Launch"
	desc = "Launch yourself in the direction you are facing, dealing massive damage to wherever you hit"
	charge_max = 30 SECONDS
	var/turf/start_turf
	var/damage_multiplier = 3 //Damage dealt per turf traveled

/obj/effect/proc_holder/spell/self/mimic/launch/cast(mob/living/user = usr)
	. = ..()
	if(.)
		return

	RegisterSignal(user, COMSIG_MOVABLE_IMPACT, .proc/launch_impact)
	start_turf = get_turf(user)

	var/launch_target = get_edge_target_turf(user, user.dir)

	user.Immobilize(1 SECONDS)
	user.safe_throw_at(launch_target, 15, 2, force = MOVE_FORCE_EXTREMELY_STRONG, spin = FALSE)

/obj/effect/proc_holder/spell/self/mimic/launch/proc/launch_impact(datum/source, atom/movable/hit_atom)
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)

	if(!isliving(source))
		return

	if(!istype(hit_atom))
		return

	var/mob/living/source_mob = source


	var/distance_traveled = get_dist(start_turf,get_turf(hit_atom))
	var/damage = distance_traveled * damage_multiplier

	if(isliving(hit_atom))
		var/mob/living/living_target = hit_atom
		living_target.adjustBruteLoss(damage)
		living_target.Knockdown(distance_traveled SECONDS)

	if(!hit_atom.anchored)
		var/knockback_target = get_edge_target_turf(hit_atom, source_mob.dir)
		hit_atom.safe_throw_at(knockback_target, distance_traveled, distance_traveled/2, force = MOVE_FORCE_EXTREMELY_STRONG)
