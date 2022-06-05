/mob
	//MonkeStation Edit: Emote Hotkey Cooldowns
	var/emote_cooling_down = FALSE

	/// circuit goggle stuff based on research goggle stuff
	var/circuit_goggles = FALSE

/mob/proc/reset_emote_cooldown()
	emote_cooling_down = FALSE
