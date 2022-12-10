GLOBAL_LIST_EMPTY(special_nodes)




/proc/pull_special_node()
	if(!GLOB.special_nodes.len)
		for(var/datum/abberant_organs/node_type in typesof(/datum/abberant_organs))
			if(initial(node_type.is_special))
				GLOB.special_nodes += node_type
	return pick(GLOB.special_nodes)

/proc/pull_from_tiers_weighted(total_pulls)
	var/list/tiered_nodes = list()
	for(var/datum/abberant_organs/node_type in typesof(/datum/abberant_organs))
		if(!initial(node_type.is_special))
			tiered_nodes[node_type] = node_type.pull_weight

	var/list/outputed_list = list()
	for(var/i = 1 to total_pulls)
		var/datum/abberant_organs/picked_node = pickweight(tiered_nodes)
		outputed_list += picked_node

	return outputed_list
