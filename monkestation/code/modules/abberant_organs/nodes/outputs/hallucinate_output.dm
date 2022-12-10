/datum/abberant_organs/output/hallucinate
	name = "Hallucination"
	desc = "Makes everyone around the user hallucinate temporarily."

	var/range = 5

/datum/abberant_organs/output/hallucinate/trigger_effect(is_good, multiplier)
	. = ..()
	for(var/mob/living/carbon/listening_carbon in range(range * multiplier))
		new /datum/hallucination/delusion(listening_carbon, TRUE, null, 150,0)
