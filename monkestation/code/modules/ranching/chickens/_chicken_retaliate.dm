/mob/living/simple_animal/chicken/hostile/retaliate
	var/list/enemies = list()
	var/retaliates = TRUE

/mob/living/simple_animal/chicken/hostile/retaliate/Destroy()
	. = ..()
	enemies = null

/mob/living/simple_animal/chicken/hostile/retaliate/death(gibbed)
	. = ..()
	enemies = null

/mob/living/simple_animal/chicken/hostile/retaliate/Found(atom/found_atom)
	if(isliving(found_atom))
		var/mob/living/found_living = found_atom
		if(!found_living.stat)
			return found_living
		else
			enemies -= WEAKREF(found_living)
	else if(ismecha(found_atom))
		var/obj/mecha/found_mecha = found_atom
		if(LAZYLEN(found_mecha.occupant))
			return found_atom

/mob/living/simple_animal/chicken/hostile/retaliate/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	var/list/actual_enemies = list()
	for(var/datum/weakref/enemy as anything in enemies)
		var/mob/flesh_and_blood = enemy.resolve()
		if(!flesh_and_blood)
			enemies -= enemy
			continue
		actual_enemies += flesh_and_blood

	see &= actual_enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/chicken/hostile/retaliate/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/movable/found_atom in around)
		if(found_atom == src)
			continue
		if(isliving(found_atom))
			var/mob/living/found_mecha = found_atom
			if(faction_check_mob(found_mecha) && attack_same || !faction_check_mob(found_mecha))
				enemies |= WEAKREF(found_mecha)
		else if(ismecha(found_atom))
			var/obj/mecha/found_mecha = found_atom
			if(LAZYLEN(found_mecha.occupant))
				enemies |= WEAKREF(found_mecha)
				add_enemies(found_mecha.occupant)

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies

/mob/living/simple_animal/chicken/hostile/retaliate/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS && retaliates)
		Retaliate()

/mob/living/simple_animal/chicken/hostile/retaliate/proc/add_enemies(new_enemies)
	for(var/new_enemy in new_enemies)
		enemies |= WEAKREF(new_enemy)

