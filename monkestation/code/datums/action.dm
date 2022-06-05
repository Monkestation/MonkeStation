/datum/action/item_action/toggle_mask
	name = "Toggle Mask"

/datum/action/item_action/toggle_circuit_goggles
	name = "Toggle Circuit Goggles"
	icon_icon = 'monkestation/icons/mob/actions/actions_items.dmi'
	//icon_icon = 'monkestation/icons/obj/wiremod.dmi'
	button_icon_state = "goggle_toggle"
	var/active = FALSE

/datum/action/item_action/toggle_circuit_goggles/Trigger()
	if(IsAvailable())
		active = !active
		if(active)
			owner.circuit_goggles++
		else
			owner.circuit_goggles--
		to_chat(owner, "<span class='notice'>[target] cricuit goggles have been [active ? "activated" : "deactivated"].</span>")
		return 1

/datum/action/item_action/toggle_circuit_goggles/Remove(mob/M)
	if(owner && active)
		owner.circuit_goggles--
		active = FALSE
	..()
