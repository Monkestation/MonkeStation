/obj/machinery/mother_tree
	name = "Strange Tree"
	desc = "A strange tree sent by Nano-Transen, I'd be best if I kept this alive."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER -0.1

	///the list of level choices we currently have
	var/list/level_choices = list()
	///the component attached to the tree called often enough to justify defining it
	var/datum/component/botany_tree/attached_component

	var/current_leaf_stage = 2
	var/current_trunk_style = 1

	var/obj/effect/tree/trunk/trunk
	var/obj/effect/tree/leaf/leaves

	var/trunk_color = "#64483F"
	var/leaf_color = "#95B458"
	var/sapling_color = "#95B458"

	var/debug = FALSE

/obj/machinery/mother_tree/Initialize(mapload)
	. = ..()
	trunk = new()
	leaves = new()

	trunk.icon_state = "sapling_1"

	trunk.color = sapling_color
	leaves.color = leaf_color

	add_overlay(trunk)
	add_overlay(leaves)

	AddComponent(/datum/component/botany_tree)
	attached_component = src.GetComponent(/datum/component/botany_tree)


/obj/machinery/mother_tree/AltClick(mob/user)
	. = ..()
	if(!attached_component.unfufilled_requirements.len || debug)
		level_choices = attached_component.trigger_level()
		run_choice()
		return
	if(level_choices.len)
		run_choice()
		return

/obj/machinery/mother_tree/proc/run_choice()
	var/datum/tree_node/choice = input("Select a trait for the tree", "Strange Tree") as null|anything in level_choices
	if(!choice)
		return
	attached_component.handle_added_node(choice)
	attached_component.handle_levelup()
	level_choices = list()
/obj/effect/tree
	icon = 'monkestation/icons/obj/mother_tree.dmi'
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -16
	pixel_y = 12

/obj/effect/tree/trunk
	icon_state = "tree_trunk_1"

/obj/effect/tree/leaf
	icon_state = "tree_leaf_1"
