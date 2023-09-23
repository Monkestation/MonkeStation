/mob/living/simple_animal/hostile/alien_mimic/tier2/thermal
	name = "thermal mimic"
	real_name = "thermal mimic"
	// icon_state = "thermal"
	// icon_living = "thermal"
	melee_damage = 7
	melee_damage_type = BURN
	maxbodytemp = INFINITY
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	hivemind_modifier = "Thermal"
	playstyle_string = "<span class='big bold'>You are a thermal mimic,</span></b> you deal burn and DNA damage, are immunte to fire, and \
						set fire to things you attack.</b>"
	possible_evolutions = list(
		"explosive - explode, dealing damage to enemies and yourself" = /mob/living/simple_animal/hostile/alien_mimic/tier3/explosive,
		"burning - shoot lines of fire at people" = /mob/living/simple_animal/hostile/alien_mimic/tier3/burning
	)

/mob/living/simple_animal/hostile/alien_mimic/tier2/thermal/death(gibbed)
	new /obj/effect/hotspot(get_turf(src))
	..()

/mob/living/simple_animal/hostile/alien_mimic/tier2/thermal/latch(mob/living/target)
	. = ..()
	if(!.)
		return
	new /obj/effect/hotspot(get_turf(target))

/mob/living/simple_animal/hostile/alien_mimic/tier2/thermal/AttackingTarget()
	if(!isliving(target) && !isturf(target))
		new /obj/effect/hotspot(get_turf(target))
		return ..()

	if(buckled && buckled == target)
		new /obj/effect/hotspot(get_turf(target))
	..()
