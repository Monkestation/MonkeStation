// TODO: Effects on presence

/mob/living/simple_animal/hostile/alien_mimic/tier3/present
	name = "present mimic"
	real_name = "present mimic"
	// icon_state = "kinetic"
	// icon_living = "kinetic"
	hivemind_modifier = "present"
	melee_damage = 8
	secondary_damage_type = BRUTE
	playstyle_string = "<span class='big bold'>You are a present mimic,</span></b> you can force nearby people down and pull them towards you.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/presence,
		/obj/effect/proc_holder/spell/self/mimic/kinetic_blast,
	)

//Abilities
/obj/effect/proc_holder/spell/self/mimic/presence
	name = "Presence"
	desc = "Force nearby beings down."
	charge_max = 60 SECONDS

/obj/effect/proc_holder/spell/self/mimic/presence/cast(mob/user = usr)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/hostile/alien_mimic/mimic_user = user

	for(var/mob/living/carbon/victim in oview(7))
		victim.Knockdown(5 SECONDS)
		victim.Stun(5 SECONDS)
		to_chat("<span class='userdanger'>A wave of pressure flowing from [mimic_user] forces you down.</span>")
