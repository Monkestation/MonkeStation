/obj/item/autosurgeon/neuromod/rat_form
	name = "rat form neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/rat_form)

/obj/item/organ/cyberimp/neuromod/rat_form
	name = "Rat Form"
	desc = "This neuromod allows you to turn into a mouse. If you die as a mouse, the ability goes on cooldown for 60 seconds and you lose a limb."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_gray"
	cooldown = 5 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/mob/living/simple_animal/mouse/created_rat

	var/ratform_cooldown = 60 SECONDS
	COOLDOWN_DECLARE(neuromod_ratform)

/obj/item/organ/cyberimp/neuromod/rat_form/ui_action_click()
	if(!COOLDOWN_FINISHED(src, neuromod_ratform))
		to_chat(owner, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, neuromod_ratform)*0.1] seconds to trasnform again!</span>")
		return

	. = ..()
	if(.)
		return

	created_rat = new(get_turf(owner))
	var/obj/effect/proc_holder/spell/self/rat_form_detransform/detransform = new
	detransform.neuromod = src
	created_rat.AddSpell(detransform)

	RegisterSignal(created_rat, COMSIG_MOB_DEATH, .proc/rat_death)
	owner.visible_message("<span class='notice'>[owner]'s body melts into the shape of a mouse!</span>", "<span class='userdanger'>Your body shapes into a mouse.</span>")
	owner.forceMove(created_rat)
	owner.mind.transfer_to(created_rat)
	ADD_TRAIT(owner, TRAIT_NOBREATH, "neuromod_mouseform")
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "neuromod_mouseform")

/obj/item/organ/cyberimp/neuromod/rat_form/proc/rat_death()
		COOLDOWN_START(src, neuromod_ratform, ratform_cooldown)

		UnregisterSignal(created_rat, COMSIG_MOB_DEATH)
		created_rat.visible_message("<span class='notice'>[created_rat]'s corpse grows into a person!</span>", "<span class='userdanger'>The pain of death fades as you grow into a person.</span>")
		var/mob/living/carbon/human/human_mob = locate() in created_rat
		created_rat.mind.transfer_to(human_mob)
		human_mob.grab_ghost()
		human_mob.forceMove(get_turf(created_rat))
		REMOVE_TRAIT(human_mob, TRAIT_NOBREATH, "neuromod_mouseform")
		REMOVE_TRAIT(human_mob, TRAIT_RESISTLOWPRESSURE, "neuromod_mouseform")
		created_rat = null

		var/picked_bodypart = pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		var/obj/item/bodypart/bodypart = owner.get_bodypart(picked_bodypart)
		bodypart.dismember()

/obj/effect/proc_holder/spell/self/rat_form_detransform
	name = "Detransform"
	desc = "Revert back into your normal form."
	clothes_req = FALSE
	action_icon = 'icons/mob/animal.dmi'
	action_icon_state = "mouse_gray"
	charge_max = 5 SECONDS
	var/obj/item/organ/cyberimp/neuromod/rat_form/neuromod

/obj/effect/proc_holder/spell/self/rat_form_detransform/cast(mob/user = usr)
	if(!neuromod)
		return

	UnregisterSignal(user, COMSIG_MOB_DEATH)
	user.visible_message("<span class='notice'>[neuromod.created_rat]'s body grows into a person!</span>", "<span class='userdanger'>Your body reforms back into your normal shape.</span>")
	var/mob/living/carbon/human/human_mob = locate() in user
	user.mind.transfer_to(human_mob)
	human_mob.grab_ghost()
	human_mob.forceMove(get_turf(neuromod.created_rat))
	REMOVE_TRAIT(human_mob, TRAIT_NOBREATH, "neuromod_mouseform")
	REMOVE_TRAIT(human_mob, TRAIT_RESISTLOWPRESSURE, "neuromod_mouseform")
	neuromod.created_rat = null
	qdel(user)
