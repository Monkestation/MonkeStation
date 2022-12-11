GLOBAL_LIST_EMPTY(special_nodes)




/proc/pull_special_node()
	if(!GLOB.special_nodes.len)
		for(var/datum/abberant_organs/node_type as anything in typesof(/datum/abberant_organs))
			if(initial(node_type.is_special))
				GLOB.special_nodes += node_type
	return pick(GLOB.special_nodes)

/proc/pull_from_tiers_weighted(total_pulls)
	var/list/tiered_nodes = list()
	for(var/datum/abberant_organs/node_type as anything in typesof(/datum/abberant_organs))
		if(!initial(node_type.is_special))
			tiered_nodes[node_type] = initial(node_type.pull_weight)

	var/list/outputed_list = list()
	for(var/i = 1 to total_pulls)
		var/datum/abberant_organs/picked_node = pickweight(tiered_nodes)
		outputed_list += picked_node

	return outputed_list


/proc/machine_do_after_visable(atom/source, delay, progress = TRUE, bar_look = "prog_bar", old_format = FALSE, image/add_image)
	var/atom/target_loc = source

	var/datum/progressbar/progbar
	if(progress)
		progbar = new /obj/effect/world_progressbar(null, source, delay, target_loc || source, bar_look, old_format, add_image)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE

	while (world.time < endtime)
		stoplag(1)
		if(!QDELETED(progbar))
			progbar.update(world.time - starttime)

	if(!QDELETED(progbar))
		progbar.end_progress()
