/datum/abberant_organs/output/vortex
	name = "Vortex"
	desc = "Distorts space around you causing a vortex to occur on users position sucking everything into it after a delay, including the user"
	is_special = TRUE


/datum/abberant_organs/output/vortex/trigger_effect(is_good, multiplier)
	. = ..()
	var/turf/carbon_turf = get_turf(hosted_carbon)
	goonchem_vortex(carbon_turf, is_good? 0 : 1, 4 * multiplier)
