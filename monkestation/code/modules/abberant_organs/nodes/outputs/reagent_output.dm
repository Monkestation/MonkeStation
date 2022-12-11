/datum/abberant_organs/output/reagent
	name = "Chemical Factory"
	desc = "Generates chemicals when triggered"

	var/datum/reagent/good_reagent
	var/datum/reagent/bad_reagent

	var/generated_amount = 5

/datum/abberant_organs/output/reagent/set_values(node_purity, tier)
	. = ..()
	generated_amount *= (node_purity * 0.02) * (tier * 0.5)

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

/datum/abberant_organs/output/reagent/trigger_effect(is_good, multiplier)
	. = ..()
	if(istype(attached_input, /datum/abberant_organs/input/reagent))
		var/datum/abberant_organs/input/reagent/actual_type = attached_input
		var/list/combined_list = list()
		combined_list += actual_type.input_requirements_bad
		combined_list += actual_type.input_requirements_good

		if((good_reagent in combined_list) || (bad_reagent in combined_list))
			to_chat(hosted_carbon, span_warning("Your [attached_organ.name] is overloaded by the chemicals! You start to spew out chemicals causing lots of pain!"))
			var/turf/open/epicenter = get_turf(hosted_carbon)
			epicenter.add_liquid(bad_reagent, 50)
			attached_organ.applyOrganDamage(30)
			hosted_carbon.apply_damage(15, BRUTE)
			return

	if(is_good)
		hosted_carbon.reagents.add_reagent(good_reagent, generated_amount * multiplier)
	else
		hosted_carbon.reagents.add_reagent(bad_reagent, generated_amount * multiplier)
