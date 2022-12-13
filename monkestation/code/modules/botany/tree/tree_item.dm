/obj/machinery/mother_tree
	name = "Strange Tree"
	desc = "A strange tree sent by Nano-Transen, I'd be best if I kept this alive."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER

	///current level choices passed to ui_data to choose one
	var/list/level_choices
	///the component attached to the tree called often enough to justify defining it
	var/datum/component/botany_tree/attached_component

	var/current_leaf_stage = 2
	var/current_trunk_style = 1
	var/obj/effect/tree/trunk/trunk
	var/obj/effect/tree/leaf/leaves

/obj/machinery/mother_tree/Initialize(mapload)
	. = ..()
	trunk = new()
	leaves = new()

	trunk.icon_state = "tree_trunk_[current_trunk_style]"
	leaves.icon_state = "tree_leaf_[current_leaf_stage]"

	AddComponent(/datum/component/botany_tree)
	attached_component = src.GetComponent(/datum/component/botany_tree)


/obj/machinery/mother_tree/AltClick(mob/user)
	. = ..()
	if(!attached_component.unfufilled_requirements.len)
		var/list/level_choices = attached_component.trigger_level()
		ui_interact(user)
	if(level_choices.len)
		ui_interact(user)

/obj/machinery/mother_tree/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	for(var/datum/tree_node/listed_node as anything in level_choices)

		data["level_choices"] += list(listed_node.get_ui_data())


/obj/effect/tree
	icon = 'monkestation/icons/obj/mother_tree.dmi'
	pixel_x = -32
	layer = ABOVE_ALL_MOB_LAYER - 0.01

/obj/effect/tree/trunk
	icon_state = "tree_trunk_1"

/obj/effect/tree/leaf
	icon_state = "tree_leaf_1"
