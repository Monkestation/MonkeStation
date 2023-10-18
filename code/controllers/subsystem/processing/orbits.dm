PROCESSING_SUBSYSTEM_DEF(orbits)
	name = "Orbits"
	flags = SS_KEEP_TIMING
	init_order = INIT_ORDER_ORBITS
	priority = FIRE_PRIORITY_ORBITS
	wait = ORBITAL_UPDATE_RATE

	//The primary orbital map.
	var/list/orbital_maps = list()

	var/datum/orbital_map_tgui/orbital_map_tgui = new()

	var/initial_asteroids = 11		// MonkeStation edit: ruins/objectives disabled

	// MonkeStation edit: renewable asteroids
	var/current_asteroids = 0		// how many asteroids are there currently?
	var/min_asteroids = 4			// how many asteroids is too few?
	var/asteroid_renew = 4			// how many asteroids do we make when we have too few?

	var/orbits_setup = FALSE

	var/list/datum/orbital_objective/possible_objectives = list()

	var/datum/orbital_objective/current_objective

	var/list/runnable_events

	var/event_probability = 60

	//key = port_id
	//value = orbital shuttle object
	var/list/assoc_shuttles = list()

	//Key = port_id
	//value = world time of next launch
	var/list/interdicted_shuttles = list()

	var/next_objective_time = 0

	//Research disks
	var/list/research_disks = list()

	var/list/datum/tgui/open_orbital_maps = list()

	//The station
	var/datum/orbital_object/station_instance

	//Ruin level count
	var/ruin_levels = 0

/datum/controller/subsystem/processing/orbits/Initialize(start_timeofday)
	. = ..()
	setup_event_list()
	//Create the main orbital map.
	orbital_maps[PRIMARY_ORBITAL_MAP] = new /datum/orbital_map()

/datum/controller/subsystem/processing/orbits/Recover()
	orbital_maps |= SSorbits.orbital_maps
	possible_objectives |= SSorbits.possible_objectives
	// ruin_events |= SSorbits.ruin_events
	assoc_shuttles |= SSorbits.assoc_shuttles
	interdicted_shuttles |= SSorbits.interdicted_shuttles
	research_disks |= SSorbits.research_disks
	if(!islist(runnable_events)) runnable_events = list()
	runnable_events |= SSorbits.runnable_events

	station_instance = SSorbits.station_instance
	current_objective = SSorbits.current_objective
	next_objective_time = SSorbits.next_objective_time
	ruin_levels = SSorbits.ruin_levels
	orbital_map_tgui = SSorbits.orbital_map_tgui
	orbits_setup = SSorbits.orbits_setup

	current_asteroids = SSorbits.current_asteroids

	for(var/datum/tgui/map as() in SSorbits.open_orbital_maps)
		map?.close()

	SSorbits.open_orbital_maps.Cut()

	for(var/datum/thing in SSorbits.processing)
		STOP_PROCESSING(SSorbits, thing)
		START_PROCESSING(src, thing)

/datum/controller/subsystem/processing/orbits/proc/setup_event_list()
	runnable_events = list()
	for(var/ruin_event in subtypesof(/datum/ruin_event))
		var/datum/ruin_event/instanced = new ruin_event()
		runnable_events[instanced] = instanced.probability

/datum/controller/subsystem/processing/orbits/proc/get_event()
	if(!event_probability)
		return null
	return pickweight(runnable_events)

/datum/controller/subsystem/processing/orbits/proc/post_load_init()
	for(var/map_key in orbital_maps)
		var/datum/orbital_map/orbital_map = orbital_maps[map_key]
		orbital_map.post_setup()
	orbits_setup = TRUE
	for(var/i in 1 to initial_asteroids)
		new /datum/orbital_object/z_linked/beacon/ruin/asteroid()
		current_asteroids += 1

/datum/controller/subsystem/processing/orbits/fire(resumed)
	if(resumed)
		. = ..()
		if(MC_TICK_CHECK)
			return
		//Update UIs
		for(var/datum/tgui/tgui as() in open_orbital_maps)
			tgui.send_update()

	// MonkeStation edit: makes asteroids renewable
	// (arbitrary values tho)
	if (current_asteroids < min_asteroids)
		for (var/i in 1 to asteroid_renew)
			new /datum/orbital_object/z_linked/beacon/ruin/asteroid()
			current_asteroids += 1

	//Do processing.
	if(!resumed)
		. = ..()
		if(MC_TICK_CHECK)
			return
		//Update UIs
		for(var/datum/tgui/tgui as() in open_orbital_maps)
			tgui.send_update()

/mob/dead/observer/verb/open_orbit_ui()
	set name = "View Orbits"
	set category = "Ghost"
	SSorbits.orbital_map_tgui.ui_interact(src)

