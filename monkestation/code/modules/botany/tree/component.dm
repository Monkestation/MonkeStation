#define MAJOR_AMOUNT 10

#define MINOR_AMOUNT 3
/datum/component/botany_tree
	///level variables of the tree
	var/current_level = 1
	var/max_level = 20
	///list of all held nodes
	var/list/held_level_nodes = list()
	///list of nodes that need to be triggered on pulse
	var/list/pulse_nodes = list()
	///list of final growth nodes
	var/list/final_growth_nodes = list()
	///list of nodes that trigger on levelup
	var/list/levelup_nodes = list()
	///the list of nearby trays that are affected by the pulse
	var/list/nearby_trays = list()
	///list of all treelings spawned
	var/list/spawned_treelings = list()
	///list of unfufilled level requirements
	var/list/unfufilled_requirements = list()
	///how far out the pulse goes from the tree
	var/pulse_range = 5
	///how many choices you have per level
	var/choices = 3
	///amount of time in seconds between pulses
	var/pulse_time = 30 SECONDS

/datum/component/botany_tree/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_BOTANY_FINAL_GROWTH, .proc/on_plant_final_growth)

	get_level_requirements()

	INVOKE_ASYNC(src, /datum/component/botany_tree.proc/init_pulse)

/datum/component/botany_tree/proc/get_level_requirements()
	var/next_level = current_level + 1
	var/list/major_levels = list(5,10,15,20)
	var/count = 0
	if(next_level in major_levels)
		count = MAJOR_AMOUNT
	else
		count = MINOR_AMOUNT
	for(var/increment = 1, increment <= count, increment++)
		var/obj/item/seeds/picked_seed = pick(typesof(/obj/item/seeds) - /obj/item/seeds - /obj/item/seeds/gatfruit - /obj/item/seeds/random - typesof(/obj/item/seeds/lavaland))
		unfufilled_requirements += picked_seed

/datum/component/botany_tree/proc/on_plant_final_growth(datum/source, obj/machinery/hydroponics/grown_location)
	if(grown_location.myseed.type in unfufilled_requirements)
		unfufilled_requirements -= grown_location.myseed.type
	for(var/datum/tree_node/listed_tree_node as anything in final_growth_nodes)
		listed_tree_node.final_growth(grown_location)

/datum/component/botany_tree/proc/trigger_level()
	var/next_level = current_level + 1
	var/list/major_levels = list(5,10,15,20)
	var/list/picked_nodes = list()
	if(next_level in major_levels)
		var/list/major_nodes = (typesof(/datum/tree_node/major) - /datum/tree_node/major)
		for(var/number = 1, number <= choices, number++)
			if(major_nodes.len)
				var/datum/tree_node/major/picked_node = pick(major_nodes)
				var/datum/tree_node/major/created_node = new picked_node
				picked_nodes += created_node
				created_node.on_choice_generation()
	else
		var/list/minor_nodes = (typesof(/datum/tree_node/minor) - /datum/tree_node/minor)
		for(var/number = 1, number <= choices, number++)
			if(minor_nodes.len)
				var/datum/tree_node/minor/picked_node = pick(minor_nodes)
				minor_nodes -= picked_node
				var/datum/tree_node/minor/created_node = new picked_node
				picked_nodes += created_node
				created_node.on_choice_generation()

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


/datum/component/botany_tree/proc/init_pulse()
	var/image/used_image = image('monkestation/icons/effects/effects.dmi', icon_state = "pulse")
	if(machine_do_after_visable(parent, pulse_time, add_image = used_image))
		pulse()

/datum/component/botany_tree/proc/pulse()
	for(var/datum/tree_node/listed_node as anything in pulse_nodes)
		listed_node.on_pulse()
	INVOKE_ASYNC(src, /datum/component/botany_tree.proc/init_pulse)
