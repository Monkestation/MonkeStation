#define IMPORTANT_ACTION_COOLDOWN (60 SECONDS)
#define MAX_STATUS_LINE_LENGTH 40

#define STATE_BUYING_SHUTTLE "buying_shuttle"
#define STATE_CHANGING_STATUS "changing_status"
#define STATE_MESSAGES "messages"

// The communications computer
/obj/machinery/computer/communications
	name = "communications console"
	desc = "A console used for high-priority announcements and emergencies."
	icon_screen = "comm"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_HEADS)
	circuit = /obj/item/circuitboard/computer/communications
	light_color = LIGHT_COLOR_BLUE

	/// Authentication level
	var/authenticated = 0

	/// Cooldown for important actions, such as messaging CentCom or other sectors
	COOLDOWN_DECLARE(static/important_action_cooldown)

	/// The current state of the UI
	var/state = STATE_MESSAGES

	/// The current state of the UI for AIs
	var/cyborg_state = STATE_MESSAGES

	/// The name of the user who logged in
	var/authorize_name

	/// The access that the card had on login
	var/list/authorize_access

	/// The messages this console has been sent
	var/list/datum/comm_message/messages

	/// How many times the alert level has been changed
	/// Used to clear the modal to change alert level
	var/alert_level_tick = 0

	/// The last lines used for changing the status display
	var/static/last_status_display

/obj/machinery/computer/communications/Initialize(mapload)
	. = ..()
	GLOB.shuttle_caller_list += src

/// Are we NOT a silicon, AND we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_non_silicon_captain(mob/user)
	if (issilicon(user))
		return FALSE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_silicon_or_captain(mob/user)
	if (issilicon(user))
		return TRUE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR logged in?
/obj/machinery/computer/communications/proc/authenticated(mob/user)
	if (issilicon(user))
		return TRUE
	return authenticated

/obj/machinery/computer/communications/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		attack_hand(user)
	else
		return ..()

/obj/machinery/computer/communications/emag_act(mob/user)
	if (obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	if (authenticated)
		authorize_access = get_all_accesses()
	to_chat(user, "<span class='danger'>You scramble the communication routing circuits!</span>")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)

/obj/machinery/computer/communications/ui_act(action, list/params)
	var/static/list/approved_states = list(STATE_BUYING_SHUTTLE, STATE_CHANGING_STATUS, STATE_MESSAGES)
	var/static/list/approved_status_pictures = list("biohazard", "blank", "default", "lockdown", "redalert", "shuttle")

	. = ..()
	if (.)
		return

	if (!has_communication())
		return

	switch (action)
		if ("answerMessage")
			if (!authenticated(usr))
				return
			var/answer_index = text2num(params["answer"])
			var/message_index = text2num(params["message"])
			if (!answer_index || !message_index || answer_index < 1 || message_index < 1)
				return
			var/datum/comm_message/message = messages[message_index]
			if (message.answered)
				return
			message.answered = answer_index
			message.answer_callback.InvokeAsync()
			. = TRUE
		if ("callShuttle")
			if (!authenticated(usr))
				return
			var/reason = trim(params["reason"], MAX_MESSAGE_LEN)
			if (length(reason) < CALL_SHUTTLE_REASON_LENGTH)
				return
			SSshuttle.requestEvac(usr, reason)
			post_status("shuttle")
			. = TRUE
		if ("changeSecurityLevel")
			if (!authenticated_as_silicon_or_captain(usr))
				return

			// Check if they have
			if (!issilicon(usr))
				var/obj/item/held_item = usr.get_active_held_item()
				var/obj/item/card/id/id_card = held_item?.GetID()
				if (!istype(id_card))
					to_chat(usr, "<span class='warning'>You need to swipe your ID!</span>")
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
					return
				if (!(ACCESS_CAPTAIN in id_card.access))
					to_chat(usr, "<span class='warning'>You are not authorized to do this!</span>")
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
					return

			var/new_sec_level = seclevel2num(params["newSecurityLevel"])
			if (new_sec_level != SEC_LEVEL_GREEN && new_sec_level != SEC_LEVEL_BLUE)
				return
			if (GLOB.security_level == new_sec_level)
				return

			set_security_level(new_sec_level)

			to_chat(usr, "<span class='notice'>Authorization confirmed. Modifying security level.</span>")
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

			// Only notify people if an actual change happened
			log_game("[key_name(usr)] has changed the security level to [params["newSecurityLevel"]] with [src] at [AREACOORD(usr)].")
			message_admins("[ADMIN_LOOKUPFLW(usr)] has changed the security level to [params["newSecurityLevel"]] with [src] at [AREACOORD(usr)].")
			deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has changed the security level to [params["newSecurityLevel"]] with [src] at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)

			alert_level_tick += 1
			. = TRUE
		if ("deleteMessage")
			if (!authenticated(usr))
				return
			var/message_index = text2num(params["message"])
			if (!message_index)
				return
			LAZYREMOVE(messages, LAZYACCESS(messages, message_index))
			. = TRUE
		if ("makePriorityAnnouncement")
			if (!authenticated_as_silicon_or_captain(usr))
				return
			make_announcement(usr)
			. = TRUE
		if ("messageAssociates")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			var/message = trim(html_encode(params["message"]), MAX_MESSAGE_LEN)

			var/emagged = obj_flags & EMAGGED
			if (emagged)
				message_syndicate(message, usr)
				to_chat(usr, "<span class='danger'>SYSERR @l(19833)of(transmit.dm): !@$ MESSAGE TRANSMITTED TO SYNDICATE COMMAND.</span>")
			else
				message_centcom(message, usr)
				to_chat(usr, "<span class='notice'>Message transmitted to Central Command.</span>")

			var/associates = emagged ? "the Syndicate": "CentCom"
			usr.log_talk(message, LOG_SAY, tag = "message to [associates]")
			deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged [associates], \"[message]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("purchaseShuttle")
			var/can_buy_shuttles_or_fail_reason = can_buy_shuttles(usr)
			if (can_buy_shuttles_or_fail_reason != TRUE)
				if (can_buy_shuttles_or_fail_reason != FALSE)
					to_chat(usr, "<span class='alert'>[can_buy_shuttles_or_fail_reason]</span>")
				return
			var/list/shuttles = flatten_list(SSmapping.shuttle_templates)
			var/datum/map_template/shuttle/shuttle = locate(params["shuttle"]) in shuttles
			if (!istype(shuttle))
				return
			if (!can_purchase_this_shuttle(shuttle))
				return
			if (!shuttle.prerequisites_met())
				to_chat(usr, "<span class='alert'>You have not met the requirements for purchasing this shuttle.</span>")
				return
			var/datum/bank_account/bank_account = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if (bank_account.account_balance < shuttle.credit_cost)
				return
			SSshuttle.shuttle_purchased = TRUE
			SSshuttle.unload_preview()
			SSshuttle.existing_shuttle = SSshuttle.emergency
			SSshuttle.action_load(shuttle)
			bank_account.adjust_money(-shuttle.credit_cost)
			minor_announce("[shuttle.name] has been purchased for [shuttle.credit_cost] credits! Purchase authorized by [authorize_name] [shuttle.extra_desc ? " [shuttle.extra_desc]" : ""]" , "Shuttle Purchase")
			message_admins("[ADMIN_LOOKUPFLW(usr)] purchased [shuttle.name].")
			log_game("[key_name(usr)] has purchased [shuttle.name].")
			SSblackbox.record_feedback("text", "shuttle_purchase", 1, shuttle.name)
			//state = STATE_MAIN
			. = TRUE
		if ("recallShuttle")
			// AIs cannot recall the shuttle
			if (!authenticated(usr) || issilicon(usr))
				return
			. = SSshuttle.cancelEvac(usr)
		if ("requestNukeCodes")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return
			var/reason = trim(html_encode(params["reason"]), MAX_MESSAGE_LEN)
			nuke_request(reason, usr)
			to_chat(usr, "<span class='notice'>Request sent.</span>")
			usr.log_message("has requested the nuclear codes from CentCom with reason \"[reason]\"", LOG_SAY)
			priority_announce("The codes for the on-station nuclear self-destruct have been requested by [usr]. Confirmation or denial of this request will be sent shortly.", "Nuclear Self-Destruct Codes Requested", SSstation.announcer.get_rand_report_sound())
			playsound(src, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("restoreBackupRoutingData")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!(obj_flags & EMAGGED))
				return
			to_chat(usr, "<span class='notice'>Backup routing data restored.</span>")
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			obj_flags &= ~EMAGGED
			. = TRUE
		if ("sendToOtherSector")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!can_send_messages_to_other_sectors(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			var/message = trim(html_encode(params["message"]), MAX_MESSAGE_LEN)
			if (!message)
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

			SStopic.crosscomms_send("comms_console", message, station_name())
			minor_announce(message, title = "Outgoing message to allied station", html_encode = FALSE)
			usr.log_talk(message, LOG_SAY, tag="message to the other server")
			message_admins("[ADMIN_LOOKUPFLW(usr)] has sent a message to the other server.")
			deadchat_broadcast("<span class='deadsay bold'>[usr.real_name] has sent an outgoing message to the other station(s).</span>", usr)

			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("setState")
			if (!authenticated(usr))
				return
			if (!(params["state"] in approved_states))
				return
			var/newState = params["state"]
			if (newState == STATE_BUYING_SHUTTLE && can_buy_shuttles(usr) != TRUE)
				return
			set_state(usr, newState)
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("setStatusMessage")
			if (!authenticated(usr))
				return
			var/line_one = reject_bad_text(params["lineOne"] || "", MAX_STATUS_LINE_LENGTH)
			var/line_two = reject_bad_text(params["lineTwo"] || "", MAX_STATUS_LINE_LENGTH)
			message_admins("[ADMIN_LOOKUPFLW(usr)] changed the Status Message to - [line_one], [line_two] - From a Communications Console.")
			log_game("[key_name(usr)] changed the Status Message to - [line_one], [line_two] - From a Communications Console.")
			post_status("alert", "blank")
			post_status("message", line_one, line_two)
			last_status_display = list(line_one, line_two)
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("setStatusPicture")
			if (!authenticated(usr))
				return
			var/picture = params["picture"]
			if (!(picture in approved_status_pictures))
				return
			post_status("alert", picture)
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("toggleAuthentication")
			// Log out if we're logged in
			if (authorize_name)
				authenticated = FALSE
				authorize_access = null
				authorize_name = null
				playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)
				return TRUE

			if (obj_flags & EMAGGED)
				authenticated = TRUE
				authorize_access = get_all_accesses()
				authorize_name = "Unknown"
				to_chat(usr, "<span class='warning'>[src] lets out a quiet alarm as its login is overridden.</span>")
				playsound(src, 'sound/machines/terminal_alert.ogg', 25, FALSE)
			else
				var/obj/item/card/id/id_card = usr.get_idcard(hand_first = TRUE)
				if (check_access(id_card))
					authenticated = TRUE
					authorize_access = id_card.access
					authorize_name = "[id_card.registered_name] - [id_card.assignment]"

			state = STATE_MESSAGES
			playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)
			. = TRUE
		if ("toggleEmergencyAccess")
			if (!authenticated_as_silicon_or_captain(usr))
				return
			. = TRUE
			if (GLOB.emergency_access)
				revoke_maint_all_access()
				log_game("[key_name(usr)] disabled emergency maintenance access.")
				message_admins("[ADMIN_LOOKUPFLW(usr)] disabled emergency maintenance access.")
				deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> disabled emergency maintenance access at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
			else
				make_maint_all_access()
				log_game("[key_name(usr)] enabled emergency maintenance access.")
				message_admins("[ADMIN_LOOKUPFLW(usr)] enabled emergency maintenance access.")
				deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> enabled emergency maintenance access at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)

/obj/machinery/computer/communications/ui_data(mob/user)
	var/list/data = list(
		"authenticated" = FALSE,
		"emagged" = FALSE,
		"hasConnection" = has_communication(),
	)

	var/ui_state = issilicon(user) ? cyborg_state : state

	if (authenticated || issilicon(user))
		data["authenticated"] = TRUE
		data["canLogOut"] = !issilicon(user)
		data["page"] = ui_state

		if (obj_flags & EMAGGED)
			data["emagged"] = TRUE

		//Main section is always visible when authenticated
		data["canBuyShuttles"] = can_buy_shuttles(user)
		data["canMakeAnnouncement"] = FALSE
		data["canMessageAssociates"] = FALSE
		data["canRecallShuttles"] = !issilicon(user)
		data["canRequestNuke"] = FALSE
		data["canSendToSectors"] = FALSE
		data["canSetAlertLevel"] = FALSE
		data["canToggleEmergencyAccess"] = FALSE
		data["importantActionReady"] = COOLDOWN_FINISHED(src, important_action_cooldown)
		data["shuttleCalled"] = FALSE
		data["shuttleLastCalled"] = FALSE

		data["alertLevel"] = get_security_level()
		data["authorizeName"] = authorize_name
		data["canLogOut"] = !issilicon(user)
		data["shuttleCanEvacOrFailReason"] = SSshuttle.canEvac(user)

		if (authenticated_as_non_silicon_captain(user))
			data["canMessageAssociates"] = TRUE
			data["canRequestNuke"] = TRUE

		if (can_send_messages_to_other_sectors(user))
			data["canSendToSectors"] = TRUE

		if (authenticated_as_silicon_or_captain(user))
			data["canToggleEmergencyAccess"] = TRUE
			data["emergencyAccess"] = GLOB.emergency_access

			data["alertLevelTick"] = alert_level_tick
			data["canMakeAnnouncement"] = TRUE
			data["canSetAlertLevel"] = issilicon(user) ? "NO_SWIPE_NEEDED" : "SWIPE_NEEDED"

		if (SSshuttle.emergency.mode != SHUTTLE_IDLE && SSshuttle.emergency.mode != SHUTTLE_RECALL)
			data["shuttleCalled"] = TRUE
			data["shuttleRecallable"] = SSshuttle.canRecall()

		if (SSshuttle.emergencyCallAmount)
			data["shuttleCalledPreviously"] = TRUE
			if (SSshuttle.emergencyLastCallLoc)
				data["shuttleLastCalled"] = format_text(SSshuttle.emergencyLastCallLoc.name)

		switch (ui_state)
			if (STATE_MESSAGES)
				data["messages"] = list()

				if (messages)
					for (var/_message in messages)
						var/datum/comm_message/message = _message
						data["messages"] += list(list(
							"answered" = message.answered,
							"content" = message.content,
							"title" = message.title,
							"possibleAnswers" = message.possible_answers,
						))
			if (STATE_BUYING_SHUTTLE)
				var/datum/bank_account/bank_account = SSeconomy.get_dep_account(ACCOUNT_CAR)
				var/list/shuttles = list()

				for (var/shuttle_id in SSmapping.shuttle_templates)
					var/datum/map_template/shuttle/shuttle_template = SSmapping.shuttle_templates[shuttle_id]
					if (shuttle_template.credit_cost == INFINITY)
						continue
					if (!can_purchase_this_shuttle(shuttle_template))
						continue
					shuttles += list(list(
						"name" = shuttle_template.name,
						"description" = shuttle_template.description,
						"creditCost" = shuttle_template.credit_cost,
						"illegal" = shuttle_template.illegal_shuttle,
						"prerequisites" = shuttle_template.prerequisites,
						"ref" = REF(shuttle_template),
					))

				data["budget"] = bank_account.account_balance
				data["shuttles"] = shuttles
			if (STATE_CHANGING_STATUS)
				data["lineOne"] = last_status_display ? last_status_display[1] : ""
				data["lineTwo"] = last_status_display ? last_status_display[2] : ""

	return data

/obj/machinery/computer/communications/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CommunicationsConsole")
		ui.open()

/obj/machinery/computer/communications/ui_static_data(mob/user)
	return list(
		"callShuttleReasonMinLength" = CALL_SHUTTLE_REASON_LENGTH,
		"maxStatusLineLength" = MAX_STATUS_LINE_LENGTH,
		"maxMessageLength" = MAX_MESSAGE_LEN,
	)

/// Returns whether or not the communications console can communicate with the station
/obj/machinery/computer/communications/proc/has_communication()
	var/turf/current_turf = get_turf(src)
	var/z_level = current_turf.z
	return is_station_level(z_level) || is_centcom_level(z_level)

/obj/machinery/computer/communications/proc/set_state(mob/user, new_state)
	if (issilicon(user))
		cyborg_state = new_state
	else
		state = new_state

/// Returns TRUE if the user can buy shuttles.
/// If they cannot, returns FALSE or a string detailing why.
/obj/machinery/computer/communications/proc/can_buy_shuttles(mob/user)
	if (!SSmapping.config.allow_custom_shuttles)
		return FALSE
	if (!authenticated_as_non_silicon_captain(user))
		return FALSE
	if (SSshuttle.emergency.mode != SHUTTLE_RECALL && SSshuttle.emergency.mode != SHUTTLE_IDLE)
		return "The shuttle is already in transit."
	if (SSshuttle.shuttle_purchased)
		return "A replacement shuttle has already been purchased."
	return TRUE

/// Returns whether we are authorized to buy this specific shuttle.
/// Does not handle prerequisite checks, as those should still *show*.
/obj/machinery/computer/communications/proc/can_purchase_this_shuttle(datum/map_template/shuttle/shuttle_template)
	if(shuttle_template.credit_cost == INFINITY)
		return FALSE
	var/obj/item/circuitboard/computer/communications/CM = circuit
	if(shuttle_template.illegal_shuttle && !((obj_flags & EMAGGED) || CM.insecure))
		return FALSE
	if(!shuttle_template.can_be_bought && !shuttle_template.illegal_shuttle)
		return FALSE

	return TRUE

/obj/machinery/computer/communications/proc/can_send_messages_to_other_sectors(mob/user)
	if (!authenticated_as_non_silicon_captain(user))
		return

	return length(CONFIG_GET(keyed_list/cross_server)) > 0

/obj/machinery/computer/communications/proc/make_announcement(mob/living/user)
	var/is_ai = issilicon(user)
	if(!SScommunications.can_announce(user, is_ai))
		to_chat(user, "<span class='alert'>Intercomms recharging. Please stand by.</span>")
		return
	var/input = stripped_input(user, "Please choose a message to announce to the station crew.", "What?")
	if(!input || !user.canUseTopic(src, !issilicon(usr)))
		return
	if(CHAT_FILTER_CHECK(input))
		to_chat(user, "<span class='warning'>You cannot send an announcement that contains prohibited words.</span>")
		return
	SScommunications.make_announcement(user, is_ai, input)
	deadchat_broadcast("<span class='deadsay'><span class='name'>[user.real_name]</span> made a priority announcement from <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", user)

/obj/machinery/computer/communications/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)

/obj/machinery/computer/communications/Destroy()
	GLOB.shuttle_caller_list -= src
	SSshuttle.autoEvac()
	return ..()

/// Override the cooldown for special actions
/// Used in places such as CentCom messaging back so that the crew can answer right away
/obj/machinery/computer/communications/proc/override_cooldown()
	COOLDOWN_RESET(src, important_action_cooldown)

/obj/machinery/computer/communications/proc/add_message(datum/comm_message/new_message)
	LAZYADD(messages, new_message)
	ui_update()

/// Defines for the various hack results.
#define HACK_PIRATE "Pirates"
#define HACK_FUGITIVES "Fugitives"
#define HACK_SLEEPER "Sleeper Agents"
#define HACK_THREAT "Threat Boost"
#define HACK_FLORIDA_MAN "Florida Man"


/// The minimum number of ghosts / observers to have the chance of spawning Florida Man
#define MIN_GHOSTS_FOR_FLORIDA_MAN 2
/// The minimum number of ghosts / observers to have the chance of spawning pirates.
#define MIN_GHOSTS_FOR_PIRATES 4
/// The minimum number of ghosts / observers to have the chance of spawning fugitives.
#define MIN_GHOSTS_FOR_FUGITIVES 6
/// The maximum percentage of the population to be ghosts before we no longer have the chance of spawning Sleeper Agents.
#define MAX_PERCENT_GHOSTS_FOR_SLEEPER 0.2
/// The amount of threat injected by a hack, if chosen.
#define HACK_THREAT_INJECTION_AMOUNT 15

/*
 * The communications console hack,
 * called by certain antagonist actions.
 *
 * Brings in additional threats to the round.
 *
 * hackerman - the mob that caused the hack
 */
/obj/machinery/computer/communications/proc/hack_console(mob/living/hackerman)
	// All hack results we'll choose from.
	var/list/hack_options = list(HACK_THREAT)

	// If we have a certain amount of ghosts, we'll add some more !!fun!! options to the list
	var/num_ghosts = length(SSticker.mode.current_players[CURRENT_DEAD_PLAYERS]) + length(SSticker.mode.current_players[CURRENT_OBSERVERS])

	// Florida Man requires only one ghost, therefore it's an easy common option.
	if(num_ghosts >= MIN_GHOSTS_FOR_FLORIDA_MAN)
		hack_options += HACK_FLORIDA_MAN
	// Pirates require empty space for the ship, and ghosts for the pirates obviously
	if(SSmapping.empty_space && (num_ghosts >= MIN_GHOSTS_FOR_PIRATES))
		hack_options += HACK_PIRATE
	// Fugitives require empty space for the hunter's ship, and ghosts for both fugitives and hunters (Please no waldo)
	if(SSmapping.empty_space && (num_ghosts >= MIN_GHOSTS_FOR_FUGITIVES))
		hack_options += HACK_FUGITIVES
	// If less than a certain percent of the population is ghosts, consider sleeper agents
	if(num_ghosts < (length(GLOB.clients) * MAX_PERCENT_GHOSTS_FOR_SLEEPER))
		hack_options += HACK_SLEEPER

	var/picked_option = pick(hack_options)
	message_admins("[ADMIN_LOOKUPFLW(hackerman)] hacked a [name] located at [ADMIN_VERBOSEJMP(src)], resulting in: [picked_option]!")
	switch(picked_option)
		//Triggers Florida Man. Impossible to contain. Impossible to stop. He will meth.
		if(HACK_FLORIDA_MAN)
			priority_announce("Attention crew, it appears that someone on your station has used our communication systems to disrupt Space Florida's connection to SPESSCAR broadcasting.","[command_name()] High-Priority Update")
			var/datum/round_event_control/florida_man/florida_event = locate() in SSevents.control
			if(!florida_event)
				CRASH("hack_console() attempted to run Florida Man, but could not find an event controller!")
			addtimer(CALLBACK(florida_event, /datum/round_event_control.proc/runEvent), rand(20 SECONDS, 1 MINUTES))

		// Triggers pirates, which the crew may be able to pay off to prevent
		if(HACK_PIRATE)
			priority_announce(
				"Attention crew, it appears that someone on your station has made unexpected communication with a Syndicate ship in nearby space.",
				"[command_name()] High-Priority Update"
				)

			var/datum/round_event_control/pirates/pirate_event = locate() in SSevents.control
			if(!pirate_event)
				CRASH("hack_console() attempted to run pirates, but could not find an event controller!")
			addtimer(CALLBACK(pirate_event, /datum/round_event_control.proc/runEvent), rand(20 SECONDS, 1 MINUTES))

		// Triggers fugitives, which can cause confusion / chaos as the crew decides which side help
		if(HACK_FUGITIVES)
			priority_announce(
				"Attention crew, it appears that someone on your station has established an unexpected orbit with an unmarked ship in nearby space.",
				"[command_name()] High-Priority Update"
				)

			var/datum/round_event_control/fugitives/fugitive_event = locate() in SSevents.control
			if(!fugitive_event)
				CRASH("hack_console() attempted to run fugitives, but could not find an event controller!")
			addtimer(CALLBACK(fugitive_event, /datum/round_event_control.proc/runEvent), rand(20 SECONDS, 1 MINUTES))

		if(HACK_THREAT) // Adds a flat amount of threat to buy a (probably) more dangerous antag later
			priority_announce(
				"Attention crew, it appears that someone on your station has shifted your orbit into more dangerous territory.",
				"[command_name()] High-Priority Update"
				)

			for(var/mob/crew_member as anything in GLOB.player_list)
				if(!is_station_level(crew_member.z))
					continue
				shake_camera(crew_member, 15, 1)

			var/datum/game_mode/dynamic/dynamic = SSticker.mode
			if(!dynamic)
				return
			dynamic.create_threat(HACK_THREAT_INJECTION_AMOUNT)
			dynamic.threat_log += "[worldtime2text()]: Communications console hack by [hackerman]. Added [HACK_THREAT_INJECTION_AMOUNT] threat."

		if(HACK_SLEEPER) // Trigger one or multiple sleeper agents with the crew (or for latejoining crew)
			var/datum/dynamic_ruleset/midround/sleeper_agent_type = /datum/dynamic_ruleset/midround/autotraitor
			var/datum/game_mode/dynamic/dynamic = SSticker.mode
			var/max_number_of_sleepers = clamp(round(length(SSticker.mode.current_players[CURRENT_LIVING_PLAYERS]) / 20), 1, 3)
			var/num_agents_created = 0

			if(!dynamic)
				return

			for(var/num_agents in 1 to rand(1, max_number_of_sleepers))
				// Offset the trheat cost of the sleeper agent(s) we're about to run...
				dynamic.create_threat(initial(sleeper_agent_type.cost))
				// ...Then try to actually trigger a sleeper agent.
				if(!dynamic.picking_specific_rule(sleeper_agent_type, TRUE))
					break
				num_agents_created++

			if(num_agents_created <= 0)
				// We failed to run any midround sleeper agents, so let's be patient and run latejoin traitor
				dynamic.picking_specific_rule(/datum/dynamic_ruleset/latejoin/infiltrator, TRUE)

			else
				// We spawned some sleeper agents, nice - give them a report to kickstart the paranoia
				priority_announce(
					"Attention crew, it appears that someone on your station has hijacked your telecommunications and has broadcasted a Syndicate radio signal to your fellow employees.",
					"[command_name()] High-Priority Update"
					)

/datum/comm_message
	var/title
	var/content
	var/list/possible_answers = list()
	var/answered
	var/datum/callback/answer_callback

/datum/comm_message/New(new_title,new_content,new_possible_answers)
	..()
	if(new_title)
		title = new_title
	if(new_content)
		content = new_content
	if(new_possible_answers)
		possible_answers = new_possible_answers

#undef IMPORTANT_ACTION_COOLDOWN
#undef MAX_STATUS_LINE_LENGTH
#undef STATE_BUYING_SHUTTLE
#undef STATE_CHANGING_STATUS
#undef STATE_MESSAGES
#undef HACK_PIRATE
#undef HACK_FUGITIVES
#undef HACK_SLEEPER
#undef HACK_THREAT
#undef HACK_FLORIDA_MAN
#undef MIN_GHOSTS_FOR_FLORIDA_MAN
#undef MIN_GHOSTS_FOR_PIRATES
#undef MIN_GHOSTS_FOR_FUGITIVES
#undef MAX_PERCENT_GHOSTS_FOR_SLEEPER
#undef HACK_THREAT_INJECTION_AMOUNT
