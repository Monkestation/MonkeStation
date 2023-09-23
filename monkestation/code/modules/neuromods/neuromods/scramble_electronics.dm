/obj/item/autosurgeon/neuromod/scramble_electronics
	name = "scramble electronics neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/scramble_electronics)

/obj/item/organ/cyberimp/neuromod/targeted/scramble_electronics
	name = "Scramble Electronics"
	desc = "This neuromod allows you to mess with nearby electronics."
	icon_state = "emp"
	icon = 'icons/mob/actions/actions_spells.dmi'
	cast_message = "<span class='notice'>You feel electricity spark behind your eyes. Click on a target area.</span>"
	cancel_message = "<span class='notice'>The electricity calms.</span>"
	max_distance = 3
	cooldown = 30 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/scramble_electronics/activate(target)
	..()
	var/atom/movable/movable_target = target
	to_chat(owner,"<span class='notice'>You focus on \the [movable_target], messing with [movable_target.p_their()] electronics.</span")
	movable_target.emp_act(EMP_HEAVY)
