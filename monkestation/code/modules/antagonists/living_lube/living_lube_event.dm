/datum/round_event_control/living_lube
	name = "Ghost of Honks Past"
	typepath = /datum/round_event/ghost_role/living_lube
	weight = 2 //don't want this little lube appearing Too often
	max_occurrences = 1

/datum/round_event/ghost_role/living_lube
	minimum_required = 1
	role_name = "Ghost of Honks Past"
	fakeable = FALSE

/datum/round_event/ghost_role/living_lube/spawn_role()
	var/list/candidates = get_candidates()

	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)
	var/mob/living/simple_animal/hostile/retaliate/clown/lube/living_lube = new(pick(GLOB.xeno_spawn))

	var/datum/mind/new_mind = new /datum/mind(selected.key)
	new_mind.assigned_role = "Clown" //So Voice of God's 'Honk" slips people + anything else clown specific can work
	new_mind.special_role = "Ghost of Honks Past"
	new_mind.active = TRUE
	new_mind.transfer_to(living_lube)
	new_mind.add_antag_datum(/datum/antagonist/living_lube)

	message_admins("[ADMIN_LOOKUPFLW(living_lube)] has been made into a Ghost of Honks Past.")
	log_game("[key_name(living_lube)] was spawned as Ghost of Honks Past by an event.")
	spawned_mobs += living_lube
	return SUCCESSFUL_SPAWN

