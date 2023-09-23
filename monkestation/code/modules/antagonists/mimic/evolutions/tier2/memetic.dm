/mob/living/simple_animal/hostile/alien_mimic/tier2/memetic
	name = "memetic mimic"
	real_name = "memetic mimic"
	// icon_state = "memetic"
	// icon_living = "memetic"
	melee_damage = 5
	secondary_damage_type = BRUTE
	hivemind_modifier = "memetic"
	playstyle_string = "<span class='big bold'>You are a memetic mimic,</span></b> you deal brute damage, and can control people you latch onto.</b>"
	possible_evolutions = list(
		"necromantic - raise dead as minions" = /mob/living/simple_animal/hostile/alien_mimic/tier3/necromantic
	)
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/control
	)
	var/mob/living/mimic_mezmerized/mind_holder


/mob/living/simple_animal/hostile/alien_mimic/tier2/memetic/Initialize(mapload)
	. = ..()

	mind_holder = new(src)

/obj/effect/proc_holder/spell/self/mimic/control
	name = "Mezmerize"
	desc = "Take control of a person you're latched onto temporarily."
	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_icon_state = "warp"
	charge_max = 3 MINUTES

/obj/effect/proc_holder/spell/self/mimic/control/cast(mob/user)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/hostile/alien_mimic/tier2/memetic/mimic_user = user

	if(isliving(user.buckled))
		var/mob/living/control_target = user.buckled

		if(!control_target.key)
			to_chat(user,"<span class='notice'>There's no mind to control!</span>")

		to_chat(control_target,"<span class='userdanger'>[user] takes control!</span>")
		control_target.visible_message("<span class='warning'>[user] melts into [control_target]'s body.</span>","<span class'notice'>You melt into [control_target] and gain control of their body.</span>")

		control_target.mind.transfer_to(mimic_user.mind_holder)
		user.mind.transfer_to(control_target)
		user.forceMove(control_target)
		mimic_user.toggle_ai(AI_OFF) //Prevent the mimic from attacking the target from inside it's body

		control_target.SetAllImmobility(0) //Don't waste time being stunned
		control_target.set_resting(FALSE)

		addtimer(CALLBACK(src, .proc/undo_control, user, control_target, mimic_user.mind_holder), 30 SECONDS)
	else
		revert_cast(user)

/obj/effect/proc_holder/spell/self/mimic/control/proc/undo_control(mob/living/mimic_body, mob/living/controlled_body, mob/living/mind_holder)
	controlled_body.visible_message("<span class='warning'>[mimic_body] melts out of [controlled_body]'s body.</span>","<span class'notice'>You come out of [controlled_body]'s body.</span>")

	controlled_body.mind.transfer_to(mimic_body)
	mind_holder.mind.transfer_to(controlled_body)

	mimic_body.forceMove(get_turf(controlled_body))
	controlled_body.Stun(5 SECONDS)

//Back Seat for the mezmerize ability
/mob/living/mimic_mezmerized
	name = "mezmerized conscience"
	real_name = "mezmerized conscience"

/mob/living/mimic_mezmerized/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	to_chat(src, "<span class='warning'>You are not in control of your body!</span>")
	return FALSE

/mob/living/mimic_mezmerized/emote(act, m_type = null, message = null, intentional = FALSE)
	return FALSE
