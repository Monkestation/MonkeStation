/datum/round_event_control/new_space_law
	name = "New Space Law"
	typepath = /datum/round_event/new_space_law
	max_occurrences = 1
	weight = 15

/datum/round_event/new_space_law
	announceWhen = 1

var/list/newlaw = list("alcohol is",
					   "the color red is",
					   "the color green is",
					   "the color blue is",
					   "the color orange is",
					   "the color purple is",
					   "grey is",
					   "airlocks not leading to space are",
					   "dorms are",
					   "religion is",
					   "atheism is",
					   "inactivity is",
					   "lack of proper hygiene is",
					   "hats are",
					   "upper floor tiles are",
					   "windows are",
					   "COINTAINED CHIMPS are",
					   "UNCONTAINED ASSISTANTS are",
					   "free stuff is",
					   "clowns without AA are",
					   "non hardsuit outerwere is.",
					   "having a butt is",
					   "non sentient bots are")


/datum/round_event/new_space_law/announce(fake)
	priority_announce("Due to recent events in space politics [pick(newlaw)] now 1xx illegal.")
