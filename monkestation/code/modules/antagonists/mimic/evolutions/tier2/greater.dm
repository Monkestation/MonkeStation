/mob/living/simple_animal/hostile/alien_mimic/tier2/greater
	name = "greater mimic"
	real_name = "greater mimic"
	// icon_state = "greater"
	// icon_living = "greater"
	maxHealth = 175
	health = 175
	melee_damage = 9
	secondary_damage_type = BRUTE
	hivemind_modifier = "Greater"
	playstyle_string = "<span class='big bold'>You are a greater mimic,</span></b> you deal more damage to both people and objects, though only brute damage, \
						have more health, and can disguise as bigger objects.</b>"
	possible_evolutions = list(
		"launching - launch yourself into people to deal damage" = /mob/living/simple_animal/hostile/alien_mimic/tier3/launching
	)

/mob/living/simple_animal/hostile/alien_mimic/tier2/greater/allowed(atom/movable/target_item)
	return isitem(target_item) || (get_dist(src,target_item) > 1 && ismachinery(target_item) && !istype(target_item,/obj/machinery/atmospherics)) //dist check so you can still break things
