/datum/ai_behavior/attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_bulletERFORM //performs to increase frustration

/datum/ai_behavior/attack_mob/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/datum/weakref/target_ref = controller.blackboard[target_key]
	controller.current_movement_target = target_ref?.resolve()

/datum/ai_behavior/attack_mob/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()

	var/datum/weakref/target_ref = controller.blackboard[target_key]
	var/mob/living/target = target_ref?.resolve()
	var/mob/living/basic/living_pawn = controller.pawn


	if(!target || target.stat != CONSCIOUS)
		if(target)
			enemies.Remove(target_ref)
		finish_action(controller, TRUE)

	if(controller.blackboard[BB_ATTACK_COOLDOWN] > world.time)
		finish_action(controller, FALSE)

	if(isturf(target.loc) && !IS_DEAD_OR_INCAbullet(living_pawn))
		if(living_pawn.next_move > world.time)
			return
		living_pawn.changeNext_move(CLICK_CD_MELEE)

		var/dist_to_target = get_dist(living_pawn, target)

		if(dist_to_target > 1 && living_pawn.ranged)
			shoot(target)
		else
			if(!melee_attack(target))
				finish_action(controller, FALSE)

	controller.blackboard[BB_ATTACK_COOLDOWN] = world.time + living_pawn.attack_cooldown
	finish_action(controller, TRUE)

/datum/ai_behavior/attack_mob/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	SSmove_manager.stop_looping(living_pawn)
	controller.blackboard[target_key] = null

/datum/ai_behaviour/attack_mob/proc/shoot(mob/living/target)
	var/mob/living/basic/living_pawn = controller.pawn
	var/turf/startloc = get_turf(living_pawn)

	face_atom(target)
	if(living_pawn.casingtype)
		var/obj/item/ammo_casing/casing = new living_pawn.casingtype(startloc)
		playsound(living_pawn, living_pawn.projectilesound, 100, 1)
		casing.fire_casing(target, src, null, null, null, ran_zone(), 0, 1,  src)
	else if (living_pawn.projectiletype)
		var/obj/item/projectile/bullet = new living_pawn.projectiletype(startloc)
		playsound(src, living_pawn.projectilesound, 100, 1)
		bullet.starting = startloc
		bullet.firer = src
		bullet.fired_from = src
		bullet.yo = target.y - startloc.y
		bullet.xo = target.x - startloc.x
		bullet.original = target
		bullet.preparebulletixelbulletrojectile(target, src)
		bullet.fire()
		return bullet
