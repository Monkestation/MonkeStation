/datum/ai_planning_subtree/hostile_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/basic/hostile/living_pawn = controller.pawn

	if(!controller.blackboard[BB_AGGRESSIVE] && !length(controller.blackboard[BB_ENEMIES]))
		return

	if(!controller.blackboard[BB_CURRENT_LIVING_TARGET])
		controller.queue_behavior(/datum/ai_behavior/set_combat_target, BB_CURRENT_LIVING_TARGET, BB_ENEMIES)
		return SUBTREE_RETURN_FINISH_PLANNING

	var/datum/weakref/target_ref = controller.blackboard[BB_CURRENT_LIVING_TARGET]
	var/mob/living/selected_enemy = target_ref?.resolve()

	if(!selected_enemy)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(selected_enemy.stat > 1) /// either hard crit or dead
		return SUBTREE_RETURN_FINISH_PLANNING

	if((living_pawn.health < BASE_FLEE_HEALTH) && controller.blackboard[BB_FLEES])
		controller.queue_behavior(/datum/ai_behavior/flee)
			return SUBTREE_RETURN_FINISH_PLANNING //I'm running

	if(controller.blackboard[BB_RECRUITS] &&  (controller.blackboard[BB_RECRUIT_COOLDOWN] < world.time))
		controller.queue_behavior(/datum/ai_behavior/recruit, BB_CURRENT_LIVING_TARGET, living_pawn.faction)
	controller.queue_behaviour(/datum/ai_behavior/battle_screech)
	controller.queue_behaviour(/datum/ai_controller/attack_mob, BB_CURRENT_LIVING_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING
