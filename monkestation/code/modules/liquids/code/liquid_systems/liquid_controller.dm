SUBSYSTEM_DEF(liquids)
	name = "Liquid Turfs"
	wait = 0.5 SECONDS
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/active_turfs = list()
	var/list/currentrun_active_turfs = list()

	var/list/active_groups = list()

	var/list/active_immutables = list()

	var/list/evaporation_queue = list()
	var/evaporation_counter = 0 //Only process evaporation on intervals

	var/list/processing_fire = list()
	var/fire_counter = 0 //Only process fires on intervals

	var/list/singleton_immutables = list()

	var/run_type = SSLIQUIDS_RUN_TYPE_TURFS

/datum/controller/subsystem/liquids/stat_entry(msg)
	msg += "AT:[active_turfs.len]|AG:[active_groups.len]|AIM:[active_immutables.len]|EQ:[evaporation_queue.len]|PF:[processing_fire.len]"
	return ..()


/datum/controller/subsystem/liquids/fire(resumed = FALSE)
	if(!currentrun_active_turfs.len && active_turfs.len)
		for(var/g in active_groups)
			var/datum/liquid_group/LG = g
			currentrun_active_turfs += LG.members
	for(var/tur in currentrun_active_turfs)
		if(MC_TICK_CHECK)
			return
		var/turf/T = tur
		if(!T.liquids)
			currentrun_active_turfs -= T
		else
			T.process_liquid_cell()
			T.liquids.liquid_group.process_member(T)
			currentrun_active_turfs -= T //work off of index later

	for(var/g in active_groups)
		var/datum/liquid_group/LG = g
		LG.process_group()
		if(MC_TICK_CHECK)
			return
	run_type = SSLIQUIDS_RUN_TYPE_EVAPORATION

	if(run_type == SSLIQUIDS_RUN_TYPE_IMMUTABLES)
		for(var/t in active_immutables)
			var/turf/T = t
			T.process_immutable_liquid()
			/*
			if(MC_TICK_CHECK)
				return
			*/
	if(run_type == SSLIQUIDS_RUN_TYPE_EVAPORATION)
		run_type = SSLIQUIDS_RUN_TYPE_FIRE
		evaporation_counter++
		if(evaporation_counter >= REQUIRED_EVAPORATION_PROCESSES)
			for(var/t in evaporation_queue)
				var/turf/T = t
				if(prob(EVAPORATION_CHANCE))
					if(!T.liquids)
						evaporation_queue -= T
						return
					T.liquids.process_evaporation()
				if(MC_TICK_CHECK)
					return
			evaporation_counter = 0

	if(run_type == SSLIQUIDS_RUN_TYPE_FIRE)
		fire_counter++
		if(fire_counter >= REQUIRED_FIRE_PROCESSES)
			for(var/t in processing_fire)
				var/turf/T = t
				T.liquids.process_fire()
			if(MC_TICK_CHECK)
				return
			fire_counter = 0

/datum/controller/subsystem/liquids/proc/add_active_turf(turf/T)
	if(!active_turfs[T])
		active_turfs[T] = TRUE

/datum/controller/subsystem/liquids/proc/remove_active_turf(turf/T)
	if(active_turfs[T])
		active_turfs -= T

/client/proc/toggle_liquid_debug()
	set category = "Debug"
	set name = "Liquid Groups Color Debug"
	set desc = "Liquid Groups Color Debug."
	if(!holder)
		return
	GLOB.liquid_debug_colors = !GLOB.liquid_debug_colors
