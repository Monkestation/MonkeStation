/datum/abberant_organs/output/irradiate
	name = "Irradiate"
	desc = "Causes pulses of radiation to fly out from you"
	is_special = TRUE

/datum/abberant_organs/output/irradiate/trigger_effect(is_good, multiplier)
	. = ..()
	radiation_pulse(hosted_carbon, 50 * multiplier)
