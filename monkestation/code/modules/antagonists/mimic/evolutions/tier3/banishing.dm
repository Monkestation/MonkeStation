/mob/living/simple_animal/hostile/alien_mimic/tier3/banishing
	name = "banishing mimic"
	real_name = "banishing mimic"
	// icon_state = "shifty"
	// icon_living = "shifty"
	hivemind_modifier = "banishing"
	melee_damage = 8
	playstyle_string = "<span class='big bold'>You are a banishing mimic,</span></b> you can send enemies to random places on the station.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/pointed/mimic/phantom_shift,
		/obj/effect/proc_holder/spell/targeted/mimic/banish,
	)

//Abilities
/obj/effect/proc_holder/spell/targeted/mimic/banish
	name = "Banish"
	desc = "Force a target to a random place on the station."
	charge_max = 1 MINUTES

/obj/effect/proc_holder/spell/targeted/mimic/banish/cast(list/targets, mob/user = usr)
	. = ..()
	if(.)
		return

	for(var/mob/living/target in targets)
		if(!(get_turf(target) in view(7, get_turf(user))))
			revert_cast(user)
			return

		do_teleport(target,find_safe_turf())
		to_chat(target,"<span class='warning'>You're vision briefly goes black as you appear somewhere else!</span>")
		target.Stun(3 SECONDS)

		return

	revert_cast(user)

