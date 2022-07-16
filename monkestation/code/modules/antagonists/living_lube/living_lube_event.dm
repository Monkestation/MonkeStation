/datum/round_event_control/living_lube
	name = "Living lube"
	typepath = /datum/round_event/ghost_role/living_lube
	weight = 2 //don't want this little lube appearing too often do we
	max_occurrences = 1

/datum/round_event/ghost_role/living_lube
	minimum_required = 1
	role_name = "Living Lube"
	fakeable = FALSE

/datum/round_event/ghost_role/living_lube/spawn_role()
	var/list/candidates = get_candidates()

	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)
	var/mob/living/simple_animal/hostile/retaliate/clown/lube/living_lube = new(pick(GLOB.xeno_spawn))

	var/datum/mind/new_mind = new /datum/mind(selected.key)
	new_mind.assigned_role = "Living Lube"
	new_mind.special_role = "Living Lube"
	new_mind.active = TRUE
	new_mind.transfer_to(living_lube)
	new_mind.add_antag_datum(/datum/antagonist/living_lube)

	message_admins("[ADMIN_LOOKUPFLW(living_lube)] has been made into a Living Lube.")
	log_game("[key_name(living_lube)] was spawned as Living Lube by an event.")
	spawned_mobs += living_lube
	return SUCCESSFUL_SPAWN

