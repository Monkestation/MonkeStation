/datum/abberant_organs/input/damage
	name = "Damage Triggered Input"
	desc = "Input that is triggered when the organs owner is hurt"

	input_type = INPUT_TYPE_DAMAGE

	var/minimum_damage = 5

	var/max_safe_damage = 15

	var/damage_type = BRUTE

/datum/abberant_organs/input/damage/check_trigger_damage(type, amount)
	if(!damage_type == type && minimum_damage > amount)
		return
	if(amount > max_safe_damage)
		trigger_output(FALSE)
		return
	trigger_output(TRUE)
