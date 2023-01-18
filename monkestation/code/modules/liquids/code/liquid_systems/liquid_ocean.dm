
/area/ocean
	name = "Ocean"
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = NO_ALERTS
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE

/area/ruin/ocean
	has_gravity = TRUE

/area/ruin/ocean/listening_outpost
	area_flags = UNIQUE_AREA

/area/ruin/ocean/bunker
	area_flags = UNIQUE_AREA

/area/ruin/ocean/bioweapon_research
	area_flags = UNIQUE_AREA

/area/ruin/ocean/mining_site
	area_flags = UNIQUE_AREA

/turf/open/openspace/ocean
	name = "ocean"
	planetary_atmos = TRUE
	baseturfs = /turf/open/openspace/ocean
	var/replacement_turf = /turf/open/floor/plating/ocean

/turf/open/openspace/ocean/Initialize()
	. = ..()
	ChangeTurf(replacement_turf, null, CHANGETURF_IGNORE_AIR)

/turf/open/openspace/ocean/Initialize()
	. = ..()


/turf/open/floor/plating/ocean
	gender = PLURAL
	name = "ocean sand"
	baseturfs = /turf/open/floor/plating/ocean
	icon = 'monkestation/code/modules/liquids/icons/turf/seafloor.dmi'
	icon_state = "seafloor"
	base_icon_state = "seafloor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	planetary_atmos = TRUE
	var/static/obj/effect/abstract/ocean_overlay/static_overlay
	var/static/list/ocean_reagents = list(/datum/reagent/water = 100)

	var/list/ocean_turfs = list()
	var/list/open_turfs = list()

/turf/open/floor/plating/ocean/Initialize()
	. = ..()
	if(!static_overlay)
		static_overlay = new(null, ocean_reagents)
	vis_contents += static_overlay
	for(var/turf/listed_turf in get_adjacent_open_turfs(src))
		if(!istype(listed_turf, /turf/open/space) || !isclosedturf(listed_turf))
			if(istype(listed_turf, src.type))
				ocean_turfs |= listed_turf
			else
				open_turfs |= listed_turf

	if(open_turfs.len)
		SSliquids.active_ocean_turfs |= src
	SSliquids.ocean_turfs |= src


/turf/open/floor/plating/ocean/Destroy()
	. = ..()
	SSliquids.active_ocean_turfs -= src
	SSliquids.ocean_turfs -= src
	for(var/turf/open/floor/plating/ocean/listed_ocean in ocean_turfs)
		listed_ocean.rebuild_adjacent()

/turf/open/floor/plating/ocean/proc/process_turf()
	for(var/turf/open/listed_open in open_turfs)
		listed_open.add_liquid_list(ocean_reagents)

/turf/open/floor/plating/ocean/proc/rebuild_adjacent()
	ocean_turfs = list()
	open_turfs = list()
	for(var/turf/open/listed_turf in get_adjacent_open_turfs(src))
		if(istype(listed_turf, /turf/open/space))
			return
		if(istype(listed_turf, src.type))
			ocean_turfs |= listed_turf
		else
			open_turfs |= listed_turf
	if(open_turfs.len)
		SSliquids.active_ocean_turfs |= src
	else if(src in SSliquids.active_ocean_turfs)
		SSliquids.active_ocean_turfs -= src

/obj/effect/abstract/ocean_overlay
	icon = 'monkestation/code/modules/liquids/icons/obj/effects/liquid.dmi'
	icon_state = "ocean"
	base_icon_state = "ocean"
	plane = BLACKNESS_PLANE //Same as weather, etc.
	layer = ABOVE_MOB_LAYER
	vis_flags = NONE

/obj/effect/abstract/ocean_overlay/Initialize(mapload, list/ocean_contents)
	. = ..()
	color = mix_color_from_reagent_list(ocean_contents)
