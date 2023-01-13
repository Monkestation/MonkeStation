/datum/abberant_organs/input/damage
	name = "Damage Triggered Input"
	desc = "Input that is triggered when the organs owner is hurt"

	input_type = INPUT_TYPE_DAMAGE

	var/minimum_damage = 5

	var/max_safe_damage = 15

	var/damage_type = BRUTE

/datum/abberant_organs/input/damage/set_values(node_purity, tier)
	. = ..()
	damage_type = pick(BRUTE, OXY, TOX, BURN, CLONE)
	minimum_damage *= (200 / node_purity) * 0.1
	max_safe_damage *= (node_purity * 0.01) * 2 * (tier * 0.5)


/datum/abberant_organs/input/damage/check_trigger_damage(type, amount)
	if(!damage_type == type && minimum_damage > amount)
		return
	if(amount > max_safe_damage)
		trigger_output(FALSE)
		return
	trigger_output(TRUE)
