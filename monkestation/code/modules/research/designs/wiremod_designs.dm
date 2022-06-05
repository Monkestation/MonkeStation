/datum/design/component/security_record
	name = "Security Record"
	id = "comp_sec"
	build_path = /obj/item/circuit_component/sec_status
	category = list(WIREMOD_CIRCUITRY, WIREMOD_INPUT_COMPONENTS)

/datum/design/circuit_goggles_shell
	name = "Circuit Goggles Shell"
	desc = "A wearable shell."
	id = "circuit_goggles_shell"
	build_path = /obj/item/clothing/glasses/circuit
	materials = list(/datum/material/glass = 3000, /datum/material/iron = 5000)
	build_type = PROTOLATHE | COMPONENT_PRINTER
	category = list(WIREMOD_CIRCUITRY, WIREMOD_SHELLS)
