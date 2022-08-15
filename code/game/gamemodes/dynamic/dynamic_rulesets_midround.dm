//////////////////////////////////////////////
//                                          //
//            MIDROUND RULESETS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround // Can be drafted once in a while during a round
	ruletype = "Midround"
	/// If the ruleset should be restricted from ghost roles.
	var/restrict_ghost_roles = TRUE
	/// What mob type the ruleset is restricted to.
	var/required_type = /mob/living/carbon/human
	var/list/living_players = list()
	var/list/living_antags = list()
	var/list/dead_players = list()
	var/list/list_observers = list()

/datum/dynamic_ruleset/midround/from_ghosts
	weight = 0
	required_type = /mob/dead/observer
	/// Whether the ruleset should call generate_ruleset_body or not.
	var/makeBody = TRUE
	/// The rule needs this many applicants to be properly executed.
	var/required_applicants = 1

/datum/dynamic_ruleset/midround/trim_candidates()
	living_players = trim_list(mode.current_players[CURRENT_LIVING_PLAYERS])
	living_antags = trim_list(mode.current_players[CURRENT_LIVING_ANTAGS])
	dead_players = trim_list(mode.current_players[CURRENT_DEAD_PLAYERS])
	list_observers = trim_list(mode.current_players[CURRENT_OBSERVERS])

/datum/dynamic_ruleset/midround/proc/trim_list(list/L = list())
	var/list/trimmed_list = L.Copy()
	for(var/mob/M in trimmed_list)
		if (!istype(M, required_type))
			trimmed_list.Remove(M)
			continue
		if (!M.client) // Are they connected?
			trimmed_list.Remove(M)
			continue
		if(!mode.check_age(M.client, minimum_required_age))
			trimmed_list.Remove(M)
			continue
		if(antag_flag_override)
			if(!(antag_flag_override in M.client.prefs.be_special) || is_banned_from(M.ckey, list(antag_flag_override, ROLE_SYNDICATE)))
				trimmed_list.Remove(M)
				continue
		else
			if(!(antag_flag in M.client.prefs.be_special) || is_banned_from(M.ckey, list(antag_flag, ROLE_SYNDICATE)))
				trimmed_list.Remove(M)
				continue
		if (M.mind)
			if (restrict_ghost_roles && (M.mind.assigned_role in GLOB.exp_specialmap[EXP_TYPE_SPECIAL])) // Are they playing a ghost role?
				trimmed_list.Remove(M)
				continue
			if (M.mind.assigned_role in restricted_roles) // Does their job allow it?
				trimmed_list.Remove(M)
				continue
			if ((exclusive_roles.len > 0) && !(M.mind.assigned_role in exclusive_roles)) // Is the rule exclusive to their job?
				trimmed_list.Remove(M)
				continue
	return trimmed_list

// You can then for example prompt dead players in execute() to join as strike teams or whatever
// Or autotator someone

// IMPORTANT, since /datum/dynamic_ruleset/midround may accept candidates from both living, dead, and even antag players, you need to manually check whether there are enough candidates
// (see /datum/dynamic_ruleset/midround/autotraitor/ready(var/forced = FALSE) for example)
/datum/dynamic_ruleset/midround/ready(forced = FALSE)
	if (!forced)
		var/job_check = 0
		if (enemy_roles.len > 0)
			for (var/mob/M in mode.current_players[CURRENT_LIVING_PLAYERS])
				if (M.stat == DEAD || !M.client)
					continue // Dead/disconnected players cannot count as opponents
				if (M.mind && M.mind.assigned_role && (M.mind.assigned_role in enemy_roles) && (!(M in candidates) || (M.mind.assigned_role in restricted_roles)))
					job_check++ // Checking for "enemies" (such as sec officers). To be counters, they must either not be candidates to that rule, or have a job that restricts them from it

		var/threat = round(mode.threat_level/10)
		if (job_check < required_enemies[threat])
			return FALSE
	return TRUE

/datum/dynamic_ruleset/midround/from_ghosts/execute()
	cost = round(cost * 1.25) //Extra cost to the rule every time it rolls.
	var/list/possible_candidates = list()
	possible_candidates.Add(dead_players)
	possible_candidates.Add(list_observers)
	send_applications(possible_candidates)
	if(assigned.len > 0)
		return TRUE
	else
		return FALSE

/// This sends a poll to ghosts if they want to be a ghost spawn from a ruleset.
/datum/dynamic_ruleset/midround/from_ghosts/proc/send_applications(list/possible_volunteers = list())
	if (possible_volunteers.len <= 0) // This shouldn't happen, as ready() should return FALSE if there is not a single valid candidate
		message_admins("Possible volunteers was 0. This shouldn't appear, because of ready(), unless you forced it!")
		return
	message_admins("Polling [possible_volunteers.len] players to apply for the [name] ruleset.")
	log_game("DYNAMIC: Polling [possible_volunteers.len] players to apply for the [name] ruleset.")

	candidates = pollGhostCandidates("The mode is looking for volunteers to become [antag_flag] for [name]", antag_flag, SSticker.mode, antag_flag_override ? antag_flag_override : antag_flag, poll_time = 300)

	if(!candidates || candidates.len <= 0)
		message_admins("The ruleset [name] received no applications.")
		log_game("DYNAMIC: The ruleset [name] received no applications.")
		mode.executed_rules -= src
		return

	message_admins("[candidates.len] players volunteered for the ruleset [name].")
	log_game("DYNAMIC: [candidates.len] players volunteered for [name].")
	review_applications()

/// Here is where you can check if your ghost applicants are valid for the ruleset.
/// Called by send_applications().
/datum/dynamic_ruleset/midround/from_ghosts/proc/review_applications()
	if(candidates.len < required_applicants)
		mode.executed_rules -= src
		return
	for (var/i = 1, i <= required_candidates, i++)
		if(candidates.len <= 0)
			if(i == 1)
				// We have found no candidates so far and we are out of applicants.
				mode.executed_rules -= src
			break
		var/mob/applicant = pick(candidates)
		candidates -= applicant
		if(!isobserver(applicant))
			if(applicant.stat == DEAD) // Not an observer? If they're dead, make them one.
				applicant = applicant.ghostize(FALSE,SENTIENCE_ERASE)
			else // Not dead? Disregard them, pick a new applicant
				i--
				continue

		if(!applicant)
			i--
			continue

		var/mob/new_character = applicant

		if (makeBody)
			new_character = generate_ruleset_body(applicant)

		finish_setup(new_character, i)
		assigned += applicant
		notify_ghosts("[new_character] has been picked for the ruleset [name]!", source = new_character, action = NOTIFY_ORBIT, header="Something Interesting!")

/datum/dynamic_ruleset/midround/from_ghosts/proc/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/new_character = makeBody(applicant)
	new_character.dna.remove_all_mutations()
	return new_character

/datum/dynamic_ruleset/midround/from_ghosts/proc/finish_setup(mob/new_character, index)
	var/datum/antagonist/new_role = new antag_datum()
	setup_role(new_role)
	new_character.mind.add_antag_datum(new_role)
	new_character.mind.special_role = antag_flag

/datum/dynamic_ruleset/midround/from_ghosts/proc/setup_role(datum/antagonist/new_role)
	return

//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/autotraitor
	name = "Syndicate Sleeper Agent"
	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_TRAITOR
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("Cyborg", "AI", "Positronic Brain")
	required_candidates = 1
	minimum_players = 8
	weight = 5
	cost = 10
	requirements = list(20,20,20,20,20,20,20,20,20,20)
	repeatable = TRUE

/datum/dynamic_ruleset/midround/autotraitor/acceptable(population = 0, threat = 0)
	var/player_count = mode.current_players[CURRENT_LIVING_PLAYERS].len
	var/antag_count = mode.current_players[CURRENT_LIVING_ANTAGS].len
	var/max_traitors = round(player_count / 10) + 1

	// adding traitors if the antag population is getting low
	var/too_little_antags = antag_count < max_traitors
	if (!too_little_antags)
		log_game("DYNAMIC: Too many living antags compared to living players ([antag_count] living antags, [player_count] living players, [max_traitors] max traitors)")
		return FALSE

	if (!prob(mode.threat_level))
		log_game("DYNAMIC: Random chance to roll autotraitor failed, it was a [mode.threat_level]% chance.")
		return FALSE

	return ..()

/datum/dynamic_ruleset/midround/autotraitor/trim_candidates()
	..()
	for(var/mob/living/player in living_players)
		if(issilicon(player)) // Your assigned role doesn't change when you are turned into a silicon.
			living_players -= player
			continue
		if(is_centcom_level(player.z))
			living_players -= player // We don't autotator people in CentCom
			continue
		if(player.mind && (player.mind.special_role || player.mind.antag_datums?.len > 0))
			living_players -= player // We don't autotator people with roles already

/datum/dynamic_ruleset/midround/autotraitor/ready(forced = FALSE)
	if (required_candidates > living_players.len)
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/autotraitor/execute()
	var/mob/M = pick(living_players)
	assigned += M
	living_players -= M
	var/datum/antagonist/traitor/newTraitor = new
	M.mind.add_antag_datum(newTraitor)
	return TRUE


//////////////////////////////////////////////
//                                          //
//         Malfunctioning AI                //
//                              		    //
//////////////////////////////////////////////

#define REPLACE_LAW_CHANCE 10
#define ANNOUNCE_ION_LAW_CHANCE 33

/datum/dynamic_ruleset/midround/malf
	name = "Malfunctioning AI"
	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_MALF
	enemy_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Scientist", "Chemist", "Research Director", "Chief Engineer")
	exclusive_roles = list("AI")
	required_enemies = list(4,4,4,4,4,4,2,2,2,0)
	required_candidates = 1
	weight = 3
	cost = 30
	minimum_players = 25
	requirements = list(101,101,101,101,50,40,30,30,30,30)
	required_type = /mob/living/silicon/ai

/datum/dynamic_ruleset/midround/malf/trim_candidates()
	..()
	candidates = living_players
	for(var/mob/living/player in candidates)
		if(!isAI(player))
			candidates -= player
			continue
		if(is_centcom_level(player.z))
			candidates -= player
			continue
		if(player.mind && (player.mind.special_role || player.mind.antag_datums?.len > 0))
			candidates -= player

/datum/dynamic_ruleset/midround/malf/execute()
	if(!candidates || !candidates.len)
		return FALSE
	var/mob/living/silicon/ai/M = pick_n_take(candidates)
	assigned += M.mind
	var/datum/antagonist/traitor/AI = new
	M.mind.special_role = antag_flag
	M.mind.add_antag_datum(AI)
	if(prob(ANNOUNCE_ION_LAW_CHANCE))
		priority_announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", ANNOUNCER_IONSTORM)
		if(prob(REPLACE_LAW_CHANCE))
			M.replace_random_law(generate_ion_law(), list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION))
		else
			M.add_ion_law(generate_ion_law())
	return TRUE

#undef REPLACE_LAW_CHANCE
#undef ANNOUNCE_ION_LAW_CHANCE

//////////////////////////////////////////////
//                                          //
//              WIZARD (GHOST)              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/wizard
	name = "Wizard"
	antag_datum = /datum/antagonist/wizard
	antag_flag = ROLE_WIZARD
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain", "Research Director") //RD doesn't believe in magic
	required_enemies = list(2,2,1,1,1,1,1,1,1,1)
	required_candidates = 1
	weight = 3
	cost = 20
	minimum_players = 30
	requirements = list(101,101,101,101,40,30,10,10,10,10)
	flags = HIGH_IMPACT_RULESET

/datum/dynamic_ruleset/midround/from_ghosts/wizard/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	if(GLOB.wizardstart.len == 0)
		log_admin("Cannot accept Wizard ruleset. Couldn't find any wizard spawn points.")
		message_admins("Cannot accept Wizard ruleset. Couldn't find any wizard spawn points.")
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/wizard/finish_setup(mob/new_character, index)
	..()
	new_character.forceMove(pick(GLOB.wizardstart))

//////////////////////////////////////////////
//                                          //
//          NUCLEAR OPERATIVES (MIDROUND)   //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/nuclear
	name = "Nuclear Assault"
	antag_flag = ROLE_OPERATIVE
	antag_datum = /datum/antagonist/nukeop
	enemy_roles = list("AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	required_enemies = list(3,3,3,3,3,2,1,1,0,0)
	required_candidates = 3
	weight = 4
	cost = 20
	minimum_players = 30
	requirements = list(101,101,101,101,101,40,30,20,10,10)
	var/list/operative_cap = list(2,2,3,3,4,5,5,5,5,5)
	var/datum/team/nuclear/nuke_team
	flags = HIGH_IMPACT_RULESET

/datum/dynamic_ruleset/midround/from_ghosts/nuclear/acceptable(population=0, threat=0)
	if (locate(/datum/dynamic_ruleset/roundstart/nuclear) in mode.executed_rules)
		return FALSE // Unavailable if nuke ops were already sent at roundstart
	indice_pop = min(operative_cap.len, round(living_players.len/5)+1)
	required_candidates = operative_cap[indice_pop]
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/nuclear/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/nuclear/finish_setup(mob/new_character, index)
	new_character.mind.special_role = "Nuclear Operative"
	new_character.mind.assigned_role = "Nuclear Operative"
	if (index == 1) // Our first guy is the leader
		var/datum/antagonist/nukeop/leader/new_role = new
		nuke_team = new_role.nuke_team
		new_character.mind.add_antag_datum(new_role)
	else
		return ..()

//////////////////////////////////////////////
//                                          //
//              BLOB (GHOST)                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/blob
	name = "Blob"
	antag_datum = /datum/antagonist/blob
	antag_flag = ROLE_BLOB
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 3
	cost = 25
	minimum_players = 30
	requirements = list(101,101,101,80,60,50,30,20,10,10)
	repeatable = TRUE

/datum/dynamic_ruleset/midround/from_ghosts/blob/generate_ruleset_body(mob/applicant)
	var/body = applicant.become_overmind()
	return body

//////////////////////////////////////////////
//                                          //
//           XENOMORPH (GHOST)              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/xenomorph
	name = "Alien Infestation"
	antag_datum = /datum/antagonist/xeno
	antag_flag = ROLE_ALIEN
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 3
	cost = 25
	minimum_players = 30
	requirements = list(101,101,101,70,50,40,20,15,10,10)
	repeatable = TRUE
	var/list/vents = list()

/datum/dynamic_ruleset/midround/from_ghosts/xenomorph/execute()
	// 50% chance of being incremented by one
	required_candidates += prob(50)
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in GLOB.machines)
		if(QDELETED(temp_vent))
			continue
		if(is_station_level(temp_vent.loc.z) && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.parents[1]
			if(!temp_vent_parent)
				continue // No parent vent
			// Stops Aliens getting stuck in small networks.
			// See: Security, Virology
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent
	if(!vents.len)
		return FALSE
	. = ..()

/datum/dynamic_ruleset/midround/from_ghosts/xenomorph/generate_ruleset_body(mob/applicant)
	var/obj/vent = pick_n_take(vents)
	var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
	new_xeno.key = applicant.key
	message_admins("[ADMIN_LOOKUPFLW(new_xeno)] has been made into an alien by the midround ruleset.")
	log_game("DYNAMIC: [key_name(new_xeno)] was spawned as an alien by the midround ruleset.")
	return new_xeno

//////////////////////////////////////////////
//                                          //
//           NIGHTMARE (GHOST)              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/nightmare
	name = "Nightmare"
	antag_datum = /datum/antagonist/nightmare
	antag_flag = "Nightmare"
	antag_flag_override = ROLE_ALIEN
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 3
	cost = 15
	minimum_players = 30
	requirements = list(101,101,101,70,50,40,20,15,10,10)
	repeatable = TRUE
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/nightmare/execute()
	for(var/X in GLOB.xeno_spawn)
		var/turf/T = X
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			spawn_locs += T
	if(!spawn_locs.len)
		return FALSE
	. = ..()

/datum/dynamic_ruleset/midround/from_ghosts/nightmare/generate_ruleset_body(mob/applicant)
	var/datum/mind/player_mind = new /datum/mind(applicant.key)
	player_mind.active = TRUE

	var/mob/living/carbon/human/S = new (pick(spawn_locs))
	player_mind.transfer_to(S)
	player_mind.assigned_role = "Nightmare"
	player_mind.special_role = "Nightmare"
	player_mind.add_antag_datum(/datum/antagonist/nightmare)
	S.set_species(/datum/species/shadow/nightmare)

	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Nightmare by the midround ruleset.")
	log_game("DYNAMIC: [key_name(S)] was spawned as a Nightmare by the midround ruleset.")
	return S

//////////////////////////////////////////////
//                                          //
//           ABDUCTORS    (GHOST)           //
//                                          //
//////////////////////////////////////////////
#define ABDUCTOR_MAX_TEAMS 4

/datum/dynamic_ruleset/midround/from_ghosts/abductors
	name = "Abductors"
	antag_flag = "Abductor"
	antag_flag_override = ROLE_ABDUCTOR
	enemy_roles = list("Security Officer", "Detective", "Warden", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 2
	required_applicants = 2
	weight = 4
	cost = 15
	minimum_players = 20
	requirements = list(101,101,101,40,30,30,30,20,10,10)
	repeatable = TRUE
	var/datum/team/abductor_team/new_team

/datum/dynamic_ruleset/midround/from_ghosts/abductors/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/abductors/finish_setup(mob/new_character, index)
	if (index == 1) // Our first guy is the scientist.  We also initialize the team here as well since this should only happen once per pair of abductors.
		new_team = new
		if(new_team.team_number > ABDUCTOR_MAX_TEAMS)
			return MAP_ERROR
		var/datum/antagonist/abductor/scientist/new_role = new
		new_character.mind.add_antag_datum(new_role, new_team)
	else // Our second guy is the agent, team is already created, don't need to make another one.
		var/datum/antagonist/abductor/agent/new_role = new
		new_character.mind.add_antag_datum(new_role, new_team)

#undef ABDUCTOR_MAX_TEAMS

//////////////////////////////////////////////
//                                          //
//           PIRATES      (GHOST)           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/pirates
	name = "Space Pirates"
	antag_flag = ROLE_TRAITOR
	required_type = /mob/dead/observer
	enemy_roles = list("Security Officer", "Detective", "Head of Security", "Captain")
	required_enemies = list(2,2,2,2,2,2,2,2,2,2)
	weight = 5
	cost = 10
	minimum_players = 25
	requirements = list(101,101,101,80,60,50,30,20,10,10)

/datum/dynamic_ruleset/midround/pirates/acceptable(population=0, threat=0)
	if (!SSmapping.empty_space)
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/pirates/execute()
	send_pirate_threat()

//////////////////////////////////////////////
//                                          //
//           REVENANT      (GHOST)          //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/revenant
	name = "Revenant"
	antag_datum = /datum/antagonist/revenant
	antag_flag = "Revenant"
	antag_flag_override = ROLE_REVENANT
	enemy_roles = list("Security Officer", "Detective", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 4
	cost = 10
	requirements = list(101,101,101,70,50,40,20,15,10,10)
	repeatable = TRUE
	var/dead_mobs_required = 20
	var/need_extra_spawns_value = 15
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/revenant/acceptable(population=0, threat=0)
	if(GLOB.dead_mob_list.len < dead_mobs_required)
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/revenant/execute()
	for(var/mob/living/corpse in GLOB.dead_mob_list) //look for any dead bodies
		var/turf/corpse_turf = get_turf(corpse)
		if(corpse_turf && is_station_level(corpse_turf.z))
			spawn_locs += corpse_turf
	if(!spawn_locs.len || spawn_locs.len < need_extra_spawns_value) //look for any morgue trays, crematoriums, ect if there weren't alot of dead bodies on the station to pick from
		for(var/obj/structure/bodycontainer/corpse_container in GLOB.bodycontainers)
			var/turf/container_turf = get_turf(corpse_container)
			if(container_turf && is_station_level(container_turf.z))
				spawn_locs += container_turf
	if(!spawn_locs.len) //If we can't find any valid spawnpoints, try the carp spawns
		for(var/obj/effect/landmark/carpspawn/carp_spawnpoint in GLOB.landmarks_list)
			if(isturf(carp_spawnpoint.loc))
				spawn_locs += carp_spawnpoint.loc
	if(!spawn_locs.len) //If we can't find THAT, then just give up and cry
		return FALSE
	. = ..()

/datum/dynamic_ruleset/midround/from_ghosts/revenant/generate_ruleset_body(mob/applicant)
	var/mob/living/simple_animal/revenant/revenant = new(pick(spawn_locs))
	revenant.key = applicant.key
	message_admins("[ADMIN_LOOKUPFLW(revenant)] has been made into a revenant by the midround ruleset.")
	log_game("[key_name(revenant)] was spawned as a revenant by the midround ruleset.")
	return revenant

//////////////////////////////////////////////
//                                          //
//           		OBSESSED			    //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/obsessed
	name = "Obsessed"
	antag_datum = /datum/antagonist/obsessed
	antag_flag = ROLE_OBSESSED
	restricted_roles = list("Cyborg", "AI", "Positronic Brain")
	enemy_roles = list("Security Officer", "Detective", "Head of Security", "Captain")
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 1
	weight = 3
	cost = 10
	requirements = list(101,101,101,80,60,50,30,20,10,10)
	repeatable = TRUE

/datum/dynamic_ruleset/midround/obsessed/trim_candidates()
	..()
	candidates = living_players
	for(var/mob/living/carbon/human/candidate in candidates)
		if( \
			!candidate.getorgan(/obj/item/organ/brain) \
			|| candidate.mind.has_antag_datum(/datum/antagonist/obsessed) \
			|| candidate.stat == DEAD \
			|| !(ROLE_OBSESSED in candidate.client?.prefs?.be_special) \
			|| !SSjob.GetJob(candidate.mind.assigned_role) \
			|| (candidate.mind.assigned_role in GLOB.nonhuman_positions) \
		)
			candidates -= candidate

/datum/dynamic_ruleset/midround/obsessed/execute()
	if(!candidates || !candidates.len)
		return FALSE
	var/mob/living/carbon/human/obsessed = pick_n_take(candidates)
	obsessed.gain_trauma(/datum/brain_trauma/special/obsessed)
	message_admins("[ADMIN_LOOKUPFLW(obsessed)] has been made Obsessed by the midround ruleset.")
	log_game("[key_name(obsessed)] was made Obsessed by the midround ruleset.")
	return ..()
