/datum/abberant_organs/input/reagent/alcohol/special
	name = "Alcohol Processor"
	desc = "Will trigger from any drunk alcohol"
	is_special = TRUE
	node_purity = 100 // No delay
	tier = 4
	reagent_amount = 0


/datum/abberant_organs/input/reagent/check_trigger_reagent(datum/reagent/consumed_reagent, consumed_amount, method)
	if(istype(consumed_reagent, /datum/reagent/consumable/ethanol))
		trigger_output(TRUE, consumed_amount)
	else if(istype(consumed_reagent, /datum/reagent/consumable))
		hosted_carbon.reagents.remove_reagent(consumed_reagent.type, consumed_amount) // you don't get to enjoy non alcoholic drinks anymore
		trigger_output(FALSE)
