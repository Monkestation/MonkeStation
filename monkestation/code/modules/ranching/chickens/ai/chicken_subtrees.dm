/datum/ai_planning_subtree/chicken_tree/SelectBehaviors(datum/ai_controller/monkey/controller, delta_time)
	var/mob/living/simple_animal/chicken/living_pawn = controller.pawn

	var/list/enemies = controller.blackboard[BB_CHICKEN_SHITLIST]

	if(controller.blackboard[BB_CHICKEN_HONKS] && controller.blackboard[BB_CHICKEN_HONKING_COOLDOWN] < world.time && DT_PROB(25, delta_time))
		if(!controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET])
			controller.queue_behavior(/datum/ai_behavior/chicken_honk_target)
		controller.queue_behavior(/datum/ai_behavior/chicken_honk)

	var/mob/living/selected_enemy
	if(length(enemies) || controller.blackboard[BB_CHICKEN_AGGRESSIVE]) //We have enemies or are pissed
		var/list/valids = list()
		for(var/mob/living/possible_enemy in view(CHICKEN_ENEMY_VISION, living_pawn))
			if(possible_enemy == living_pawn ||  !(living_pawn.Friends[possible_enemy] >= CHICKEN_FRIENDSHIP_ATTACK) || (!enemies[possible_enemy] && (!controller.blackboard[BB_CHICKEN_AGGRESSIVE] || HAS_AI_CONTROLLER_TYPE(possible_enemy, /datum/ai_controller/chicken)))) //Are they an enemy? (And do we even care?)
				continue
			// Weighted list, so the closer they are the more likely they are to be chosen as the enemy
			valids[possible_enemy] = CEILING(100 / (get_dist(living_pawn, possible_enemy) || 1), 1)

		selected_enemy = pickweight(valids)

		if(selected_enemy)
			if(!controller.blackboard[BB_CHICKEN_AGGRESSIVE] && !controller.blackboard[BB_CHICKEN_RETALIATE])
				controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = selected_enemy
				if(controller.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] * 100 < world.time) ///basically fuck off we don't wanna cycle this
					controller.queue_behavior(/datum/ai_behavior/recruit_chickens)
				controller.queue_behavior(/datum/ai_behavior/chicken_flee)
				return // fuckin bookin it

			if(!selected_enemy.stat) //He's up, get him!
				if(living_pawn.health < CHICKEN_FLEE_HEALTH) //Time to skeddadle
					controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = selected_enemy
					if(controller.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] < world.time)
						controller.queue_behavior(/datum/ai_behavior/recruit_chickens)
					controller.queue_behavior(/datum/ai_behavior/chicken_flee)
					return //I'm running fuck you guys

				controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = selected_enemy
				controller.current_movement_target = selected_enemy
				if(controller.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] < world.time)
					controller.queue_behavior(/datum/ai_behavior/recruit_chickens)
				if(controller.blackboard[BB_CHICKEN_ABILITY] && DT_PROB(living_pawn.ability_prob, delta_time) && controller.blackboard[BB_CHICKEN_COMBAT_ABILITY] && controller.blackboard[BB_CHICKEN_ABILITY_COOLDOWN] < world.time)
					controller.queue_behavior(/datum/ai_behavior/chicken_ability)
				controller.queue_behavior(/datum/ai_behavior/chicken_attack_mob)
				return SUBTREE_RETURN_FINISH_PLANNING //Focus on this
