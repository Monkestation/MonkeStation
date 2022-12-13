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
	///list of nodes that trigger on levelup
	var/list/levelup_nodes
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
		for(var/increment = 1, increment <= MAJOR_AMOUNT, increment++)
			var/obj/item/seeds/picked_seed = new pick(typesof(/obj/item/seeds) - /obj/item/seeds - /obj/item/seeds/gatfruit - /obj/item/seeds/random)
			unfufilled_requirements += picked_seed.type
			qdel(picked_seed)
	else
		for(var/increment = 1, increment <= MINOR_AMOUNT, increment++)
			var/obj/item/seeds/picked_seed = new pick(typesof(/obj/item/seeds) - /obj/item/seeds - /obj/item/seeds/gatfruit - /obj/item/seeds/random)
			unfufilled_requirements += picked_seed.type
			qdel(picked_seed)

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
			picked_node.on_choice_generation()
	else
		var/list/minor_nodes = list(typesof(/datum/tree_node/minor) - /datum/tree_node/minor)
		for(var/number in choices)
			var/datum/tree_node/minor/picked_node = pick(minor_nodes)
			minor_nodes -= picked_node
			picked_nodes += new picked_node
			picked_node.on_choice_generation()

	return picked_nodes

/datum/component/botany_tree/proc/handle_added_node(datum/tree_node/added_node)
	held_level_nodes += added_node
	if(added_node.on_pulse)
		pulse_nodes += added_node
	if(added_node.on_final_growth)
		final_growth_nodes += added_node
	if(added_node.on_levelup)
		levelup_nodes += added_node

	added_node.on_tree_add()

/datum/component/botany_tree/proc/handle_levelup()
	for(var/datum/tree_node/listed_node as anything in levelup_nodes)
		listed_node.on_levelup()
	current_level++
	get_level_requirements()
