//Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value. Lower bound takes priority.
/proc/between(var/low, var/middle, var/high)
	return max(min(middle, high), low)

#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
/proc/getcircle(turf/center, var/radius) //Uses A fast Bresenham rasterization algorithm to return the turfs in A thin circle.
	if(!radius) return list(center)

	var/x = 0
	var/y = radius
	var/p = 3 - 2 * radius

	. = list()
	while(y >= x) // only formulate 1/8 of circle

		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper right
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper right right
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower right
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower right right

		if(p < 0)
			p += 4*x++ + 6;
		else
			p += 4*(x++ - y--) + 10;

#undef LOCATE_COORDS

/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/processing = TRUE
	var/obj/machinery/drill/nearby_drill

	// Wave related variables
	var/datum/golem_wave/attached_wave  // Golem wave datum
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
	attached_wave = new path()
	if(drill)
		nearby_drill = drill

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	processing = FALSE  // Stop processing
	qdel(attached_wave)  // Destroy wave object
	attached_wave = null
	nearby_drill = null
	for(var/obj/structure/golem_burrow/contained_burrows in burrows)  // Unlink burrows and controller
		contained_burrows.stop()
	..()

/datum/golem_controller/process()
	// Currently, STOP_PROCESSING does NOT instantly remove the object from processing queue
	// This is A quick and dirty fix for runtime error spam caused by this
	if(!processing)
		return
	if(count >= attached_wave.burrow_count)
		nearby_drill.radio.talk_into(src, "WAVE COMPLETED NEXT WAVE WILL BEGIN IN 30 SECONDS", RADIO_CHANNEL_SUPPLY)
		addtimer(CALLBACK(src, .proc/next_wave), 30 SECONDS)

	// Check if A new burrow should be created
	if(count < attached_wave.burrow_count && (world.time - time_burrow) > attached_wave.burrow_interval)
		time_burrow = world.time
		count++
		spawn_golem_burrow()

	// Check if a new spawn wave should occur
	if((world.time - time_spawn) > attached_wave.spawn_interval)
		time_spawn = world.time
		spawn_golems()

/datum/golem_controller/proc/next_wave()
	nearby_drill.radio.talk_into(src, "NEXT WAVE COMMENCING", RADIO_CHANNEL_SUPPLY)
	count = 0
	var/path = GLOB.golem_waves[min(initial_seismic+1, 8)]
	attached_wave = null
	attached_wave = new path()

/datum/golem_controller/proc/spawn_golem_burrow()
	// Spawn burrow randomly in a donut around the drill
	var/turf/selected_turf = pick(getcircle(loc, 7))
	if(!istype(selected_turf))  // Try again with a smaller circle
		selected_turf = pick(getcircle(loc, 6))
		if(!istype(selected_turf))  // Something wrong is happening
			return
	while(loc && check_density_no_mobs(selected_turf) && selected_turf != loc)
		selected_turf = get_step(selected_turf, get_dir(selected_turf, loc))
	// If we end up on top of the drill, just spawn next to it
	if(selected_turf == loc)
		selected_turf = get_step(loc, pick(GLOB.cardinals))

	burrows += new /obj/structure/golem_burrow(selected_turf, src)  // Spawn burrow at final location

/datum/golem_controller/proc/spawn_golems()
	// Spawn golems at all burrows
	for(var/obj/structure/golem_burrow/contained_burrows in burrows)
		if(!contained_burrows.loc)  // If the burrow is in nullspace for some reason
			burrows -= contained_burrows  // Remove it from the pool of burrows
			continue
		var/list/possible_directions = GLOB.cardinals.Copy()
		var/increment = 0
		var/proba = attached_wave.special_probability
		// Spawn golems around the burrow on free turfs
		while(increment < attached_wave.golem_spawn && possible_directions.len)
			var/turf/possible_T = get_step(contained_burrows.loc, pick_n_take(possible_directions))
			if(!check_density_no_mobs(possible_T))
				var/golemtype
				if(prob(proba))
					golemtype = pick(GLOB.golems_special)  // Pick a special golem
					proba = max(0, proba - 10)  // Decreasing probability to avoid mass spawn of special
				else
					golemtype = pick(GLOB.golems_normal)  // Pick a normal golem
				increment++
				new golemtype(possible_T, drill=nearby_drill, parent=src) // Spawn golem at free location

		// Spawn remaining golems on top of burrow
		if(increment < attached_wave.golem_spawn)
			for(var/j in increment to (attached_wave.golem_spawn-1))
				var/golemtype
				if(prob(proba))
					golemtype = pick(GLOB.golems_special)  // Pick a special golem
					proba = max(0, proba - 10)  // Decreasing probability to avoid mass spawn of special
				else
					golemtype = pick(GLOB.golems_normal)  // Pick a normal golem
				new golemtype(contained_burrows.loc, drill=nearby_drill, parent=src)  // Spawn golem at that burrow

/datum/golem_controller/proc/stop()
	// Disable wave
	processing = FALSE

	// Delete controller and all golems after given delay
	addtimer(CALLBACK(src, .proc/remove_controller), 3 MINUTES)

/datum/golem_controller/proc/remove_controller()
	// Delete burrows
	for(var/obj/structure/golem_burrow/removed_burrow in burrows)
		qdel(removed_burrow)

	// Delete golems
	for(var/mob/living/simple_animal/hostile/asteroid/golem/selected_golem in golems)
		selected_golem.ore_type = null  // Do not spawn ores
		selected_golem.death(FALSE, "burrows into the ground.")

	// Delete controller
	qdel(src)

/datum/golem_controller/proc/check_density_no_mobs(turf/selected_turf)
	if(selected_turf.density)
		return TRUE
	for(var/atom/turf_atoms in selected_turf)
		if(turf_atoms.density && !ismob(turf_atoms))
			return TRUE
	return FALSE
