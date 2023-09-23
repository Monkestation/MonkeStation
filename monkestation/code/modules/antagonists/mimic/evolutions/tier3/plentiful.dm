/mob/living/simple_animal/hostile/alien_mimic/tier3/plentiful
	name = "plentiful mimic"
	real_name = "plentiful mimic"
	// icon_state = "plentiful"
	// icon_living = "plentiful"
	melee_damage = 9
	secondary_damage_type = TOX
	hivemind_modifier = "plentiful"
	playstyle_string = "<span class='big bold'>You are an plentiful mimic,</span></b> you can summon 2 mimics.</b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/clone_request,
		/obj/effect/proc_holder/spell/self/mimic/clone_request
	)
