/obj/effect/proc_holder/spell/targeted/lesser_glare //a defensive ability, nothing else. can't be used to stun people, steal tasers, etc. Just good for escaping
	name = "Lesser Glare"
	desc = "Makes a single target dizzy for a bit."
	panel = "Thrall Abilities"
	charge_max = 450
	human_req = TRUE
	clothes_req = FALSE
	action_icon = 'yogstation/icons/mob/actions.dmi'
	action_icon_state = "glare"

/obj/effect/proc_holder/spell/targeted/lesser_glare/cast(list/targets,mob/user = usr)
	for(var/mob/living/target in targets)
		if(!user.getorganslot(ORGAN_SLOT_EYES))
			to_chat(user, span_warning("You need eyes to glare!"))
			revert_cast()
			return
		if(!ishuman(target) || !target)
			to_chat(user, span_warning("You may only glare at humans!"))
			revert_cast()
			return
		if(target.stat)
			to_chat(user, span_warning("[target] must be conscious!"))
			revert_cast()
			return
		if(is_shadow_or_thrall(target))
			to_chat(user, span_warning("You cannot glare at allies!"))
			revert_cast()
			return
		var/mob/living/carbon/human/M = target
		user.visible_message(span_warning("<b>[user]'s eyes flash a bright red!</b>"))
		target.visible_message(span_danger("[target] suddendly looks dizzy and nauseous..."))
		if(in_range(target, user))
			to_chat(target, span_userdanger("Your gaze is forcibly drawn into [user]'s eyes, and you suddendly feel dizzy and nauseous..."))
		else //Only alludes to the thrall if the target is close by
			to_chat(target, span_userdanger("Red lights suddenly dance in your vision, and you suddendly feel dizzy and nauseous..."))
		M.confused += 25
		M.Jitter(50)
		if(prob(25))
			M.vomit(10)
