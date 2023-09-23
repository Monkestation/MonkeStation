/mob/living/simple_animal/hostile/alien_mimic/tier2/insightful
	name = "insightful mimic"
	real_name = "insightful mimic"
	// icon_state = "oracle"
	// icon_living = "oracle"
	hivemind_modifier = "insightful"
	melee_damage = 5
	playstyle_string = "<span class='big bold'>You are a insightful mimic,</span></b> you can ghost more often and you also deal more damage and can see through walls.<b>"
	sight = SEE_THRU
	possible_evolutions = list(
		"oracle - ghost around to gain information" = /mob/living/simple_animal/hostile/alien_mimic/tier3/oracle
	)

