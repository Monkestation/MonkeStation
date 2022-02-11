/datum/station_trait/announcement_duke
	name = "Announcement Duke"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 200 //TEMPORARY NUMBER, CHANGE ME LATER
	show_in_report = TRUE
	report_message = "The Duke himself is your announcer today."
	blacklist = list(/datum/station_trait/announcement_medbot,
	/datum/station_trait/announcement_baystation,
	/datum/station_trait/announcement_intern
	)

/datum/station_trait/announcement_duke/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/duke
