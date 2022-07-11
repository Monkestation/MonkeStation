
/mob/living/simple_animal/chicken
	///Lmao here be some copy pasta from hostile code as i want a hostile holder for chimkens
	///list of Enemies
	var/list/enemies = list()
	///The current target of our attacks, use GiveTarget and LoseTarget to set this var
	var/atom/target
	///are we ranged?
	var/ranged = FALSE
	///How many shots per volley.
	var/rapid = 0
	///Time between rapid fire shots
	var/rapid_fire_delay = 2

	var/dodging = TRUE
	///We should dodge now
	var/approaching_target = FALSE
	///We should sidestep now
	var/in_melee = FALSE
	///Chance to dodge
	var/dodge_prob = 50
	///How many sidesteps per npcpool cycle when in melee
	var/sidestep_per_cycle = 2

	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectiletype
	var/projectilesound
	///set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/casingtype

	///delay for the automated movement.
	var/move_to_delay = 3
	///list of friends
	var/list/friends = list()
	///if it taunts what emotes to taunt with
	var/list/emote_taunt = list()
	///chance to taunt
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
	var/search_objects_regain_time = 30 //the delay between being attacked and gaining our old search_objects value back
	var/list/wanted_objects = list() //A typecache of objects types that will be checked against to attack, should we have search_objects enabled
	var/stat_attack = CONSCIOUS //Mobs with stat_attack to UNCONSCIOUS will attempt to attack things that are unconscious, Mobs with stat_attack set to DEAD will attempt to attack the dead.
	var/stat_exclusive = FALSE //Mobs with this set to TRUE will exclusively attack things defined by stat_attack, stat_attack DEAD means they will only attack corpses
	var/attack_same = 0 //Set us to 1 to allow us to attack our own faction
	//Use GET_TARGETS_FROM(mob) to access this
	//Attempting to call GET_TARGETS_FROM(mob) when this var is null will just return mob as a base
	var/datum/weakref/targets_from //all range/attack/etc. calculations should be done from the atom this weakrefs, useful for Vehicles and such.
	var/attack_all_objects = FALSE //if true, equivalent to having a wanted_objects list containing ALL objects.

	var/lose_patience_timer_id //id for a timer to call LoseTarget(), used to stop mobs fixating on a target they can't reach
	var/lose_patience_timeout = 300 //30 seconds by default, so there's no major changes to AI behaviour, beyond actually bailing if stuck forever
	///list of all nearby mobs in the same faction
	var/list/nearby_allies


/mob/living/simple_animal/chicken/proc/Found(atom/found_atom)
	if(isliving(found_atom))
		var/mob/living/found_living = found_atom
		if(!found_living.stat)
			return found_living
		else
			remove_enemy(found_living)
	else if(ismecha(found_atom))
		var/obj/mecha/found_mech = found_atom
		if(found_mech.occupant)
			return found_atom

/mob/living/simple_animal/chicken/proc/ListTargets() //Step 1, find out what we can see
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(!search_objects)
		var/static/target_list = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha)) //mobs are handled via ismob(A)
		. = list()
		for(var/atom/A as() in dview(vision_range, get_turf(target_from), SEE_INVISIBLE_MINIMUM))
			if((ismob(A) && A != src) || target_list[A.type])
				. += A
	else
		. = oview(vision_range, target_from)

/mob/living/simple_animal/chicken/proc/Retaliate()
	for(var/atom/movable/atom_target as obj|mob in oview(vision_range, src))
		if(isliving(atom_target))
			var/mob/living/living_target = atom_target
			if(attack_same || !faction_check_mob(living_target))
				add_enemy(living_target)
			if(istype(living_target, /mob/living/simple_animal/chicken))
				var/mob/living/simple_animal/chicken/retaliation_buddy = living_target
				if(attack_same && retaliation_buddy.attack_same)
					retaliation_buddy.add_enemies(enemies)
		else if(ismecha(atom_target))
			var/obj/mecha/mech_target = atom_target
			if(mech_target.occupant)
				add_enemy(mech_target)
				add_enemy(mech_target.occupant)
	return FALSE

/mob/living/simple_animal/chicken/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS && retaliates)
		Retaliate()

/mob/living/simple_animal/chicken/proc/add_enemy(new_enemy)
	RegisterSignal(new_enemy, COMSIG_PARENT_QDELETING, .proc/remove_enemy, override = TRUE)
	enemies |= new_enemy

/mob/living/simple_animal/chicken/proc/add_enemies(new_enemies)
	for(var/new_enemy in new_enemies)
		RegisterSignal(new_enemy, COMSIG_PARENT_QDELETING, .proc/remove_enemy, override = TRUE)
		enemies |= new_enemy

/mob/living/simple_animal/chicken/proc/clear_enemies()
	for(var/enemy in enemies)
		UnregisterSignal(enemy, COMSIG_PARENT_QDELETING)
	enemies.Cut()

/mob/living/simple_animal/chicken/proc/remove_enemy(datum/enemy_to_remove)
	SIGNAL_HANDLER
	UnregisterSignal(enemy_to_remove, COMSIG_PARENT_QDELETING)
	enemies -= enemy_to_remove

// Please do not add one-off mob AIs here, but override this function for your mob
/mob/living/simple_animal/chicken/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/mob_target = the_target
		if(mob_target.status_flags & GODMODE)
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
			var/obj/mecha/mech_target = the_target
			if(mech_target.occupant)//Just so we don't attack empty mechs
				if(CanAttack(mech_target.occupant))
					return TRUE

		if(istype(the_target, /obj/machinery/porta_turret))
			var/obj/machinery/porta_turret/turret_target = the_target
			if(turret_target.in_faction(src)) //Don't attack if the turret is in the same faction
				return FALSE
			if(turret_target.has_cover &&!turret_target.raised) //Don't attack invincible turrets
				return FALSE
			if(turret_target.machine_stat & BROKEN) //Or turrets that are already broken
				return FALSE
			return TRUE

	if(isobj(the_target))
		if(attack_all_objects || is_type_in_typecache(the_target, wanted_objects))
			return TRUE

	return FALSE

/mob/living/simple_animal/chicken/proc/PickTarget(list/Targets)//Step 3, pick amongst the possible, attackable targets
	if(target != null)//If we already have a target, but are told to pick again, calculate the lowest distance between all possible, and pick from the lowest distance targets
		var/atom/target_from = GET_TARGETS_FROM(src)
		for(var/pos_targ in Targets)
			var/atom/A = pos_targ
			var/target_dist = get_dist(target_from, target)
			var/possible_target_distance = get_dist(target_from, A)
			if(target_dist < possible_target_distance)
				Targets -= A
	if(!Targets.len)//We didnt find nothin!
		return
	var/chosen_target = pick(Targets)//Pick the remaining targets (if any) at random
	return chosen_target

/mob/living/simple_animal/chicken/proc/GiveTarget(new_target)//Step 4, give us our selected target
	add_target(new_target)
	LosePatience()
	if(target != null)
		GainPatience()
		Aggro()
		return TRUE

//What we do after closing in
/mob/living/simple_animal/chicken/proc/MeleeAction(patience = TRUE)
	if(rapid_melee > 1)
		var/datum/callback/cb = CALLBACK(src, .proc/CheckAndAttack)
		var/delay = SSnpcpool.wait / rapid_melee
		for(var/i in 1 to rapid_melee)
			addtimer(cb, (i - 1)*delay)
	else
		AttackingTarget()
	if(patience)
		GainPatience()

/mob/living/simple_animal/chicken/proc/CheckAndAttack()
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(target && isturf(target_from.loc) && target.Adjacent(target_from) && !incapacitated())
		AttackingTarget()

/mob/living/simple_animal/chicken/proc/MoveToTarget(list/possible_targets)//Step 5, handle movement between us and our target
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(target in possible_targets)
		var/turf/T = get_turf(src)
		if(target.get_virtual_z_level() != T.get_virtual_z_level())
			LoseTarget()
			return 0
		var/target_distance = get_dist(target_from,target)
		if(ranged) //We ranged? Shoot at em
			if(!target.Adjacent(target_from) && ranged_cooldown <= world.time) //But make sure they're not in range for a melee attack and our range attack is off cooldown
				OpenFire(target)
		if(!Process_Spacemove()) //Drifting
			SSmove_manager.stop_looping(src)
			return 1
		if(retreat_distance != null) //If we have a retreat distance, check if we need to run from our target
			if(target_distance <= retreat_distance) //If target's closer than our retreat distance, run
				SSmove_manager.move_away(src, target, retreat_distance, move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance) //Otherwise, get to our minimum distance so we chase them
		else
			Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(isturf(target_from.loc) && target.Adjacent(target_from)) //If they're next to us, attack
				MeleeAction()
			else
				if(rapid_melee > 1 && target_distance <= melee_queue_distance)
					MeleeAction(FALSE)
				in_melee = FALSE //If we're just preparing to strike do not enter sidestep mode
			return 1
		return 0
	if(environment_smash)
		if(target.loc != null && get_dist(target_from, target.loc) <= vision_range) //We can't see our target, but he's in our vision range still
			if(ranged_ignores_vision && ranged_cooldown <= world.time) //we can't see our target... but we can fire at them!
				OpenFire(target)
			if((environment_smash & ENVIRONMENT_SMASH_WALLS) || (environment_smash & ENVIRONMENT_SMASH_RWALLS)) //If we're capable of smashing through walls, forget about vision completely after finding our target
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return 1
			else
				if(FindHidden())
					return 1
	LoseTarget()
	return 0

/mob/living/simple_animal/chicken/proc/Goto(target, delay, minimum_distance)
	if(target == src.target)
		approaching_target = TRUE
	else
		approaching_target = FALSE
	SSmove_manager.move_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/chicken/proc/AttackingTarget()
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	return target.attack_animal(src)

/mob/living/simple_animal/chicken/proc/Aggro()
	vision_range = aggro_vision_range
	if(target && emote_taunt.len && prob(taunt_chance))
		INVOKE_ASYNC(src, /mob.proc/emote, "me", 1, "[pick(emote_taunt)] at [target].")
		taunt_chance = max(taunt_chance-7,2)


/mob/living/simple_animal/chicken/proc/LoseAggro()
	stop_automated_movement = 0
	vision_range = initial(vision_range)
	taunt_chance = initial(taunt_chance)

/mob/living/simple_animal/chicken/proc/LoseTarget()
	GiveTarget(null)
	approaching_target = FALSE
	in_melee = FALSE
	SSmove_manager.stop_looping(src)
	LoseAggro()

/mob/living/simple_animal/chicken/proc/FindTarget(var/list/possible_targets, var/HasTargetsList = 0)//Step 2, filter down possible targets to things we actually care about
	. = list()
	if(!HasTargetsList)
		possible_targets = ListTargets()
	for(var/pos_targ in possible_targets)
		var/atom/A = pos_targ
		if(Found(A))//Just in case people want to override targetting
			. = list(A)
			break
		if(CanAttack(A))//Can we attack it?
			. += A
			continue
	var/Target = PickTarget(.)
	GiveTarget(Target)
	return Target //We now have a target



/mob/living/simple_animal/chicken/proc/PossibleThreats()
	. = list()
	for(var/pos_targ in ListTargets())
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue

////// AI Status ///////
/mob/living/simple_animal/chicken/proc/AICanContinue(var/list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(FindTarget(possible_targets, 1))
				. = 1
				toggle_ai(AI_ON) //Wake up for more than one Life() cycle.
			else
				. = 0

/mob/living/simple_animal/chicken/proc/AIShouldSleep(var/list/possible_targets)
	return !FindTarget(possible_targets, 1)


//These two procs handle losing our target if we've failed to attack them for
//more than lose_patience_timeout deciseconds, which probably means we're stuck
/mob/living/simple_animal/chicken/proc/GainPatience()
	if(lose_patience_timeout)
		LosePatience()
		lose_patience_timer_id = addtimer(CALLBACK(src, .proc/LoseTarget), lose_patience_timeout, TIMER_STOPPABLE)


/mob/living/simple_animal/chicken/proc/LosePatience()
	deltimer(lose_patience_timer_id)


//These two procs handle losing and regaining search_objects when attacked by a mob
/mob/living/simple_animal/chicken/proc/LoseSearchObjects()
	search_objects = 0
	deltimer(search_objects_timer_id)
	search_objects_timer_id = addtimer(CALLBACK(src, .proc/RegainSearchObjects), search_objects_regain_time, TIMER_STOPPABLE)


/mob/living/simple_animal/chicken/proc/RegainSearchObjects(value)
	if(!value)
		value = initial(search_objects)
	search_objects = value

/mob/living/simple_animal/chicken/consider_wakeup()
	..()
	var/list/tlist
	var/turf/T = get_turf(src)

	if (!T)
		return

	if (!length(SSmobs.clients_by_zlevel[T.z])) // It's fine to use .len here but doesn't compile on 511
		toggle_ai(AI_Z_OFF)
		return

	var/cheap_search = isturf(T) && !is_station_level(T.z)
	if (cheap_search)
		tlist = ListTargetsLazy(T.z)
	else
		tlist = ListTargets()

	if(AIStatus == AI_IDLE && FindTarget(tlist, 1))
		if(cheap_search) //Try again with full effort
			FindTarget()
		toggle_ai(AI_ON)

/mob/living/simple_animal/chicken/proc/ListTargetsLazy(var/_Z)//Step 1, find out what we can see
	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))
	. = list()
	for (var/I in SSmobs.clients_by_zlevel[_Z])
		var/mob/M = I
		if (get_dist(M, src) < vision_range)
			if (isturf(M.loc))
				. += M
			else if (M.loc.type in hostile_machines)
				. += M.loc

/mob/living/simple_animal/chicken/proc/get_targets_from()
	var/atom/target_from = targets_from.resolve()
	if(!target_from)
		targets_from = null
		return src
	return target_from

/mob/living/simple_animal/chicken/proc/handle_target_del(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = null
	LoseTarget()

/mob/living/simple_animal/chicken/proc/add_target(new_target)
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = new_target
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/handle_target_del)

//////////////END HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/chicken/death(gibbed)
	LoseTarget()
	..(gibbed)

/mob/living/simple_animal/chicken/proc/summon_backup(distance, exact_faction_match)
	do_alert_animation(src)
	playsound(loc, 'sound/machines/chime.ogg', 50, 1, -1)
	var/atom/target_from = GET_TARGETS_FROM(src)
	for(var/mob/living/simple_animal/chicken/M in oview(distance, target_from))
		if(faction_check_mob(M, TRUE))
			if(M.AIStatus == AI_OFF)
				return
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)


/mob/living/simple_animal/chicken/proc/CanSmashTurfs(turf/T)
	return iswallturf(T) || ismineralturf(T)


/mob/living/simple_animal/chicken/Move(atom/newloc, dir , step_x , step_y)
	if(dodging && approaching_target && prob(dodge_prob) && moving_diagonally == 0 && isturf(loc) && isturf(newloc))
		return dodge(newloc,dir)
	else
		return ..()

/mob/living/simple_animal/chicken/proc/dodge(moving_to,move_direction)
	//Assuming we move towards the target we want to swerve toward them to get closer
	var/cdir = turn(move_direction,45)
	var/ccdir = turn(move_direction,-45)
	dodging = FALSE
	. = Move(get_step(loc,pick(cdir,ccdir)))
	if(!.)//Can't dodge there so we just carry on
		. =  Move(moving_to,move_direction)
	dodging = TRUE

/mob/living/simple_animal/chicken/proc/DestroyObjectsInDirection(direction)
	var/atom/target_from = GET_TARGETS_FROM(src)
	var/turf/T = get_step(target_from, direction)
	if(QDELETED(T))
		return
	if(T.Adjacent(target_from))
		if(CanSmashTurfs(T))
			T.attack_animal(src)
			return
	for(var/obj/O in T.contents)
		if(!O.Adjacent(target_from))
			continue
		if((ismachinery(O) || isstructure(O)) && O.density && environment_smash >= ENVIRONMENT_SMASH_STRUCTURES && !O.IsObscured())
			O.attack_animal(src)
			return

/mob/living/simple_animal/chicken/proc/DestroyPathToTarget()
	if(environment_smash)
		EscapeConfinement()
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
			DestroyObjectsInDirection(direction)


/mob/living/simple_animal/chicken/proc/DestroySurroundings() // for use with megafauna destroying everything around them
	if(environment_smash)
		EscapeConfinement()
		for(var/dir in GLOB.cardinals)
			DestroyObjectsInDirection(dir)


/mob/living/simple_animal/chicken/proc/EscapeConfinement()
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(buckled)
		buckled.attack_animal(src)
	if(!isturf(target_from.loc) && target_from.loc != null)//Did someone put us in something?
		var/atom/A = target_from.loc
		A.attack_animal(src)//Bang on it till we get out

/mob/living/simple_animal/chicken/proc/FindHidden()
	if(istype(target.loc, /obj/structure/closet) || istype(target.loc, /obj/machinery/disposal) || istype(target.loc, /obj/machinery/sleeper))
		var/atom/A = target.loc
		var/atom/target_from = GET_TARGETS_FROM(src)
		Goto(A,move_to_delay,minimum_distance)
		if(A.Adjacent(target_from))
			A.attack_animal(src)
		return 1


/mob/living/simple_animal/chicken/handle_automated_action()
	if(AIStatus == AI_OFF)
		return 0
	var/list/possible_targets = ListTargets() //we look around for potential targets and make it a list for later use.

	if(environment_smash)
		EscapeConfinement()

	if(AICanContinue(possible_targets))
		var/atom/target_from = GET_TARGETS_FROM(src)
		if(!QDELETED(target) && !target_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     //if we lose our target
			if(AIShouldSleep(possible_targets))	// we try to acquire a new one
				toggle_ai(AI_IDLE)			// otherwise we go idle
	return 1

/mob/living/simple_animal/chicken/handle_automated_movement()
	. = ..()
	if(dodging && target && in_melee && isturf(loc) && isturf(target.loc))
		var/datum/cb = CALLBACK(src,.proc/sidestep)
		if(sidestep_per_cycle > 1) //For more than one just spread them equally - this could changed to some sensible distribution later
			var/sidestep_delay = SSnpcpool.wait / sidestep_per_cycle
			for(var/i in 1 to sidestep_per_cycle)
				addtimer(cb, (i - 1)*sidestep_delay)
		else //Otherwise randomize it to make the players guessing.
			addtimer(cb,rand(1,SSnpcpool.wait))

/mob/living/simple_animal/chicken/proc/sidestep()
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

/mob/living/simple_animal/chicken/attacked_by(obj/item/I, mob/living/user)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client && user)
		FindTarget(list(user), 1)
	return ..()

/mob/living/simple_animal/chicken/bullet_act(obj/item/projectile/P)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client)
		if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
			FindTarget(list(P.firer), 1)
		Goto(P.starting, move_to_delay, 3)
	return ..()

/mob/living/simple_animal/chicken/proc/OpenFire(atom/A)
	if(CheckFriendlyFire(A))
		return

	if(!(simple_mob_flags & SILENCE_RANGED_MESSAGE))
		visible_message("<span class='danger'><b>[src]</b> [ranged_message] at [A]!</span>")


	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, .proc/Shoot, A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
	ranged_cooldown = world.time + ranged_cooldown_time


/mob/living/simple_animal/chicken/proc/Shoot(atom/targeted_atom)
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(QDELETED(targeted_atom) || targeted_atom == target_from.loc || targeted_atom == target_from )
		return
	var/turf/startloc = get_turf(target_from)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype(startloc)
		playsound(src, projectilesound, 100, 1)
		casing.fire_casing(targeted_atom, src, null, null, null, ran_zone(), 0, 1,  src)
	else if(projectiletype)
		var/obj/item/projectile/P = new projectiletype(startloc)
		playsound(src, projectilesound, 100, 1)
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = targeted_atom.y - startloc.y
		P.xo = targeted_atom.x - startloc.x
		if(AIStatus != AI_ON)//Don't want mindless mobs to have their movement screwed up firing in space
			newtonian_move(get_dir(targeted_atom, target_from))
		P.original = targeted_atom
		P.preparePixelProjectile(targeted_atom, src)
		P.fire()

/mob/living/simple_animal/chicken/proc/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) // Not 100% reliable but this is faster than simulating actual trajectory
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(faction_check_mob(L) && !attack_same)
					return TRUE
