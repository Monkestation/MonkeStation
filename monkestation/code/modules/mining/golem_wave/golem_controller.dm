/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/processing = TRUE
	var/obj/machinery/drill/nearby_drill

	// Wave related variables
	var/datum/golem_wave/GW  // Golem wave datum
	var/count = 0  // Number of burrows created since the start
	var/time_burrow = 0  // Timestamp of last created burrow
	var/time_spawn = 0  // Timestamp of last spawn wave

	var/list/mob/living/simple_animal/hostile/asteroid/golem/golems = list()


	var/wave_number = 1
	var/initial_seismic = 0

/datum/golem_controller/New(turf/location, seismic, drill)
	loc = location
	var/path = GLOB.golem_waves[seismic]  // Retrieve which kind of wave it is depending on seismic activity
	initial_seismic = seismic
	GW = new path()
	if(drill)
		nearby_drill = drill

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	processing = FALSE  // Stop processing
	qdel(GW)  // Destroy wave object
	GW = null
	nearby_drill = null
	for(var/obj/structure/golem_burrow/GB in burrows)  // Unlink burrows and controller
		GB.stop()
	..()

/datum/golem_controller/process()
	// Currently, STOP_PROCESSING does NOT instantly remove the object from processing queue
	// This is a quick and dirty fix for runtime error spam caused by this
	if(!processing)
		return

	if(count >= GW.burrow_count)
		nearby_drill.balloon_alert_to_viewers("WAVE COMPLETED: 30 SECONDS UNTIL THE NEXT WAVE WILL COMMENCE", vison_distance = 10)
		spawn(30 SECONDS)
			nearby_drill.balloon_alert_to_viewers("NEW WAVE HAS COMMENCED", vison_distance = 10)
			count = 0
			var/path = GLOB.golem_waves[min(initial_seismic+1, 8)]
			GW = null
			GW = new path()

	// Check if a new burrow should be created
	if(count < GW.burrow_count && (world.time - time_burrow) > GW.burrow_interval)
		time_burrow = world.time
		count++
		spawn_golem_burrow()

	// Check if a new spawn wave should occur
	if((world.time - time_spawn) > GW.spawn_interval)
		time_spawn = world.time
		spawn_golems()

/datum/golem_controller/proc/spawn_golem_burrow()
	// Spawn burrow randomly in a donut around the drill
	var/turf/T = pick(range(7, loc))
	if(!istype(T))  // Try again with a smaller circle
		T = pick(range(6, loc))
		if(!istype(T))  // Something wrong is happening
			return
	while(loc && check_density_no_mobs(T) && T != loc)
		T = get_step(T, get_dir(T, loc))
	// If we end up on top of the drill, just spawn next to it
	if(T == loc)
		T = get_step(loc, pick(GLOB.cardinals))

	burrows += new /obj/structure/golem_burrow(T, src)  // Spawn burrow at final location

/datum/golem_controller/proc/spawn_golems()
	// Spawn golems at all burrows
	for(var/obj/structure/golem_burrow/GB in burrows)
		if(!GB.loc)  // If the burrow is in nullspace for some reason
			burrows -= GB  // Remove it from the pool of burrows
			continue
		var/list/possible_directions = GLOB.cardinals.Copy()
		var/i = 0
		var/proba = GW.special_probability
		// Spawn golems around the burrow on free turfs
		while(i < GW.golem_spawn && possible_directions.len)
			var/turf/possible_T = get_step(GB.loc, pick_n_take(possible_directions))
			if(!check_density_no_mobs(possible_T))
				var/golemtype
				if(prob(proba))
					golemtype = pick(GLOB.golems_special)  // Pick a special golem
					proba = max(0, proba - 10)  // Decreasing probability to avoid mass spawn of special
				else
					golemtype = pick(GLOB.golems_normal)  // Pick a normal golem
				i++
				new golemtype(possible_T, drill=nearby_drill, parent=src) // Spawn golem at free location

		// Spawn remaining golems on top of burrow
		if(i < GW.golem_spawn)
			for(var/j in i to (GW.golem_spawn-1))
				var/golemtype
				if(prob(proba))
					golemtype = pick(GLOB.golems_special)  // Pick a special golem
					proba = max(0, proba - 10)  // Decreasing probability to avoid mass spawn of special
				else
					golemtype = pick(GLOB.golems_normal)  // Pick a normal golem
				new golemtype(GB.loc, drill=nearby_drill, parent=src)  // Spawn golem at that burrow

/datum/golem_controller/proc/stop()
	// Disable wave
	processing = FALSE

	// Delete controller and all golems after given delay
	spawn(3 MINUTES)
		// Delete burrows
		for(var/obj/structure/golem_burrow/BU in burrows)
			qdel(BU)

		// Delete golems
		for(var/mob/living/simple_animal/hostile/asteroid/golem/GO in golems)
			GO.ore_type = null  // Do not spawn ores
			GO.death(FALSE, "burrows into the ground.")

		// Delete controller
		qdel(src)

/datum/golem_controller/proc/check_density_no_mobs(turf/F)
	if(F.density)
		return TRUE
	for(var/atom/A in F)
		if(A.density && !ismob(A))
			return TRUE
	return FALSE
