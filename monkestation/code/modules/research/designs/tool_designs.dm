/datum/design/rpd_upgrade/unwrench
	name = "RPD unwrenching upgrade"
	desc = "Adds reverse wrench mode to the RPD. Attention, due to budget cuts, the mode is hard linked to the destroy mode control button."
	id = "rpd_upgrade_unwrench"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/rpd_upgrade/unwrench
	category = list("Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rpd_upgrade/amend
	name = "RPD amending upgrade"
	desc = "Adds pipe amending functionality to the RPD. Right-click a pipe with the RPD to activate."
	id = "rpd_upgrade_amend"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/rpd_upgrade/amend
	category = list("Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
