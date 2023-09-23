/obj/item/autosurgeon/neuromod/smuggle
	name = "smuggle neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/smuggle)

/obj/item/organ/cyberimp/neuromod/smuggle
	name = "Smuggle"
	desc = "This neuromod lets you store an item inside your body."
	icon_state = "smuggle"
	cooldown = 3 SECONDS
	var/obj/item/stored_item
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/smuggle/Insert(mob/living/carbon/user, special, drop_if_replaced)
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/owner_death)

/obj/item/organ/cyberimp/neuromod/smuggle/Remove(mob/living/carbon/user, special)
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_DEATH)

/obj/item/organ/cyberimp/neuromod/smuggle/ui_action_click()
	. = ..()
	if(.)
		return
	if(stored_item)
		icon_state = initial(icon_state)
		icon = initial(icon)
		owner.put_in_hands(stored_item)
		owner.visible_message("<span class='notice'>\The [stored_item] falls out of [owner]'s skin and into \his hand.</span>","<span class='notice'>\The [stored_item] phases out of your skin and into your hand.</span>")
		stored_item = null
	else
		var/list/hand_items = list(owner.get_active_held_item(),owner.get_inactive_held_item())
		for(var/obj/item/item in hand_items) //Put the item away
			if(item.item_flags & ABSTRACT)
				continue
			stored_item = item
			owner.visible_message("<span class='notice'>\The [item] disappears into [owner]'s into \his hand.</span>","<span class='notice'>The [item] sinks into your skin.</span>")
			icon_state = item.icon_state
			icon = item.icon
			item.forceMove(owner)
			break
	owner.update_action_buttons()

/obj/item/organ/cyberimp/neuromod/smuggle/proc/owner_death()
	icon_state = initial(icon_state)
	icon = initial(icon)
	stored_item.forceMove(get_turf(owner))
	owner.visible_message("<span class='notice'>\The [stored_item] falls out of [owner]'s corpse</span>")
	stored_item = null
