/datum/ai_behavior/set_combat_target/perform(delta_time, datum/ai_controller/controller, set_key, enemies_key)
	var/list/enemies = controller.blackboard[enemies_key]
	var/list/valids = list()
	var/mob/living/living_pawn = controller.pawn

	for(var/mob/living/potential_target in view(7, controller.pawn))
		var/datum/weakref/enemy_ref = WEAKREF(potential_target)
		if(potential_target == controller.pawn || ((!enemies[enemy_ref]) && !controller.blackboard[BB_AGGRESSIVE]))
			continue
		if(living_pawn.faction_check_mob(potential_target, FALSE))
			continue
		valids[enemy_ref] = CEILING(100 / (get_dist(controller.pawn, potential_target) || 1), 1)

	if(!length(valids))
		finish_action(controller, FALSE)

	controller.blackboard[set_key] = pickweightAllowZero(valids)
	finish_action(controller, TRUE)
