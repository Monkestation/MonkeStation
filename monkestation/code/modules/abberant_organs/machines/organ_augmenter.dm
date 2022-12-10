/obj/machinery/organ_augmenter
	name = "Organ Augmenter"
	desc = "Here is where you splice nodes with organs!"
	icon_state = "organ_augmenter"
	icon = 'monkestation/icons/obj/abberant_organ.dmi'

	idle_power_usage =  100
	active_power_usage = 100

	var/obj/item/organ/held_organ

	var/obj/item/node_holder/inserted_node

	var/currently_running = FALSE

	var/work_timer = null

/obj/machinery/organ_augmenter/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/node_holder))
		if(!user.transferItemToLoc(I, src))
			return
		eject_node_holder()
		inserted_node = I
		to_chat(user, "<span class='notice'>You add [I] to the machine.</span>")
		interact(user)
	else if(istype(I, /obj/item/organ))
		if(!user.transferItemToLoc(I, src))
			return
		eject_organ()
		held_organ = I
		to_chat(user, "<span class='notice'>You add [I] to the machine.</span>")
		if(!held_organ.GetComponent(/datum/component/abberant_organ))
			held_organ.AddComponent(/datum/component/abberant_organ)

/obj/machinery/organ_augmenter/proc/eject_node_holder()
	if (inserted_node)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(inserted_node))
				inserted_node.forceMove(drop_location())
		else
			inserted_node.forceMove(drop_location())
		inserted_node = null
		ui_update()
		. = TRUE

/obj/machinery/organ_augmenter/proc/eject_organ()
	if (held_organ)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(held_organ))
				held_organ.forceMove(drop_location())
		else
			held_organ.forceMove(drop_location())
		held_organ = null
		ui_update()
		. = TRUE

/obj/machinery/organ_augmenter/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrganAugmenter", name)
		ui.open()

/obj/machinery/organ_augmenter/ui_data(mob/user)
	var/list/data = list()
	var/stability_multi = 1
	if(held_organ)
		var/datum/component/abberant_organ/organs_component = held_organ.GetComponent(/datum/component/abberant_organ)
		data["stability_max"] = organs_component.stability
		data["stability_used"] = 100 - organs_component.stability
		data["organ_name"] = held_organ.name
		stability_multi *= organs_component.stability_modifer
		var/list/mega_list = list()
		mega_list += organs_component.inputs
		mega_list += organs_component.outputs
		mega_list += organs_component.special_nodes
		mega_list += organs_component.partnerless_inputs
		mega_list += organs_component.partnerless_outputs
		var/list/current_nodes = list()
		for(var/datum/abberant_organs/listed_node as anything  in mega_list)
			current_nodes += list(listed_node.get_node_data())
		data["current"] = current_nodes

	if(inserted_node)
		var/datum/abberant_organs/held_node_datum = inserted_node.held_node
		data["node_name"] = held_node_datum.name
		data["node_desc"] = held_node_datum.desc
		data["node_icon"] = held_node_datum.ui_icon
		data["stability_usage"] = held_node_datum.stability_cost * stability_multi
		data["held_organ_node"] = inserted_node

	data["working"] = currently_running

	data["timeleft"] = work_timer ? timeleft(work_timer) : null

	return data

/obj/machinery/organ_augmenter/ui_act(action, params)
	. = ..()


