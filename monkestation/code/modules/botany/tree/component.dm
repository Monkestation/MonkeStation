#define MAJOR_AMOUNT 10

#define MINOR_AMOUNT 3
/datum/component/botany_tree

	var/current_level = 1
	var/max_level = 20
	///list of all held nodes
	var/list/held_level_nodes
	///list of nodes that need to be triggered on pulse
	var/list/pulse_nodes
	///list of final growth nodes
	var/list/final_growth_nodes
	///the list of nearby trays that are affected by the pulse
	var/list/nearby_trays
	///list of all treelings spawned
	var/list/spawned_treelings
	///list of unfufilled level requirements
	var/list/unfufilled_requirements
	///how far out the pulse goes from the tree
	var/pulse_range = 5
	///how many choices you have per level
	var/choices = 3

/datum/component/botany_tree/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_BOTANY_FINAL_GROWTH, .proc/on_plant_final_growth)

	get_level_requirements()

/datum/component/botany_tree/proc/get_level_requirements()
	var/next_level = current_level++
	var/list/major_levels = list(5,10,15,20)
	if(next_level in major_levels)
		for(var/increment = 1 to MAJOR_AMOUNT)
			unfufilled_requirements +=	pick(typesof(/obj/item/seeds) - /obj/item/seeds - /obj/item/seeds/gatfruit - /obj/item/seeds/random)
	else
		for(var/increment = 1 to MINOR_AMOUNT)
			unfufilled_requirements +=	pick(typesof(/obj/item/seeds) - /obj/item/seeds - /obj/item/seeds/gatfruit - /obj/item/seeds/random)

/datum/component/botany_tree/proc/on_plant_final_growth(datum/source, obj/machinery/hydroponics/grown_location)
	if(grown_location.myseed.type in unfufilled_requirements)
		unfufilled_requirements -= grown_location.myseed.type
	for(var/datum/tree_node/listed_tree_node as anything in final_growth_nodes)
		listed_tree_node.final_growth(grown_location)

/datum/component/botany_tree/proc/trigger_level()
	var/next_level = current_level++
	var/list/major_levels = list(5,10,15,20)
	var/list/picked_nodes = list()
	if(next_level in major_levels)
		var/list/major_nodes = list(typesof(/datum/tree_node/major) - /datum/tree_node/major)
		for(var/number in choices)
			var/datum/tree_node/major/picked_node = pick(major_nodes)
			major_nodes -= picked_node
			picked_nodes += new picked_node
	else
		var/list/minor_nodes = list(typesof(/datum/tree_node/minor) - /datum/tree_node/minor)
		for(var/number in choices)
			var/datum/tree_node/minor/picked_node = pick(minor_nodes)
			minor_nodes -= picked_node
			picked_nodes += new picked_node

	return picked_nodes

