/obj/effect/abstract/liquid_turf/immutable
	immutable = TRUE
	var/list/starting_mixture = list(/datum/reagent/water = 600)
	var/starting_temp = T20C

/obj/effect/abstract/liquid_turf/immutable/ocean
	icon_state = "ocean"
	base_icon_state = "ocean"
	plane = BLACKNESS_PLANE //Same as weather, etc.
	layer = ABOVE_MOB_LAYER
	starting_temp = T20C-150
	no_effects = TRUE
	vis_flags = NONE

/obj/effect/abstract/liquid_turf/immutable/ocean/warm
	starting_temp = T20C+20

/obj/effect/abstract/liquid_turf/immutable/Initialize()
	. = ..()
	reagent_list = starting_mixture.Copy()
	total_reagents = 0
	for(var/key in reagent_list)
		total_reagents += reagent_list[key]
	temp = starting_temp
	calculate_height()
	set_reagent_color_for_liquid()

/obj/effect/abstract/liquid_turf/immutable/Destroy(force)
	if(force)
		stack_trace("Something tried to hard destroy an immutable liquid.")
	return ..()

/obj/effect/abstract/liquid_turf/immutable/set_reagent_color_for_liquid()
	color = mix_color_from_reagent_list(reagent_list)

/obj/effect/abstract/liquid_turf/immutable/take_reagents_flat(flat_amount)
	return simulate_reagents_flat(flat_amount)

//Returns a flat of our reagents without any effects on the liquids
/obj/effect/abstract/liquid_turf/proc/simulate_reagents_flat(flat_amount)
	var/datum/reagents/tempr = new(10000)
	if(flat_amount >= total_reagents)
		tempr.add_reagent_list(reagent_list, no_react = TRUE)
	else
		var/fraction = flat_amount/total_reagents
		var/passed_list = list()
		for(var/reagent_type in reagent_list)
			var/amount = fraction * reagent_list[reagent_type]
			passed_list[reagent_type] = amount
		tempr.add_reagent_list(passed_list, no_react = TRUE)
	tempr.chem_temp = temp
	return tempr

/obj/effect/abstract/liquid_turf/immutable/calculate_height()
	var/new_height = CEILING(total_reagents, 1)/LIQUID_HEIGHT_DIVISOR
	set_height(new_height)
	var/determined_new_state
	switch(new_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			determined_new_state = LIQUID_STATE_FULLTILE
	if(determined_new_state != liquid_state)
		set_new_liquid_state(determined_new_state)

/obj/effect/abstract/liquid_turf/immutable/set_height(new_height)
	height = new_height
