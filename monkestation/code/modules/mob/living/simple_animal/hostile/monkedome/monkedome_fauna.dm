//the base mining mob
/mob/living/simple_animal/hostile/monkedome_fauna
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("dome")
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_WALLS
	minbodytemp = 0
	maxbodytemp = INFINITY
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "strikes"
	a_intent = INTENT_HARM
	see_in_dark = 9
	mob_size = MOB_SIZE_LARGE
	hardattacks = TRUE
	discovery_points = 1000

/mob/living/simple_animal/hostile/monkedome_fauna/Initialize(mapload)
	. = ..()
	set_varspeed(move_to_delay/10)


/mob/living/simple_animal/hostile/monkedome_fauna/bullet_act(obj/item/projectile/bullet)
	if(!stat)
		Aggro()
	..()

/mob/living/simple_animal/hostile/monkedome_fauna/hitby(atom/movable/weapon, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(!stat)
		Aggro()
	..()


