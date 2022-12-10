/datum/abberant_organs/input
	name = "Generic Input"
	desc = "This is a generic input you shouldn't be seeing this"

	///the output we have latched onto, this is only ever done when its added to an organ
	var/datum/abberant_organs/output/attached_output

	var/input_type = INPUT_TYPE_GENERIC
	COOLDOWN_DECLARE(trigger_cooldown)

/datum/abberant_organs/input/proc/check_trigger_reagent(datum/reagent/consumed_reagent, consumed_amount, method)
	return

/datum/abberant_organs/input/proc/check_trigger_damage(type, amount)
	return

/datum/abberant_organs/input/proc/trigger_output(is_good = TRUE, multiplier = 1)
	if(node_purity < 100)
		if(COOLDOWN_FINISHED(src, trigger_cooldown))
			attached_output.trigger_effect(is_good, multiplier)
			var/cooldown_value = round(10 - (node_purity * 0.1), 0.1) SECONDS
			COOLDOWN_START(src, trigger_cooldown, cooldown_value)
	else
		attached_output.trigger_effect(is_good, multiplier)

