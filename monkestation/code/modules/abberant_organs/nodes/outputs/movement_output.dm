/datum/abberant_organs/output/movement
	name = "Locomotive Processor"
	desc = "When triggered affects the users locomotion"

	var/speed_mod_good = -0.5
	var/speed_mod_bad = 1.5
	var/duration = 10 SECONDS

/datum/abberant_organs/output/movement/trigger_effect(is_good, multiplier)
	. = ..()
	hosted_carbon.add_movespeed_modifier("organ_speed", TRUE, 100, override = TRUE, multiplicative_slowdown = is_good ? speed_mod_good : speed_mod_bad)
	addtimer(CALLBACK(src, .proc/remove_speed), duration * multiplier)

/datum/abberant_organs/output/movement/proc/remove_speed()
	hosted_carbon.remove_movespeed_modifier("organ_speed")
