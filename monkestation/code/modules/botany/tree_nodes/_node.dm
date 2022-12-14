/datum/tree_node
	var/name = "Base Tree Node"
	var/desc = "Baseline tree node you shouldn't see this"
	var/ui_icon = "soap"

	///is it a major node?
	var/is_major = FALSE
	///what level does the tree need to be to appear.
	var/min_level = 1

	var/on_pulse = FALSE
	var/on_final_growth = FALSE
	var/on_levelup = FALSE

	var/visual_change
	var/visual_numerical_change

	var/color_change_leaf
	var/color_change_trunk

/datum/tree_node/proc/on_choice_generation()
	return

/datum/tree_node/proc/on_tree_add()
	return

/datum/tree_node/proc/on_pulse(list/affected_plants, pulse_range)
	return

/datum/tree_node/proc/final_growth(obj/machinery/hydroponics/grown_location)
	return

/datum/tree_node/proc/on_levelup()
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
