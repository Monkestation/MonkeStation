/datum/abberant_organs/input/emp
	name = "Electromagnetic Input"
	desc = "Triggers when it detects electromagnetic pulses."
	is_special = TRUE
	node_purity = 100

	var/trigger_amount = 2


/datum/abberant_organs/input/emp/setup()
	. = ..()
	RegisterSignal(hosted_carbon, COMSIG_CARBON_EMP, .proc/handle_emp)


/datum/abberant_organs/input/emp/proc/handle_emp(atom/source, severity)
	for(var/i = 0 to (trigger_amount * severity))
		trigger_output(TRUE, severity)
