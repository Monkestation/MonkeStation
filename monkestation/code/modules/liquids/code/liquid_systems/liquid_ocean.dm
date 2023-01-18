/turf/open/space/ocean
	icon = 'monkestation/code/modules/liquids/icons/turf/seafloor.dmi'
	icon_state = "seafloor"
	base_icon_state = "seafloor"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	var/static/obj/effect/ocean_overlay/stored_overlay
	var/starting_temp = T20C-150
	var/list/adjacent_oceans = list()
	var/list/adjacent_open = list()

	var/static/list/ocean_contents = list(/datum/reagent/water = 100)

/turf/open/space/ocean/Initialize(mapload)
	. = .. ()
	if(!stored_overlay)
		stored_overlay = new(null, ocean_contents)
	vis_contents += stored_overlay
	for(var/turf/open/open_turf in src.GetAtmosAdjacentTurfs())
		if(!istype(open_turf, /turf/open/space/ocean) || !istype(open_turf, /turf/open/space))
			adjacent_open |= open_turf
		else
			adjacent_oceans |= open_turf
	if(adjacent_open.len)
		SSliquids.active_ocean_turfs |= src
	SSliquids.ocean_turfs |= src

/turf/open/space/ocean/Destroy()
	. = ..()
	SSliquids.active_ocean_turfs -= src
	SSliquids.ocean_turfs -= src
	for(var/turf/open/space/ocean/listed_ocean in adjacent_oceans)
		listed_ocean.rebuild_adjacent()

/turf/open/space/ocean/proc/process_turf()
	for(var/turf/open/listed_open in adjacent_open)
		listed_open.add_liquid_list(ocean_contents)

/turf/open/space/ocean/proc/rebuild_adjacent()
	adjacent_oceans = list()
	adjacent_open = list()
	for(var/turf/open/open_turf in src.GetAtmosAdjacentTurfs())
		if(!istype(open_turf, /turf/open/space/ocean))
			adjacent_open |= open_turf
		else
			adjacent_oceans |= open_turf
	if(adjacent_open.len)
		SSliquids.active_ocean_turfs |= src

/turf/open/space/ocean/proc/update_ocean_reagent(list/new_reagents)
	stored_overlay.color = mix_color_from_reagent_list(new_reagents)
	ocean_contents = new_reagents

/obj/effect/ocean_overlay
	icon = 'monkestation/code/modules/liquids/icons/obj/effects/liquid.dmi'
	icon_state = "ocean"
	base_icon_state = "ocean"
	plane = BLACKNESS_PLANE //Same as weather, etc.
	layer = ABOVE_MOB_LAYER
	vis_flags = NONE

/obj/effect/ocean_overlay/Initialize(mapload, list/ocean_contents)
	. = ..()
	color = mix_color_from_reagent_list(ocean_contents)
