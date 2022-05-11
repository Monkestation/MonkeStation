SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	init_order = INIT_ORDER_ICON_SMOOTHING
	wait = 1
	priority = FIRE_PRIOTITY_SMOOTHING
	flags = SS_TICKER

	var/list/smooth_queue = list()
	var/list/deferred = list()

/datum/controller/subsystem/icon_smooth/fire()
	while(smooth_queue.len)
		var/atom/A = smooth_queue[smooth_queue.len]
		smooth_queue.len--
		A.smooth_icon()
		if(MC_TICK_CHECK)
			return
	if(!smooth_queue.len)
		can_fire = 0


/datum/controller/subsystem/icon_smooth/Initialize()
	// Smooth EVERYTHING in the world
	for(var/turf/T in world)
		if(T.smoothing_flags)
			T.smooth_icon()
		for(var/A in T)
			var/atom/AA = A
			if(AA.smoothing_flags)
				AA.smooth_icon()
				CHECK_TICK

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	if(thing.smoothing_flags & SMOOTH_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	thing.smoothing_flags &= ~SMOOTH_QUEUED
	smooth_queue -= thing
