/mob/living/simple_animal/chicken/hostile
	faction = list("hostile_chicken")
	breed_name = "Hostile_Dummy"
	egg_type = /obj/item/food/egg
	chicken_path = /mob/living/simple_animal/chicken/hostile
	health = 150
	maxHealth = 150
	melee_damage = 15
	obj_damage = 10


	///Are they really hostile or is 1 part of them hostile
	var/hostile = TRUE
	///Lmao here be some copy pasta from hostile code as i want a hostile holder for chimkens
	///The current target of our attacks, use give_target and lose_target to set this var
	var/atom/target
	var/ranged = FALSE
	var/rapid = 0 //How many shots per volley.
	var/rapid_fire_delay = 2 //Time between rapid fire shots

	var/dodging = TRUE
	var/approaching_target = FALSE //We should dodge now
	var/in_melee = FALSE	//We should sidestep now
	var/dodge_prob = 50
	var/sidestep_per_cycle = 2 //How many sidesteps per npcpool cycle when in melee

	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/move_to_delay = 3 //delay for the automated movement.
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0

	var/rapid_melee = 1			 //Number of melee attacks between each npc pool tick. Spread evenly.
	var/melee_queue_distance = 4 //If target is close enough start preparing to hit them if we have rapid_melee enabled

	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/ranged_cooldown_time = 30 //How long, in deciseconds, the cooldown of ranged attacks is
	var/ranged_ignores_vision = FALSE //if it'll fire ranged attacks even if it lacks vision on its target, only works with environment smash
	var/check_friendly_fire = 0 // Should the ranged mob check for friendlies when shooting
	var/retreat_distance = null //If our mob runs from players when they're too close, set in tile distance. By default, mobs do not retreat.
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles to the target, set higher to make mobs keep distance

	//These vars are related to how mobs locate and target
	var/robust_searching = 0 //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/vision_range = 9 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 9 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/search_objects = 0 //If we want to consider objects when searching around, set this to 1. If you want to search for objects while also ignoring mobs until hurt, set it to 2. To completely ignore mobs, even when attacked, set it to 3
	var/search_objects_timer_id //Timer for regaining our old search_objects value after being attacked
	var/search_objects_regain_time = 3 SECONDS //the delay between being attacked and gaining our old search_objects value back
	var/list/wanted_objects = list() //A typecache of objects types that will be checked against to attack, should we have search_objects enabled
	var/stat_attack = CONSCIOUS //Mobs with stat_attack to UNCONSCIOUS will attempt to attack things that are unconscious, Mobs with stat_attack set to DEAD will attempt to attack the dead.
	var/stat_exclusive = FALSE //Mobs with this set to TRUE will exclusively attack things defined by stat_attack, stat_attack DEAD means they will only attack corpses
	var/attack_same = 0 //Set us to 1 to allow us to attack our own faction
	//Use GET_TARGETS_FROM(mob) to access this
	//Attempting to call GET_TARGETS_FROM(mob) when this var is null will just return mob as a base
	var/datum/weakref/targets_from //all range/attack/etc. calculations should be done from the atom this weakrefs, useful for Vehicles and such.
	var/attack_all_objects = FALSE //if true, equivalent to having a wanted_objects list containing ALL objects.

	var/lose_patience_timer_id //id for a timer to call lose_target(), used to stop mobs fixating on a target they can't reach
	var/lose_patience_timeout = 30 SECONDS //30 seconds by default, so there's no major changes to AI behaviour, beyond actually bailing if stuck forever
	///list of all nearby mobs in the same faction
	var/list/nearby_allies

	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound

/mob/living/simple_animal/chicken/hostile/Initialize(mapload)
	. = ..()
	wanted_objects = typecacheof(wanted_objects)

/mob/living/simple_animal/chicken/hostile/Destroy()
	nearby_allies = null
	friends = null
	targets_from = null
	target = null
	//We can't use losetarget here because fucking cursed blobs override it to do nothing the motherfuckers
	give_target(null)
	return ..()

/mob/living/simple_animal/chicken/hostile/handle_automated_action()
	if(AIStatus == AI_OFF)
		return FALSE
	var/list/possible_targets = list_targets() //we look around for potential targets and make it a list for later use.

	if(environment_smash)
		escape_confinement()

	if(ai_can_continue(possible_targets))
		var/atom/target_from = GET_TARGETS_FROM(src)
		if(!QDELETED(target) && !target_from.Adjacent(target))
			destroy_path_to_target()
		if(!move_to_target(possible_targets))     //if we lose our target
			if(ai_should_sleep(possible_targets))	// we try to acquire a new one
				toggle_ai(AI_IDLE)			// otherwise we go idle
	return TRUE

/mob/living/simple_animal/chicken/hostile/handle_automated_movement()
	. = ..()
	if(dodging && target && in_melee && isturf(loc) && isturf(target.loc))
		var/datum/side_step_callback = CALLBACK(src,.proc/sidestep)
		if(sidestep_per_cycle > 1) //For more than one just spread them equally - this could changed to some sensible distribution later
			var/sidestep_delay = SSnpcpool.wait / sidestep_per_cycle
			for(var/i in 1 to sidestep_per_cycle)
				addtimer(side_step_callback, (i - 1)*sidestep_delay)
		else //Otherwise randomize it to make the players guessing.
			addtimer(side_step_callback,rand(1,SSnpcpool.wait))

/mob/living/simple_animal/chicken/hostile/proc/sidestep()
	if(!target || !isturf(target.loc) || !isturf(loc) || stat == DEAD)
		return
	var/target_dir = get_dir(src,target)

	var/static/list/cardinal_sidestep_directions = list(-90,-45,0,45,90)
	var/static/list/diagonal_sidestep_directions = list(-45,0,45)
	var/chosen_dir = 0
	if (target_dir & (target_dir - 1))
		chosen_dir = pick(diagonal_sidestep_directions)
	else
		chosen_dir = pick(cardinal_sidestep_directions)
	if(chosen_dir)
		chosen_dir = turn(target_dir,chosen_dir)
		Move(get_step(src,chosen_dir))
		face_atom(target) //Looks better if they keep looking at you when dodging

/mob/living/simple_animal/chicken/hostile/attacked_by(obj/item/attacked_item, mob/living/user)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client && user)
		find_targets(list(user), 1)
	return ..()

/mob/living/simple_animal/chicken/hostile/bullet_act(obj/item/projectile/used_projectile)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client)
		if(used_projectile.firer && get_dist(src, used_projectile.firer) <= aggro_vision_range)
			find_targets(list(used_projectile.firer), 1)
		Goto(used_projectile.starting, move_to_delay, 3)
	return ..()

//////////////HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/chicken/hostile/proc/list_targets() //Step 1, find out what we can see
	if(!hostile)
		return
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(!search_objects)
		var/static/target_list = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha)) //mobs are handled via ismob(target_atom)
		. = list()
		for(var/atom/target_atom as() in dview(vision_range, get_turf(target_from), SEE_INVISIBLE_MINIMUM))
			if((ismob(target_atom) && target_atom != src) || target_list[target_atom.type])
				. += target_atom
	else
		. = oview(vision_range, target_from)

/mob/living/simple_animal/chicken/hostile/proc/find_targets(var/list/possible_targets, var/HasTargetsList = 0)//Step 2, filter down possible targets to things we actually care about
	var/list/all_potential_targets = list()

	if(isnull(possible_targets))
		possible_targets = list_targets()

	for(var/atom/pos_targ as anything in possible_targets)
		if(Found(pos_targ)) //Just in case people want to override targetting
			all_potential_targets = list(pos_targ)
			break

		if(isitem(pos_targ) && ismob(pos_targ.loc)) //If source is from an item, check the holder of it.
			if(CanAttack(pos_targ.loc))
				all_potential_targets += pos_targ.loc
		else
			if(CanAttack(pos_targ))
				all_potential_targets += pos_targ

	var/found_target = pick_target(all_potential_targets)
	give_target(found_target)
	return found_target //We now have a target




/mob/living/simple_animal/chicken/hostile/proc/possible_threats()
	. = list()
	for(var/pos_targ in list_targets())
		var/atom/target_atom = pos_targ
		if(Found(target_atom))
			. = list(target_atom)
			break
		if(CanAttack(target_atom))
			. += target_atom
			continue



/mob/living/simple_animal/chicken/hostile/proc/Found(atom/target_atom)//This is here as a potential override to pick a specific target if available
	return

/mob/living/simple_animal/chicken/hostile/proc/pick_target(list/Targets)//Step 3, pick amongst the possible, attackable targets
	if(target != null)//If we already have a target, but are told to pick again, calculate the lowest distance between all possible, and pick from the lowest distance targets
		var/atom/target_from = GET_TARGETS_FROM(src)
		for(var/pos_targ in Targets)
			var/atom/target_atom = pos_targ
			var/target_dist = get_dist(target_from, target)
			var/possible_target_distance = get_dist(target_from, target_atom)
			if(target_dist < possible_target_distance)
				Targets -= target_atom
	if(!Targets.len)//We didnt find nothin!
		return
	var/chosen_target = pick(Targets)//Pick the remaining targets (if any) at random
	return chosen_target

// Please do not add one-off mob AIs here, but override this function for your mob
/mob/living/simple_animal/chicken/hostile/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/target_mob = the_target
		if(target_mob.status_flags & GODMODE)
			return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE
	if(search_objects < 2)
		if(isliving(the_target))
			var/mob/living/living_target = the_target
			var/faction_check = faction_check_mob(living_target)
			if(robust_searching)
				if(faction_check && !attack_same)
					return FALSE
				if(living_target.stat == UNCONSCIOUS && HAS_TRAIT(living_target, TRAIT_FAKEDEATH) && stat_attack < 3 )//Simplemobs don't see through fake death if you're out cold and they don't attack already dead mobs
					return FALSE
				if(living_target.stat > stat_attack)
					return FALSE
				if(living_target in friends)
					return FALSE
			else
				if((faction_check && !attack_same) || living_target.stat)
					return FALSE
			return TRUE

		if(ismecha(the_target))
			var/obj/mecha/target_mob = the_target
			if(target_mob.occupant)//Just so we don't attack empty mechs
				if(CanAttack(target_mob.occupant))
					return TRUE

		if(istype(the_target, /obj/machinery/porta_turret))
			var/obj/machinery/porta_turret/used_projectile = the_target
			if(used_projectile.in_faction(src)) //Don't attack if the turret is in the same faction
				return FALSE
			if(used_projectile.has_cover &&!used_projectile.raised) //Don't attack invincible turrets
				return FALSE
			if(used_projectile.machine_stat & BROKEN) //Or turrets that are already broken
				return FALSE
			return TRUE

	if(isobj(the_target))
		if(attack_all_objects || is_type_in_typecache(the_target, wanted_objects))
			return TRUE

	return FALSE

/mob/living/simple_animal/chicken/hostile/proc/give_target(new_target)//Step 4, give us our selected target
	add_target(new_target)
	lose_patience()
	if(target != null)
		gain_patience()
		Aggro()
		return TRUE

//What we do after closing in
/mob/living/simple_animal/chicken/hostile/proc/melee_action(patience = TRUE)
	if(rapid_melee > 1)
		var/datum/callback/check_and_attack_callback = CALLBACK(src, .proc/check_and_attack)
		var/delay = SSnpcpool.wait / rapid_melee
		for(var/i in 1 to rapid_melee)
			addtimer(check_and_attack_callback, (i - 1)*delay)
	else
		attacking_target()
	if(patience)
		gain_patience()

/mob/living/simple_animal/chicken/hostile/proc/check_and_attack()
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(target && isturf(target_from.loc) && target.Adjacent(target_from) && !incapacitated())
		attacking_target()

/mob/living/simple_animal/chicken/hostile/proc/move_to_target(list/possible_targets)//Step 5, handle movement between us and our target
	stop_automated_movement = TRUE
	if(!target || !CanAttack(target))
		lose_target()
		return FALSE
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(target in possible_targets)
		var/turf/target_turf = get_turf(src)
		if(target.get_virtual_z_level() != target_turf.get_virtual_z_level())
			lose_target()
			return FALSE
		var/target_distance = get_dist(target_from,target)
		if(ranged) //We ranged? Shoot at em
			if(!target.Adjacent(target_from) && ranged_cooldown <= world.time) //But make sure they're not in range for a melee attack and our range attack is off cooldown
				open_fire(target)
		if(!Process_Spacemove()) //Drifting
			SSmove_manager.stop_looping(src)
			return TRUE
		if(retreat_distance) //If we have a retreat distance, check if we need to run from our target
			if(target_distance <= retreat_distance) //If target's closer than our retreat distance, run
				SSmove_manager.move_away(src, target, retreat_distance, move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance) //Otherwise, get to our minimum distance so we chase them
		else
			Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(isturf(target_from.loc) && target.Adjacent(target_from)) //If they're next to us, attack
				melee_action()
			else
				if(rapid_melee > 1 && target_distance <= melee_queue_distance)
					melee_action(FALSE)
				in_melee = FALSE //If we're just preparing to strike do not enter sidestep mode
			return TRUE
		return FALSE
	if(environment_smash)
		if(target.loc != null && get_dist(target_from, target.loc) <= vision_range) //We can't see our target, but he's in our vision range still
			if((environment_smash & ENVIRONMENT_SMASH_WALLS) || (environment_smash & ENVIRONMENT_SMASH_RWALLS)) //If we're capable of smashing through walls, forget about vision completely after finding our target
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return TRUE
			else
				if(FindHidden())
					return TRUE
	lose_target()
	return FALSE

/mob/living/simple_animal/chicken/hostile/proc/Goto(target, delay, minimum_distance)
	if(target == src.target)
		approaching_target = TRUE
	else
		approaching_target = FALSE
	SSmove_manager.move_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/chicken/hostile/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!ckey && !stat && search_objects < 3 && . > 0)//Not unconscious, and we don't ignore mobs
		if(search_objects)//Turn off item searching and ignore whatever item we were looking at, we're more concerned with fight or flight
			lose_target()
			lose_search_objects()
		if(AIStatus != AI_ON && AIStatus != AI_OFF)
			toggle_ai(AI_ON)
			find_targets()
		else if(target != null && prob(40))//No more pulling a mob forever and having a second player attack it, it can switch targets now if it finds a more suitable one
			find_targets()


/mob/living/simple_animal/chicken/hostile/proc/attacking_target()
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	return target.attack_animal(src)

/mob/living/simple_animal/chicken/hostile/proc/Aggro()
	vision_range = aggro_vision_range
	if(target && emote_taunt.len && prob(taunt_chance))
		INVOKE_ASYNC(src, /mob.proc/emote, "me", 1, "[pick(emote_taunt)] at [target].")
		taunt_chance = max(taunt_chance-7,2)


/mob/living/simple_animal/chicken/hostile/proc/lose_aggro()
	stop_automated_movement = FALSE
	vision_range = initial(vision_range)
	taunt_chance = initial(taunt_chance)

/mob/living/simple_animal/chicken/hostile/proc/lose_target()
	give_target(null)
	approaching_target = FALSE
	in_melee = FALSE
	SSmove_manager.stop_looping(src)
	lose_aggro()

//////////////END HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/chicken/hostile/death(gibbed)
	nearby_allies = null
	friends = null
	targets_from = null
	target = null
	lose_target()
	..(gibbed)

/mob/living/simple_animal/chicken/hostile/proc/summon_backup(distance, mob/living/attacker, exact_faction_match)
	do_alert_animation(src)
	playsound(loc, 'sound/machines/chime.ogg', 50, 1, -1)
	var/atom/target_from = GET_TARGETS_FROM(src)
	for(var/mob/living/simple_animal/chicken/hostile/target_mob in oview(distance, target_from))
		if(faction_check_mob(target_mob, TRUE))
			if(target_mob.AIStatus == AI_OFF)
				return
			else
				target_mob.Goto(src,target_mob.move_to_delay,target_mob.minimum_distance)


/mob/living/simple_animal/chicken/hostile/proc/can_smash_turfs(turf/target_turf)
	return iswallturf(target_turf) || ismineralturf(target_turf)


/mob/living/simple_animal/chicken/hostile/Move(atom/newloc, dir , step_x , step_y)
	if(dodging && approaching_target && prob(dodge_prob) && moving_diagonally == 0 && isturf(loc) && isturf(newloc))
		return dodge(newloc,dir)
	else
		return ..()

/mob/living/simple_animal/chicken/hostile/proc/dodge(moving_to,move_direction)
	//Assuming we move towards the target we want to swerve toward them to get closer
	var/cdir = turn(move_direction,45)
	var/ccdir = turn(move_direction,-45)
	dodging = FALSE
	. = Move(get_step(loc,pick(cdir,ccdir)))
	if(!.)//Can't dodge there so we just carry on
		. =  Move(moving_to,move_direction)
	dodging = TRUE

/mob/living/simple_animal/chicken/hostile/proc/destroy_objects_in_direction(direction)
	var/atom/target_from = GET_TARGETS_FROM(src)
	var/turf/target_turf = get_step(target_from, direction)
	if(QDELETED(target_turf))
		return
	if(target_turf.Adjacent(target_from))
		if(can_smash_turfs(target_turf))
			target_turf.attack_animal(src)
			return
	for(var/obj/O in target_turf.contents)
		if(!O.Adjacent(target_from))
			continue
		if((ismachinery(O) || isstructure(O)) && O.density && environment_smash >= ENVIRONMENT_SMASH_STRUCTURES && !O.IsObscured())
			O.attack_animal(src)
			return

/mob/living/simple_animal/chicken/hostile/proc/destroy_path_to_target()
	if(environment_smash)
		escape_confinement()
		var/atom/target_from = GET_TARGETS_FROM(src)
		var/dir_to_target = get_dir(target_from, target)
		var/dir_list = list()
		if(dir_to_target in GLOB.diagonals) //it's diagonal, so we need two directions to hit
			for(var/direction in GLOB.cardinals)
				if(direction & dir_to_target)
					dir_list += direction
		else
			dir_list += dir_to_target
		for(var/direction in dir_list) //now we hit all of the directions we got in this fashion, since it's the only directions we should actually need
			destroy_objects_in_direction(direction)


/mob/living/simple_animal/chicken/hostile/proc/destroy_surroundings() // for use with megafauna destroying everything around them
	if(environment_smash)
		escape_confinement()
		for(var/dir in GLOB.cardinals)
			destroy_objects_in_direction(dir)


/mob/living/simple_animal/chicken/hostile/proc/escape_confinement()
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(buckled)
		buckled.attack_animal(src)
	if(!isturf(target_from.loc) && target_from.loc != null)//Did someone put us in something?
		var/atom/target_atom = target_from.loc
		target_atom.attack_animal(src)//Bang on it till we get out

/mob/living/simple_animal/chicken/hostile/proc/FindHidden()
	if(istype(target.loc, /obj/structure/closet) || istype(target.loc, /obj/machinery/disposal) || istype(target.loc, /obj/machinery/sleeper))
		var/atom/target_atom = target.loc
		var/atom/target_from = GET_TARGETS_FROM(src)
		Goto(target_atom,move_to_delay,minimum_distance)
		if(target_atom.Adjacent(target_from))
			target_atom.attack_animal(src)
		return TRUE

////// AI Status ///////
/mob/living/simple_animal/chicken/hostile/proc/ai_can_continue(var/list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(find_targets(possible_targets, 1))
				. = 1
				toggle_ai(AI_ON) //Wake up for more than one Life() cycle.
			else
				. = 0

/mob/living/simple_animal/chicken/hostile/proc/ai_should_sleep(var/list/possible_targets)
	return !find_targets(possible_targets, 1)


//These two procs handle losing our target if we've failed to attack them for
//more than lose_patience_timeout deciseconds, which probably means we're stuck
/mob/living/simple_animal/chicken/hostile/proc/gain_patience()
	if(lose_patience_timeout)
		lose_patience()
		lose_patience_timer_id = addtimer(CALLBACK(src, .proc/lose_target), lose_patience_timeout, TIMER_STOPPABLE)


/mob/living/simple_animal/chicken/hostile/proc/lose_patience()
	deltimer(lose_patience_timer_id)


//These two procs handle losing and regaining search_objects when attacked by a mob
/mob/living/simple_animal/chicken/hostile/proc/lose_search_objects()
	search_objects = FALSE
	deltimer(search_objects_timer_id)
	search_objects_timer_id = addtimer(CALLBACK(src, .proc/regain_search_objects), search_objects_regain_time, TIMER_STOPPABLE)


/mob/living/simple_animal/chicken/hostile/proc/regain_search_objects(value)
	if(!value)
		value = initial(search_objects)
	search_objects = value

/mob/living/simple_animal/chicken/hostile/consider_wakeup()
	..()
	var/list/tlist
	var/turf/target_turf = get_turf(src)

	if (!target_turf)
		return

	if (!length(SSmobs.clients_by_zlevel[target_turf.z])) // It's fine to use .len here but doesn't compile on 511
		toggle_ai(AI_Z_OFF)
		return

	var/cheap_search = isturf(target_turf) && !is_station_level(target_turf.z)
	if (cheap_search)
		tlist = list_targets_lazy(target_turf.z)
	else
		tlist = list_targets()

	if(AIStatus == AI_IDLE && find_targets(tlist, 1))
		if(cheap_search) //Try again with full effort
			find_targets()
		toggle_ai(AI_ON)

/mob/living/simple_animal/chicken/hostile/proc/list_targets_lazy(var/_Z)//Step 1, find out what we can see
	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))
	. = list()
	for (var/list_item in SSmobs.clients_by_zlevel[_Z])
		var/mob/target_mob = list_item
		if (get_dist(target_mob, src) < vision_range)
			if (isturf(target_mob.loc))
				. += target_mob
			else if (target_mob.loc.type in hostile_machines)
				. += target_mob.loc

/mob/living/simple_animal/chicken/hostile/proc/get_targets_from()
	var/atom/target_from = targets_from.resolve()
	if(!target_from)
		targets_from = null
		return src
	return target_from

/mob/living/simple_animal/chicken/hostile/proc/handle_target_del(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = null
	lose_target()

/mob/living/simple_animal/chicken/hostile/proc/add_target(new_target)
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = new_target
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/handle_target_del)

/mob/living/simple_animal/chicken/hostile/proc/check_friendly_fire(atom/target_atom)
	if(check_friendly_fire)
		for(var/turf/target_turf in get_line(src,target_atom)) // Not 100% reliable but this is faster than simulating actual trajectory
			for(var/mob/living/living_target in target_turf)
				if(living_target == src || living_target == target_atom)
					continue
				if(faction_check_mob(living_target) && !attack_same)
					return TRUE

/mob/living/simple_animal/chicken/hostile/proc/open_fire(atom/target_atom)
	if(check_friendly_fire(target_atom))
		return

	if(!(simple_mob_flags & SILENCE_RANGED_MESSAGE))
		visible_message("<span class='danger'><b>[src]</b> [ranged_message] at [target_atom]!</span>")


	if(rapid > 1)
		var/datum/callback/shoot_callback = CALLBACK(src, .proc/Shoot, target_atom)
		for(var/i in 1 to rapid)
			addtimer(shoot_callback, (i - 1)*rapid_fire_delay)
	else
		Shoot(target_atom)
	ranged_cooldown = world.time + ranged_cooldown_time


/mob/living/simple_animal/chicken/hostile/proc/Shoot(atom/targeted_atom)
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(QDELETED(targeted_atom) || targeted_atom == target_from.loc || targeted_atom == target_from )
		return
	var/turf/startloc = get_turf(target_from)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype(startloc)
		playsound(src, projectilesound, 100, 1)
		casing.fire_casing(targeted_atom, src, null, null, null, ran_zone(), 0, 1,  src)
	else if(projectiletype)
		var/obj/item/projectile/used_projectile = new projectiletype(startloc)
		playsound(src, projectilesound, 100, 1)
		used_projectile.starting = startloc
		used_projectile.firer = src
		used_projectile.fired_from = src
		used_projectile.yo = targeted_atom.y - startloc.y
		used_projectile.xo = targeted_atom.x - startloc.x
		if(AIStatus != AI_ON)//Don't want mindless mobs to have their movement screwed up firing in space
			newtonian_move(get_dir(targeted_atom, target_from))
		used_projectile.original = targeted_atom
		used_projectile.preparePixelProjectile(targeted_atom, src)
		used_projectile.fire()
		return used_projectile
