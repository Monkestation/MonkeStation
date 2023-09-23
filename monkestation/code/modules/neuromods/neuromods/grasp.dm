/obj/item/autosurgeon/neuromod/grasp
	name = "grasp neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/grasp)

/obj/item/organ/cyberimp/neuromod/targeted/grasp
	name = "Grasp"
	desc = "This neuromod allows you to grab anything from afar."
	// icon_state = "grasp"
	cast_message = "<span class='notice'>You ready your hand to grab something. Click on a target.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	max_distance = 9
	cooldown = 30 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/grasp/activate(target)
	if(!isitem(target) && !isliving(target))
		to_chat(owner, "<span class='warning'> you can't grab that!</span>")
		return

	..()

	if(isitem(target))
		var/obj/item/item_target = target
		owner.put_in_hands(item_target)

	else if(isliving(target))
		var/mob/living/living_target = target
		do_teleport(living_target, get_step(owner,living_target))
		living_target.grabbedby(owner)

