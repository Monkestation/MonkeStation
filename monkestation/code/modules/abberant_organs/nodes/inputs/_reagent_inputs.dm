/datum/abberant_organs/input/reagent
	name = "Reagent Trigger"
	desc = "Simple reagent input trigger"
	input_type = INPUT_TYPE_REAGENT

	var/list/input_requirements_good = list(/datum/reagent/consumable/ethanol/ale)
	var/list/input_requirements_bad = list(/datum/reagent/consumable/watermelonjuice)
	var/reagent_amount = 1
	var/trigger_method = INGEST

/datum/abberant_organs/input/reagent/check_trigger_reagent(datum/reagent/consumed_reagent, consumed_amount, method)
	if(!method == trigger_method)
		return

	if(consumed_reagent in input_requirements_good)
		if(reagent_amount)
			if(consumed_amount >= reagent_amount)
				var/multi = round(consumed_amount / reagent_amount, 0.1)
				trigger_output(TRUE, multi)
		else
			trigger_output(TRUE)

	if(consumed_reagent in input_requirements_bad)
		if(reagent_amount)
			if(consumed_amount >= reagent_amount)
				var/multi = round(consumed_amount / reagent_amount, 0.1)
				trigger_output(FALSE, multi)
		else
			trigger_output(FALSE)
