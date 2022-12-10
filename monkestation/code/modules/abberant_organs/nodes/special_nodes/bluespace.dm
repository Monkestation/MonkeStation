/datum/abberant_organs/special/bluespace
	needs_attachment = TRUE
	attachement_type = OUTPUT_NODE

	var/static/list/global_bluespace_floaters = list()

	var/datum/abberant_organs/special/bluespace/attached_bluespace

/datum/abberant_organs/special/bluespace/setup()
	if(global_bluespace_floaters.len)
		var/datum/abberant_organs/special/bluespace/plucked_node = pick(global_bluespace_floaters)
		attached_bluespace = plucked_node
		global_bluespace_floaters -= plucked_node
		return
	global_bluespace_floaters += src

/datum/abberant_organs/special/bluespace/trigger_special(is_good = TRUE, multiplier, modifier)
	if(!attached_bluespace)
		return FALSE
	attached_output.trigger_effect(is_good, multiplier)
	return TRUE
