/datum/antagonist/mimic
	name = "mimic"
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	show_in_antagpanel = FALSE
	//The file id for the antag tip window that will pop up
	tips = "mimic"

/datum/antagonist/mimic/greet()
	owner.current.playsound_local(get_turf(owner.current), 'monkestation/sound/ambience/antag/mimic.ogg',100,0, use_reverb = FALSE)
	var/mob/living/simple_animal/hostile/alien_mimic/spawned_mimic = owner.current
	to_chat(spawned_mimic, spawned_mimic.playstyle_string)
