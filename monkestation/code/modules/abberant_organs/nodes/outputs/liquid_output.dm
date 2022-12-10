/datum/abberant_organs/output/liquid
	name = "Pond Maker"
	desc = "Generates pools of liquids around you when triggered."

	var/generated_amount = 20
	var/datum/reagent/good_reagent = /datum/reagent/water
	var/datum/reagent/bad_reagent = /datum/reagent/water

/datum/abberant_organs/output/liquid/trigger_effect(is_good, multiplier)
	. = ..()
	var/turf/carbon_turf = get_turf(hosted_carbon)
	hosted_carbon.visible_message("<span class='danger'>A rush of liquid comes from [hosted_carbon]!</span>", \
							"<span class='danger'>A rush of liquid comes out of you!</span>", null, COMBAT_MESSAGE_RANGE)
	carbon_turf.add_liquid(is_good ? good_reagent : bad_reagent, generated_amount * multiplier)
