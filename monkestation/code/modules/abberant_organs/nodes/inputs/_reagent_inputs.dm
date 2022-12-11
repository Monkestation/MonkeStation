/datum/abberant_organs/input/reagent
	name = "Reagent Trigger"
	desc = "Simple reagent input trigger"
	input_type = INPUT_TYPE_REAGENT

	var/datum/reagent/input_requirements_good
	var/datum/reagent/input_requirements_bad
	var/reagent_amount = 1
	var/trigger_method = INGEST

/datum/abberant_organs/input/reagent/set_values(node_purity, tier)
	. = ..()
	var/list/reagent_types = list(/datum/reagent/medicine,
								  /datum/reagent/drug,
								  /datum/reagent/toxin,
								  /datum/reagent/consumable,
								  /datum/reagent/consumable/ethanol)
	var/datum/reagent/reagent_type = pick(reagent_types)
	var/finished_picking = FALSE

	trigger_method = pick(INGEST, INJECT)

	if(tier >= 4)
		reagent_amount = 0
	else
		reagent_amount =  round(100 / ((node_purity * 0.1) * 2))

	var/list/pickers
	if(reagent_type == /datum/reagent/consumable)
		pickers = typesof(reagent_type) - typesof(/datum/reagent/consumable/ethanol)
	else
		pickers = typesof(reagent_type)

	while(!finished_picking) ///this whole while feels bad but i can't think of a better way to do it currently
		var/datum/reagent/picked_reagent = pick(pickers)
		if(!input_requirements_good)
			input_requirements_good = picked_reagent
		else if(!input_requirements_bad && !(picked_reagent == input_requirements_good))
			input_requirements_bad = picked_reagent
			finished_picking = TRUE

/datum/abberant_organs/input/reagent/check_trigger_reagent(datum/reagent/consumed_reagent, consumed_amount, method)
	if(!method == trigger_method)
		return

	if(consumed_reagent == input_requirements_good)
		if(reagent_amount)
			if(consumed_amount >= reagent_amount)
				var/multi = round(consumed_amount / reagent_amount, 0.1)
				trigger_output(TRUE, multi)
		else
			trigger_output(TRUE)

	if(consumed_reagent == input_requirements_bad)
		if(reagent_amount)
			if(consumed_amount >= reagent_amount)
				var/multi = round(consumed_amount / reagent_amount, 0.1)
				trigger_output(FALSE, multi)
		else
			trigger_output(FALSE)
