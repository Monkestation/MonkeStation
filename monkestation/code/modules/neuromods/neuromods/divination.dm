/obj/item/autosurgeon/neuromod/divination
	name = "divination neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/divination)

/obj/item/organ/cyberimp/neuromod/divination
	name = "Divination"
	desc = "This neuromod allows you to transform see beyond the limits of your eyes."
	cooldown = 90 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/divination/ui_action_click()
	. = ..()
	if(.)
		return

	var/mob/dead/observer/ghost = owner.ghostize(1)
	ghost.color = "purple"
	while(!QDELETED(owner))
		if(owner.key)
			break
		sleep(5)
	owner.grab_ghost()
