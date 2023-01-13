/datum/abberant_organs/output
	name = "Generic Output"
	desc = "This is a generic output you shouldn't be seeing this"
	slot = OUTPUT_NODE

	///the input we have latched onto, this is only ever done when its added to an organ
	var/datum/abberant_organs/input/attached_input

/datum/abberant_organs/output/check_active()
	if(attached_input)
		return TRUE
	return FALSE

/datum/abberant_organs/output/proc/trigger_effect(is_good = TRUE, multiplier)
	SHOULD_CALL_PARENT(TRUE)

	if(attached_special)
		if(attached_special.trigger_special(is_good, multiplier))
			return

