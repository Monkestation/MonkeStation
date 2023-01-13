/obj/machinery/extractor
	name = "Node Extractor"
	desc = "This machine extracts nodes from given organs while keeping the organ safe."
	icon = 'monkestation/icons/obj/abberant_organ.dmi'
	icon_state = "extractor"

	var/working = FALSE
	///biomatter variables
	var/held_goop = 0
	var/max_goop = 1000

	var/obj/item/organ/held_organ
	var/obj/machinery/biomatter_tank/linked_tank

	var/list/stored_nodes = list()


/obj/machinery/extractor/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, I))
			return
		var/obj/item/multitool/M = I
		if(istype(M.buffer, /obj/machinery/biomatter_tank))
			linked_tank = M.buffer
			to_chat(user, "<span class='notice'>You link the [src.name] to the [M.buffer].</span>")
			return TRUE
	if(istype(I, /obj/item/node_holder))
		var/obj/item/node_holder/attacking_holder = I
		if(!stored_nodes.len)
			to_chat(user, span_notice("There are no nodes to collect!"))
			return
		var/datum/abberant_organs/node_to_extract = input(user, "Select an organ node", "Node Extractor")  as null|anything in stored_nodes
		if(!node_to_extract)
			return TRUE

		attacking_holder.held_node = node_to_extract
		stored_nodes -= node_to_extract

	if(istype(I, /obj/item/organ))
		if(I.GetComponent(/datum/component/organ_gene))
			if(!user.transferItemToLoc(I, src))
				return
			eject_organ()
			held_organ = I

			process_organ(I)
	return ..()

/obj/machinery/extractor/proc/process_organ(obj/item/organ/processing_organ)
	var/image/used_image = image('monkestation/icons/obj/abberant_organ.dmi', icon_state = "extract")
	flick("extractor_closing", src)
	working = TRUE
	update_appearance()
	if(machine_do_after_visable(src, 10 SECONDS, add_image = used_image))
		var/datum/component/organ_gene/attacking_component = processing_organ.GetComponent(/datum/component/organ_gene)
		var/list/returned_data = attacking_component.extract()
		var/goop_gained = attacking_component.gained_goop
		var/destroy_organ = FALSE
		if(!processing_organ.useable)
			goop_gained += 100
			destroy_organ = TRUE
		if(linked_tank)
			linked_tank.update_goop(goop_gained)
		else
			if(goop_gained + held_goop > max_goop)
				held_goop = max_goop
			else
				held_goop += goop_gained
		stored_nodes += returned_data
		if(destroy_organ)
			qdel(processing_organ)
			qdel(held_organ)
			held_organ = null
	working  = FALSE

	flick("extractor_opening", src)
	update_appearance()

/obj/machinery/extractor/update_icon(updates)
	. = ..()
	if(working)
		icon_state = "extractor_working"
	else
		icon_state = "extractor"

/obj/machinery/extractor/proc/eject_organ()
	if (held_organ)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(held_organ))
				held_organ.forceMove(drop_location())
		else
			held_organ.forceMove(drop_location())
		held_organ = null
		. = TRUE
