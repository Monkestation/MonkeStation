/obj/item/autosurgeon/neuromod/superthermal
	name = "superthermal neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/superthermal)

/obj/item/organ/cyberimp/neuromod/targeted/superthermal
	name = "Superthermal"
	desc = "This neuromod allows you to light targets on fire."
	// icon_state = "superthermal"
	cast_message = "<span class='notice'>You feel a heat behind your eyes. Click on a target.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	max_distance = 9
	cooldown = 30 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/superthermal/activate(target)
	if(!isliving(target))
		return
	..()
	var/mob/living/living_target = target
	to_chat(living_target,"<span class='danger'>[owner] looks at you, and you start burning.</span>")
	to_chat(owner,"<span class='notice'>Your eyes heat up as you look at [living_target].</span>")

	living_target.adjust_fire_stacks(20)
	living_target.adjustFireLoss(20)
	living_target.IgniteMob()

