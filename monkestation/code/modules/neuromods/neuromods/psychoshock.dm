/obj/item/autosurgeon/neuromod/psychoshock
	name = "psychoshock neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/psychoshock)

/obj/item/organ/cyberimp/neuromod/targeted/psychoshock
	name = "Psychoshock"
	desc = "This neuromod allows you to confuse targets."
	icon_state = "psychoshock"
	cast_message = "<span class='notice'>You ready yourself to shake up somebody's mind. Click on a target.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	max_distance = 9
	cooldown = 1 MINUTES
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/psychoshock/activate(target)
	if(!isliving(target))
		return
	..()
	var/mob/living/living_target = target
	to_chat(living_target,"<span class='danger'>You make eye contact with [owner] and your head starts spinning.</span>")
	to_chat(owner,"<span class='notice'>You twist and turn [living_target.p_their()] mind.</span>")
	living_target.Stun(10 SECONDS)
	living_target.Knockdown(3 SECONDS)
	living_target.jitteriness += 15
	living_target.confused += 10
	living_target.drop_all_held_items()
