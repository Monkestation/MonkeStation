/datum/ai_controller/basic
	movement_delay = 0.4 SECONDS

	blackboard = list(
		BB_AGGRESSIVE = FALSE,
		BB_ENEMIES = list(),
		BB_FLEES = TRUE,
		BB_CURRENT_LIVING_TARGET = null,
		BB_CURRENT_ATOM_TARGET = null,
		BB_RECRUIT_COOLDOWN = 0,
		BB_RECRUITS = TRUE,
		BB_RANGED = FALSE
	)

idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/basic/TryPossessPawn(atom/new_pawn)
	if(!isliving(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSS, .proc/on_crossed)
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_PAW, .proc/on_attack_paw)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_ANIMAL, .proc/on_attack_animal)
	RegisterSignal(new_pawn, COMSIG_MOB_ATTACK_ALIEN, .proc/on_attack_alien)
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, .proc/on_startpulling)
	RegisterSignal(new_pawn, COMSIG_LIVING_TRY_SYRINGE, .proc/on_try_syringe)
	RegisterSignal(new_pawn, COMSIG_ATOM_HULK_ATTACK, .proc/on_attack_hulk)
	RegisterSignal(new_pawn, COMSIG_CARBON_CUFF_ATTEMPTED, .proc/on_attempt_cuff)
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, .proc/update_movespeed)

/datum/ai_controller/basic/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(
		COMSIG_MOVABLE_CROSS,
		COMSIG_PARENT_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACK_PAW,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
		COMSIG_LIVING_START_PULL,
		COMSIG_LIVING_TRY_SYRINGE,
		COMSIG_ATOM_HULK_ATTACK,
		COMSIG_CARBON_CUFF_ATTEMPTED,
		COMSIG_MOB_MOVESPEED_UPDATED,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_MOB_ATTACK_ALIEN,
	))

	return ..() //Run parent at end

/datum/ai_controller/basic/hostile

/datum/ai_controller/basic/hostile/TryPossessPawn(atom/new_pawn)
	. = ..()
	if(. & AI_CONTROLLER_INCOMPATIBLE)
		return
	blackboard[BB_AGGRESSIVE] = TRUE

/datum/ai_controller/basic/on_sentience_gained()
	. = ..()
	UnregisterSignal(pawn, COMSIG_MOVABLE_CROSS)

/datum/ai_controller/basic/on_sentience_lost()
	. = ..()
	RegisterSignal(pawn, COMSIG_MOVABLE_CROSS, .proc/on_crossed)


/datum/ai_controller/basic/able_to_run()
	. = ..()
	var/mob/living/living_pawn = pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return FALSE

/datum/ai_controller/basic/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force && I.damtype != STAMINA)
		retaliate(user)

/datum/ai_controller/basic/proc/on_attack_hand(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(user.a_intent == INTENT_HARM && prob(MONKEY_RETALIATE_HARM_PROB))
		retaliate(user)
	else if(user.a_intent == INTENT_DISARM && prob(MONKEY_RETALIATE_DISARM_PROB))
		retaliate(user)

/datum/ai_controller/basic/proc/on_attack_paw(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/basic/proc/on_attack_animal(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(user.melee_damage > 0 && prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/basic/proc/on_attack_alien(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/basic/proc/on_bullet_act(datum/source, obj/item/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj , /obj/item/projectile/beam)||istype(Proj, /obj/item/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				retaliate(Proj.firer)

/datum/ai_controller/basic/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		var/mob/thrown_by = I.thrownby?.resolve()
		if(I.throwforce && I.throwforce < living_pawn.health && ishuman(thrown_by))
			var/mob/living/carbon/human/H = thrown_by
			retaliate(H)

/datum/ai_controller/basic/proc/on_attack_hulk(datum/source, mob/user)
	SIGNAL_HANDLER
	retaliate(user)

/datum/ai_controller/monkey/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown

///Reactive events to being hit
/datum/ai_controller/monkey/proc/retaliate(mob/living/L)
	var/list/enemies = blackboard[BB_ENEMIES]
	enemies[WEAKREF(L)] += 10
