/mob/living/carbon/movement_delay()
	. = ..()

	if(!(movement_type & (FLYING | FLOATING)) && legcuffed) //ignore the fact we lack legs
		. += legcuffed.slowdown

/mob/living/carbon/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)
	if(movement_type & FLYING)
		return 0
	if(!(lube&SLIDE_ICE))
		log_combat(src, (O ? O : get_turf(src)), "slipped on the", null, ((lube & SLIDE) ? "(LUBE)" : null))
	return loc.handle_slip(src, knockdown_amount, O, lube, paralyze, force_drop)

/mob/living/carbon/Process_Spacemove(movement_dir = FALSE)
	if(..())
		return TRUE
	if(!isturf(loc))
		return FALSE

	// Do we have a jetpack implant (and is it on)?
	if(has_jetpack_power(movement_dir))
		return TRUE

/mob/living/carbon/can_zFall(turf/source, turf/target, direction)
	if(!..())
		return FALSE
	// Jetpack allows flight over openspace
	if(has_jetpack_power(TRUE, thrust = THRUST_REQUIREMENT_GRAVITY))
		var/obj/item/tank/jetpack/J = get_jetpack()
		if(istype(J) && J.use_ion_trail)
			// Render particles to show we are using fuel
			var/obj/effect/particle_effect/ion_trails/E = new(get_turf(src))
			flick("ion_fade", E)
			E.icon_state = ""
			QDEL_IN(E, 5)
		return FALSE
	return TRUE

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(. && !(movement_type & FLOATING)) //floating is easy
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			set_nutrition(NUTRITION_LEVEL_FED - 1)	//just less than feeling vigorous
		else if(nutrition && stat != DEAD)
			adjust_nutrition(-(HUNGER_FACTOR/10))
			if(m_intent == MOVE_INTENT_RUN)
				adjust_nutrition(-(HUNGER_FACTOR/10))

/mob/living/carbon/set_usable_legs(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		if(usable_legs != 0) //From having no usable legs to having some.
			REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_legs == 0 && !(movement_type & (FLYING | FLOATING))) //From having usable legs to no longer having them.
		ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(!usable_hands)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)


/mob/living/carbon/set_usable_hands(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(usable_hands != 0) //From having no usable hands to having some.
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_hands == 0 && default_num_hands > 0) //From having usable hands to no longer having them.
		ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(!usable_legs && !(movement_type & (FLYING | FLOATING)))
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)


/mob/living/carbon/setMovetype(newval)
	. = ..()
	if(isnull(.))
		return
	if(!(. & (FLYING | FLOATING)))
		if(movement_type & (FLYING | FLOATING)) //From not flying to flying.
			remove_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE)
			REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(!(movement_type & (FLYING | FLOATING))) //From flying to no longer flying.
		var/limbless_slowdown = 0
		if(usable_legs < default_num_legs)
			limbless_slowdown += (default_num_legs - usable_legs) * 3
			if(!usable_legs)
				ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
				if(usable_hands < default_num_hands)
					limbless_slowdown += (default_num_hands - usable_hands) * 3
					if(!usable_hands)
						ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(limbless_slowdown)
			add_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=limbless_slowdown, movetypes=GROUND)
		else
			remove_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE)

/mob/living/carbon/MobBump(mob/M)
	. = ..()
	if(iscarbon(M))
		var/mob/living/carbon/affected = M
		//spread diseases
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				affected.ContactContractDisease(D)

		for(var/thing in affected.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)

/mob/living/carbon/start_pulling(atom/movable/AM, state, force, supress_message)
	. = ..()
	//Share diseases that are spread by touch
	if(iscarbon(AM))
		var/mob/living/carbon/affected = AM
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				affected.ContactContractDisease(D)

		for(var/thing in affected.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)
