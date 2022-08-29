//////////////////////////////////////////////
//                                          //
//           MIMICS (GHOST)                 //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/mimic
	name = "Mimic"
	antag_datum = /datum/antagonist/mimic
	antag_flag = "Mimic"
	antag_flag_override = ROLE_ALIEN
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain")
	required_enemies = list(4,3,3,3,2,2,1,1,1,0)
	required_candidates = 1
	weight = 2
	cost = 15
	minimum_players = 30
	requirements = list(101,101,101,60,50,40,20,15,10,10)
	repeatable = FALSE

/datum/dynamic_ruleset/midround/from_ghosts/mimic/execute()
	if(!GLOB.xeno_spawn.len)
		log_admin("Cannot accept Mimic ruleset. Couldn't find any xeno spawn points.")
		message_admins("Cannot accept Mimic ruleset. Couldn't find any xeno spawn points.")
		return FALSE
	. = ..()

/datum/dynamic_ruleset/midround/from_ghosts/mimic/generate_ruleset_body(mob/applicant)
	var/mob/living/simple_animal/hostile/alien_mimic/spawned_mimic = new(pick(GLOB.xeno_spawn))
	var/datum/mind/player_mind = new(applicant.key)
	player_mind.assigned_role = "Mimic"
	player_mind.special_role = "Mimic"
	player_mind.active = TRUE
	player_mind.transfer_to(spawned_mimic)
	player_mind.add_antag_datum(/datum/antagonist/mimic)

	//Give them a special name in the hivemind for being the first one
	spawned_mimic.hivemind_name = pick("Mimic Leader","Mimic Queen","The First Mimic","The Original")

	message_admins("[ADMIN_LOOKUPFLW(spawned_mimic)] has been made into a Mimic by the midround ruleset.")
	log_game("DYNAMIC: [key_name(spawned_mimic)] was spawned as a Mimic by the midround ruleset.")
	return spawned_mimic



