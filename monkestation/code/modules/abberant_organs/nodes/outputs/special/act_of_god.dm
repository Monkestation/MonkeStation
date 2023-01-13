/datum/abberant_organs/output/act_of_god
	name = "Voice of God"
	desc = "Triggering this summons the voice of god, results are unpredictible"
	is_special = TRUE

	var/list/random_choice = list("stop", "drop", "sleep", "vomit", "shut up", "see the truth", "awaken", "mend", "suffer", "there will be blood", "ignite", "freeze", "hell", "begone", "come here", "who are you?", "say my name", "rotate", "right round", "clap", "sit")


/datum/abberant_organs/output/act_of_god/trigger_effect(is_good, multiplier)
	. = ..()
	var/list/spans = list("colossus","yell")
	playsound(get_turf(hosted_carbon), 'sound/magic/clockwork/invoke_general.ogg', 300, 1, 5)
	voice_of_god(pick(random_choice), hosted_carbon, spans, base_multiplier = 2 * multiplier, include_speaker = is_good ? FALSE : TRUE)
