/datum/station_trait/announcement_duke
	name = "Announcement Duke"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 10
	show_in_report = TRUE
	report_message = "The Duke himself is your announcer today."
	blacklist = list(/datum/station_trait/announcement_medbot,
	/datum/station_trait/announcement_baystation,
	/datum/station_trait/announcement_intern
	)

/datum/station_trait/announcement_duke/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/duke

/datum/station_trait/new_space_law
	name = "New Space Law"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 10
	show_in_report = TRUE
	report_message = "A recent bet at Central Command has led to a new space law being created. A report on it will be printed at all security record consoles."

/datum/station_trait/new_space_law/on_round_start()
	var/new_space_law = pick(world.file2list("monkestation/strings/new_space_laws.txt"))
	priority_announce("Due to recent events in space politics [new_space_law] now 1xx illegal under space law.")
	for(var/obj/machinery/computer/secure_data/console in GLOB.machines)
		if(!(console.machine_stat & (BROKEN|NOPOWER)) && is_station_level(console.z))
			var/obj/item/paper/law_print = new /obj/item/paper(console.loc)
			law_print.name = "paper - 'New Space Law'"
			law_print.info = "Due to recent events in space politics [new_space_law] now 1xx illegal under space law."
			law_print.update_icon()
