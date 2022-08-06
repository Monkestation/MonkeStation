/datum/ai_behavior/chicken_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM //performs to increase frustration

/datum/ai_behavior/chicken_attack_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat != CONSCIOUS)
		finish_action(controller, TRUE) //we don't want chickens to kill or maybe we do this can be adjusted

	if(isturf(target.loc) && !IS_DEAD_OR_INCAP(living_pawn)) // Check if they're a valid target
		chicken_attack(controller, target, delta_time, FALSE)

/datum/ai_behavior/chicken_attack_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	SSmove_manager.stop_looping(living_pawn)
	controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = null

/// attack using a projectile otherwise unarmed the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/chicken_attack_mob/proc/shoot(atom/targeted_atom, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/atom/target_from = living_pawn
	if(QDELETED(targeted_atom) || targeted_atom == target_from.loc || targeted_atom == target_from )
		return
	var/turf/startloc = get_turf(target_from)
	if(controller.blackboard[BB_CHICKEN_PROJECTILE])
		var/projectile_type = controller.blackboard[BB_CHICKEN_PROJECTILE]
		var/obj/item/projectile/used_projectile = new projectile_type(startloc)
		used_projectile.starting = startloc
		used_projectile.firer = living_pawn
		used_projectile.fired_from = living_pawn
		used_projectile.yo = targeted_atom.y - startloc.y
		used_projectile.xo = targeted_atom.x - startloc.x
		used_projectile.original = targeted_atom
		used_projectile.preparePixelProjectile(targeted_atom, living_pawn)
		used_projectile.fire()
		return used_projectile

/datum/ai_behavior/chicken_attack_mob/proc/chicken_attack(datum/ai_controller/controller, mob/living/target, delta_time, disarm)
	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	living_pawn.changeNext_move(CLICK_CD_MELEE) //We play fair

	living_pawn.face_atom(target)

	living_pawn.a_intent = INTENT_HARM

	// check for projectile and roll a dice, than fire that bad boy
	if(controller.blackboard[BB_CHICKEN_PROJECTILE] && DT_PROB(5, delta_time))
		shoot(target, controller)

	// attack with weapon if we have one (we don't as of now as sword chickens are frauds)
	if(living_pawn.CanReach(target))
		living_pawn.UnarmedAttack(target)

	living_pawn.a_intent = INTENT_HELP

	// no de-aggro
	if(controller.blackboard[BB_CHICKEN_AGGRESSIVE])
		return

	// reduce aggro
	if(DT_PROB(CHICKEN_HATRED_REDUCTION_PROB, delta_time))
		controller.blackboard[BB_CHICKEN_SHITLIST][target]--

	// if we are not angry at our target, go back to idle
	if(controller.blackboard[BB_CHICKEN_SHITLIST][target] <= 0)
		var/list/enemies = controller.blackboard[BB_CHICKEN_SHITLIST]
		enemies.Remove(target)
		if(controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] == target)
			finish_action(controller, TRUE)

/datum/ai_behavior/recruit_chickens/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	controller.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] = world.time + CHICKEN_RECRUIT_COOLDOWN
	var/mob/living/living_pawn = controller.pawn

	for(var/mob/living/living_viewers in view(living_pawn, CHICKEN_ENEMY_VISION))
		if(!HAS_AI_CONTROLLER_TYPE(living_viewers, /datum/ai_controller/chicken))
			continue

		if(!DT_PROB(CHICKEN_RECRUIT_PROB, delta_time))
			continue

		var/datum/ai_controller/chicken/chicken_ai = living_viewers.ai_controller

		var/atom/your_enemy = controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]
		var/list/enemies = living_viewers.ai_controller.blackboard[BB_CHICKEN_SHITLIST]
		enemies[your_enemy] = CHICKEN_RECRUIT_HATED_AMOUNT
		chicken_ai.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] = world.time + CHICKEN_RECRUIT_COOLDOWN
	finish_action(controller, TRUE)

/datum/ai_behavior/chicken_flee

/datum/ai_behavior/chicken_flee/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	var/mob/living/target = null

	// flee from anyone who attacked us and we didn't beat down
	for(var/mob/living/L in view(living_pawn, CHICKEN_FLEE_VISION))
		if(controller.blackboard[BB_CHICKEN_SHITLIST][L] && L.stat == CONSCIOUS)
			target = L
			break

	if(target)
		SSmove_manager.move_away(living_pawn, target, max_dist = CHICKEN_ENEMY_VISION, delay = 5)
	else
		finish_action(controller, TRUE)

/datum/ai_behavior/chicken_ability

/datum/ai_behavior/chicken_ability/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/chicken/living_pawn = controller.pawn
	controller.blackboard[BB_CHICKEN_ABILITY_COOLDOWN] = world.time + living_pawn.cooldown_time
	// real simple for now will expand this with unique abilities as need be
	living_pawn.apply_status_effect(controller.blackboard[BB_CHICKEN_ABILITY])

	finish_action(controller, TRUE)

/datum/ai_behavior/chicken_honk

/datum/ai_behavior/chicken_honk/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	controller.blackboard[BB_CHICKEN_HONKING_COOLDOWN] = world.time + DEFAULT_HONK_CD
	var/mob/living/target = controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]

	if(living_pawn.next_move > world.time)
		return

	if(DT_PROB(10, delta_time) && controller.blackboard[BB_CHICKEN_HONKS_SORROW])
		living_pawn.apply_status_effect(ANGRY_HONK_SPEED)

	living_pawn.changeNext_move(CLICK_CD_MELEE) //We play fair

	living_pawn.face_atom(target)

	// forcing the move here because we aren't in hostile mode so we don't manually trigger hostile_jps
	SSmove_manager.hostile_jps_move(living_pawn, target, 2, minimum_distance = 1)

	living_pawn.a_intent = INTENT_HARM // not really lol but i wanna attach a slip to it

	// honk the bastard
	if(living_pawn.CanReach(target))
		living_pawn.UnarmedAttack(target)
		target.slip(5 SECONDS, FALSE)

		if(controller.blackboard[BB_CHICKEN_HONKS_SORROW])
			living_pawn.emote("cries")

		living_pawn.a_intent = INTENT_HELP

		SSmove_manager.stop_looping(living_pawn) // since we added gotta also remove

		if(!controller.blackboard[BB_CHICKEN_HONKS_SORROW]) // these fucks don't forget
			controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = null

		controller.queue_behavior(/datum/ai_behavior/chicken_flee)
		finish_action(controller, TRUE)

/datum/ai_behavior/chicken_honk_target

/datum/ai_behavior/chicken_honk_target/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	if(controller.blackboard[BB_CHICKEN_HONKS_SORROW])
		var/list/clucking_mad = list()
		for(var/mob/living/carbon/human/unlucky in GLOB.player_list)
			clucking_mad |= unlucky
		controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = pick(clucking_mad)
		clucking_mad = null
	else
		var/list/pick_me = list()
		for(var/mob/living/carbon/human/target in view(living_pawn, CHICKEN_ENEMY_VISION))
			pick_me |= target
		controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = pick(pick_me)
	finish_action(controller, TRUE)

/datum/ai_behavior/revolution

/datum/ai_behavior/revolution/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	var/list/viable_conversions = list()
	for(var/mob/living/simple_animal/chicken/found_chicken in view(4, living_pawn.loc))
		if(!istype(found_chicken, /mob/living/simple_animal/chicken/rev_raptor) || !istype(found_chicken, /mob/living/simple_animal/chicken/raptor))
			viable_conversions |= found_chicken
	var/mob/living/simple_animal/chicken/conversion_target = pick(viable_conversions)

	SSmove_manager.hostile_jps_move(living_pawn, conversion_target, 2, minimum_distance = 1)

	if(living_pawn.CanReach(conversion_target))
		new /mob/living/simple_animal/chicken/raptor(conversion_target.loc)
		qdel(conversion_target)
		living_pawn.say("VIVA, BAWK!")
		controller.blackboard[BB_CHICKEN_ABILITY_COOLDOWN] = world.time + 10 SECONDS
		SSmove_manager.stop_looping(living_pawn) // since we added gotta also remove
		finish_action(controller, TRUE)

/datum/ai_behavior/eat_ground_food

/datum/ai_behavior/eat_ground_food/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/chicken/living_pawn = controller.pawn
	controller.blackboard[BB_CHICKEN_FOOD_COOLDOWN] = world.time + 60 SECONDS
	if(living_pawn.current_feed_amount > 3) // so no vomit
		finish_action(controller, TRUE)

	var/list/floor_foods = list()
	for(var/obj/item/food/food_item in view(CHICKEN_ENEMY_VISION, living_pawn.loc))
		floor_foods |= food_item
	if(floor_foods.len)
		var/obj/item/food/chosen_one = pick(floor_foods)

		step_to(living_pawn, chosen_one, 1)

		if(living_pawn.CanReach(chosen_one))
			living_pawn.feed_food(chosen_one)
			finish_action(controller, TRUE)
		if(!chosen_one)
			finish_action(controller, TRUE)
	else
		finish_action(controller, TRUE)


/datum/ai_behavior/follow_leader

/datum/ai_behavior/follow_leader/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_CHICKEN_CURRENT_LEADER]

	if(controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]) // they care more about attacking right now
		finish_action(controller, TRUE)
	if(target)
		step_to(living_pawn, target,1)
	else
		finish_action(controller, TRUE)
