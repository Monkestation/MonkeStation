/mob/living/simple_animal/hostile/alien_mimic/tier3/tesla
	name = "tesla mimic"
	real_name = "tesla mimic"
	// icon_state = "voltaic"
	// icon_living = "voltaic"
	hivemind_modifier = "tesla"
	melee_damage = 7
	playstyle_string = "<span class='big bold'>You are a tesla mimic,</span></b> shock everyone nearby.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/tesla,
		/obj/effect/proc_holder/spell/self/mimic/emp
	)

//Abilities
/obj/effect/proc_holder/spell/self/mimic/tesla
	name = "Tesla"
	desc = "Zap everyone nearby"
	charge_max = 30 SECONDS

/obj/effect/proc_holder/spell/self/mimic/tesla/cast(mob/user = usr)
	. = ..()
	if(.)
		return

	tesla_zap(user, 5, 4000)



