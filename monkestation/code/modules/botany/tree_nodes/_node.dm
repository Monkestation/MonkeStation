/datum/tree_node
	var/name = "Base Tree Node"
	var/desc = "Baseline tree node you shouldn't see this"
	var/ui_icon = "soap"

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

/datum/tree_node/proc/final_growth(obj/machinery/hydroponics/grown_location)
	return

/datum/tree_node/proc/get_ui_data()
	return list(
		"name" = name,
		"desc" = desc,
		"ref" = REF(src),
		"icon" = ui_icon
	)


/datum/tree_node/minor
	name = "Minor Node"
	desc = "Holder minor node you shouldn't be seeing this!"

/datum/tree_node/major
	name = "Major Node"
	desc = "Holder major node you shouldn't be seeing this!"
