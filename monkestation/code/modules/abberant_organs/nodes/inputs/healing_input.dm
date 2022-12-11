/datum/abberant_organs/input/damage/heal
	name = "Heal Triggered Input"
	desc = "Input that is triggered when the organs owner is healed"

	input_type = INPUT_TYPE_DAMAGE

	minimum_damage = -5

	max_safe_damage = -15

	damage_type = BRUTE

/datum/abberant_organs/input/damage/heal/check_trigger_damage(type, amount)
	if(!damage_type == type && minimum_damage < amount)
		return
	if(amount < max_safe_damage)
		trigger_output(FALSE)
		return
	trigger_output(TRUE)
