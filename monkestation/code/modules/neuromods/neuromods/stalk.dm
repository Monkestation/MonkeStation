/obj/item/autosurgeon/neuromod/stalk
	name = "stalk neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/stalk)

/obj/item/organ/cyberimp/neuromod/targeted/stalk
	name = "Stalk"
	desc = "This neuromod lets you hide in a person's shadows."
	icon_state = "stalk"
	cooldown = 10 SECONDS
	max_distance = 1
	cast_message = "<span class='notice'>You get ready to fall into the shadows.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	var/stalking
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/stalk/ui_action_click()
	if(!COOLDOWN_FINISHED(src, neuromod_cooldown))
		to_chat(owner, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, neuromod_cooldown)*0.1] seconds to use [src] again!</span>")
		return TRUE
	if(stalking) //Exit Stalk
		owner.visible_message("<span class='danger'>[owner] emerges from [stalking]'s shadow!</span>","<span class='notice'>You leave [stalking]'s shadow.</span>")
		REMOVE_TRAIT(owner, TRAIT_NOBREATH, "neuromod")
		REMOVE_TRAIT(owner, TRAIT_PARALYSIS_R_ARM, "neuromod")
		REMOVE_TRAIT(owner, TRAIT_PARALYSIS_L_ARM, "neuromod")
		owner.forceMove(get_turf(owner))
		UnregisterSignal(stalking, COMSIG_MOB_STATCHANGE)
		stalking = null
		return
	if(!active)
		active = TRUE
		owner.click_intercept = src
		to_chat(owner, cast_message)
	else
		active = FALSE
		owner.click_intercept = null
		to_chat(owner, cancel_message)

/obj/item/organ/cyberimp/neuromod/targeted/stalk/activate(target)
	if(target == owner)
		to_chat(owner,"<span class='notice'>You can't enter your own shadow!</span>")
		return
	if(!ismob(target))
		to_chat(owner,"<span class='notice'>You can only enter the shadow of a living being!</span>")
		return
	..()
	ADD_TRAIT(owner, TRAIT_NOBREATH, "neuromod") //Enter Stalk
	ADD_TRAIT(owner, TRAIT_PARALYSIS_R_ARM, "neuromod") //Don't let em do stuff when they're in the shadow
	ADD_TRAIT(owner, TRAIT_PARALYSIS_L_ARM, "neuromod")
	owner.visible_message("<span class='danger'>[owner] falls into [target]'s shadow!</span>","<span class='notice'>You enter [target]'s shadow.</span>")
	owner.forceMove(target)
	RegisterSignal(target, COMSIG_MOB_STATCHANGE, .proc/fall_out)
	stalking = target

/obj/item/organ/cyberimp/neuromod/targeted/stalk/proc/fall_out(atom/movable/source, var/new_stat)
	SIGNAL_HANDLER

	if(new_stat == CONSCIOUS || (new_stat == SOFT_CRIT && prob(50)))
		return
	owner.visible_message("<span class='danger'>[owner] falls out of [stalking]'s shadow!</span>","<span class='notice'>You clumsily fall out of [stalking]'s shadow.</span>")
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, "neuromod")
	REMOVE_TRAIT(owner, TRAIT_PARALYSIS_R_ARM, "neuromod")
	REMOVE_TRAIT(owner, TRAIT_PARALYSIS_L_ARM, "neuromod")
	owner.forceMove(get_turf(owner))
	UnregisterSignal(stalking, COMSIG_MOB_STATCHANGE)
	owner.Knockdown(3 SECONDS)
	stalking = null
