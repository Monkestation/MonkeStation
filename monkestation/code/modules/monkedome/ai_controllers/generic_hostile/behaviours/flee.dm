/datum/ai_behavior/flee/perform(delta_time, datum/ai_controller/controller, ...)
	. = ..()

	var/mob/living/basic/living_pawn = controller.pawn

	if(living_pawn.health >= living_pawn.flee_health)
		finish_action(controller, TRUE)

	var/mob/living/target = null
	for(var/mob/living/potential_aggression in view(5, living_pawn))
		if(controller.blackboard[BB_ENEMIES][WEAKREF(potential_aggression)] && potential_aggression.stat == CONSCIOUS)
			target = potential_aggression
			break

	if(target)
		SSmove_manager.move_away(living_pawn, target, max_dist=5, delay=5)
	else
		finish_action(controller, TRUE)
