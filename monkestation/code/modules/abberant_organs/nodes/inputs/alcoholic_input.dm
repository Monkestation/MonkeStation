/datum/abberant_organs/input/reagent/alcohol/special
	name = "Alcohol Distillery"
	desc = "Will trigger from any drunk alcohol"
	is_special = TRUE
	node_purity = 90 // 1 Second Delay between gulps
	tier = 4
	reagent_amount = 0


/datum/abberant_organs/input/reagent/check_trigger_reagent(datum/reagent/consumed_reagent, consumed_amount, method)
	if(istype(consumed_reagent, /datum/reagent/consumable/ethanol))
		trigger_output(TRUE, consumed_amount)
	else if(istype(consumed_reagent, /datum/reagent/consumable))
		trigger_output(FALSE)
