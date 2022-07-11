/mob/living/simple_animal/chicken/hostile
	faction = list("hostile_chicken")
	breed_name = "Hostile_Dummy"
	egg_type = /obj/item/food/egg
	chicken_path = /mob/living/simple_animal/chicken/hostile
	health = 150
	maxHealth = 150
	melee_damage = 15
	obj_damage = 10


/mob/living/simple_animal/chicken/hostile/Initialize(mapload)
	. = ..()
	wanted_objects = typecacheof(wanted_objects)

/mob/living/simple_animal/chicken/hostile/attacked_by(obj/item/I, mob/living/user)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client && user)
		FindTarget(list(user), 1)
	return ..()

/mob/living/simple_animal/chicken/hostile/bullet_act(obj/item/projectile/P)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client)
		if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
			FindTarget(list(P.firer), 1)
		Goto(P.starting, move_to_delay, 3)
	return ..()

//////////////HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/chicken/hostile/ListTargets() //Step 1, find out what we can see
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(!search_objects)
		var/static/target_list = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha)) //mobs are handled via ismob(A)
		. = list()
		for(var/atom/A as() in dview(vision_range, get_turf(target_from), SEE_INVISIBLE_MINIMUM))
			if((ismob(A) && A != src) || target_list[A.type])
				. += A
	else
		. = oview(vision_range, target_from)

/mob/living/simple_animal/chicken/hostile/Found(atom/A)//This is here as a potential override to pick a specific target if available
	return

/mob/living/simple_animal/chicken/hostile/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!ckey && !stat && search_objects < 3 && . > 0)//Not unconscious, and we don't ignore mobs
		if(search_objects)//Turn off item searching and ignore whatever item we were looking at, we're more concerned with fight or flight
			LoseTarget()
			LoseSearchObjects()
		if(AIStatus != AI_ON && AIStatus != AI_OFF)
			toggle_ai(AI_ON)
			FindTarget()
		else if(target != null && prob(40))//No more pulling a mob forever and having a second player attack it, it can switch targets now if it finds a more suitable one
			FindTarget()


