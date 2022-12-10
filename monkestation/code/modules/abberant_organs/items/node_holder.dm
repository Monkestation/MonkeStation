/obj/item/node_holder
	name = "Organ Node Holder"
	desc = "Holds an organ node, needed to create abberant organs"

	icon = 'monkestation/icons/obj/abberant_organ.dmi'
	icon_state = "node_empty"
	var/datum/abberant_organs/held_node

/obj/item/node_holder/debug/Initialize(mapload)
	. = ..()
	icon_state = "node_full"
	var/datum/abberant_organs/input/damage/debug = new()
	held_node = debug
