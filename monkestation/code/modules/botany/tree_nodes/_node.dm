/datum/tree_node
	var/name = "Base Tree Node"
	var/desc = "Baseline tree node you shouldn't see this"

	///is it a major node?
	var/is_major = FALSE
	///what level does the tree need to be to appear.
	var/min_level = 1

/datum/tree_node/proc/on_choice_generation()
	return

/datum/tree_node/proc/on_add()
	return

/datum/tree_node/proc/on_pulse(list/affected_plants)
	return
