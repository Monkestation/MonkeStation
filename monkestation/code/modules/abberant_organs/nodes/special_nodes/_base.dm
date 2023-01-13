/datum/abberant_organs/special
	name = "Special Node"
	desc = "Generic special node"
	slot = SPECIAL_NODE

	var/needs_attachment = FALSE
	var/attachement_type = INPUT_NODE

	var/datum/abberant_organs/input/attached_input
	var/datum/abberant_organs/output/attached_output

/datum/abberant_organs/special/proc/trigger_special(is_good = TRUE, multiplier, datum/component/abberant_organ/modifier)
	return
