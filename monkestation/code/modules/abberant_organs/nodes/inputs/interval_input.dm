/datum/abberant_organs/input/interval
	name = "Interval Processing Input"
	desc = "Has no requirements it just triggers on an interval!"

	var/interval_time = 10 SECONDS
	COOLDOWN_DECLARE(should_process)

/datum/abberant_organs/input/interval/set_values(node_purity, tier)
	. = ..()
	interval_time *= (100 / node_purity) * (2 / tier)

/datum/abberant_organs/input/interval/setup()
	START_PROCESSING(SSabberant_organ, src)

/datum/abberant_organs/input/interval/Destroy(force, ...)
	. = ..()
	STOP_PROCESSING(SSabberant_organ, src)

/datum/abberant_organs/input/interval/setup()
	interval_time = 10  * ((100 / node_purity) / tier) SECONDS

/datum/abberant_organs/input/interval/process()
	. = ..()
	if(!COOLDOWN_FINISHED(src, should_process) || !attached_output)
		return
	COOLDOWN_START(src, should_process, interval_time)
	if(prob(min(min(round((0.25 * node_purity) * tier,1),100),50)))
		attached_output.trigger_effect(TRUE)
	else
		attached_output.trigger_effect(FALSE)
