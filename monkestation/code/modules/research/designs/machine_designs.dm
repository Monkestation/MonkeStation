/datum/design/board/bountypad
	name = "Machine Design (Civilian Bounty Pad)"
	desc = "The circuit board for a Civilian Bounty Pad."
	id = "bounty_pad"
	build_type = PROTOLATHE | IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/copper = 300)
	build_path = /obj/item/circuitboard/machine/bountypad
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO
