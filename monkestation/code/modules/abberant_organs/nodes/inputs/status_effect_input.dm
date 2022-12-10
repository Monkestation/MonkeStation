/datum/abberant_organs/input/status_effect
	name = "State Detection Input"
	desc = "Triggers when a specific body state is triggered, for instance Paralyzed."

	var/checked_effect = EFFECT_PARALYZE
	var/min_duration = 1 SECONDS


/datum/abberant_organs/input/status_effect/setup()
	. = ..()
	switch(checked_effect)
		if(EFFECT_PARALYZE)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_PARALYZE, .proc/effect_triggered)
		if(EFFECT_IMMOBILIZE)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_IMMOBILIZE, .proc/effect_triggered)
		if(EFFECT_KNOCKDOWN)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_KNOCKDOWN, .proc/effect_triggered)
		if(EFFECT_STUN)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_STUN, .proc/effect_triggered)
		if(EFFECT_UNCONSCIOUS)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_UNCONSCIOUS, .proc/effect_triggered)
		if(EFFECT_SLEEP)
			RegisterSignal(hosted_carbon, COMSIG_LIVING_STATUS_SLEEP, .proc/effect_triggered)

/datum/abberant_organs/input/status_effect/proc/effect_triggered(datum/source, amount, updating, ignore_canstun)
	if(amount < min_duration)
		trigger_output(FALSE)
		return
	var/multiplier = amount / min_duration
	trigger_output(TRUE, multiplier)
