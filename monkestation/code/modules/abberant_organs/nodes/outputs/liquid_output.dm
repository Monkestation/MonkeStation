/datum/abberant_organs/output/liquid
	name = "Pond Maker"
	desc = "Generates pools of liquids around you when triggered."

	var/generated_amount = 20
	var/datum/reagent/good_reagent
	var/datum/reagent/bad_reagent

/datum/abberant_organs/output/liquid/set_values(node_purity, tier)
	. = ..()
	generated_amount *= (node_purity * 0.02) * (tier * 0.5)
	generated_amount = min(generated_amount, 50)

	var/list/reagent_types = list(/datum/reagent/medicine,
								  /datum/reagent/drug,
								  /datum/reagent/toxin,
								  /datum/reagent/consumable,
								  /datum/reagent/consumable/ethanol)
	var/datum/reagent/reagent_type = pick(reagent_types)
	var/finished_picking = FALSE

	var/list/pickers
	if(reagent_type == /datum/reagent/consumable)
		pickers = typesof(reagent_type) - typesof(/datum/reagent/consumable/ethanol)
	else
		pickers = typesof(reagent_type)

	while(!finished_picking) ///this whole while feels bad but i can't think of a better way to do it currently
		var/datum/reagent/picked_reagent = pick(pickers)
		if(!good_reagent)
			good_reagent = picked_reagent
		else if(!bad_reagent && !(picked_reagent == good_reagent))
			bad_reagent = picked_reagent
			finished_picking = TRUE

/datum/abberant_organs/output/liquid/trigger_effect(is_good, multiplier)
	. = ..()
	var/turf/carbon_turf = get_turf(hosted_carbon)
	hosted_carbon.visible_message("<span class='danger'>A rush of liquid comes from [hosted_carbon]!</span>", \
							"<span class='danger'>A rush of liquid comes out of you!</span>", null, COMBAT_MESSAGE_RANGE)
	carbon_turf.add_liquid(is_good ? good_reagent : bad_reagent, generated_amount * multiplier)
