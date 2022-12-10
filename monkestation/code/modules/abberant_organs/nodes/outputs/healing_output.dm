/datum/abberant_organs/output/healing
	name = "Healer"
	desc = "When activated heals the corresponding damage type"

	var/healing_type = BRUTE
	var/amount_healed = 5

/datum/abberant_organs/output/healing/trigger_effect(is_good = TRUE, multiplier)
	. = ..()
	if(istype(attached_input, /datum/abberant_organs/input/damage))
		var/datum/abberant_organs/input/damage/actual_type = attached_input
		if(actual_type.type == type)
			to_chat(hosted_carbon, span_warning("The feedback loop generated from your [attached_organ.name] is causing severe damage extraction is recommended!"))
			attached_organ.applyOrganDamage(30) // ouchies
			return

	if(is_good)
		hosted_carbon.apply_damage(-amount_healed * multiplier, healing_type, forced = TRUE)
	else
		hosted_carbon.apply_damage(amount_healed * multiplier, healing_type, forced = TRUE)
