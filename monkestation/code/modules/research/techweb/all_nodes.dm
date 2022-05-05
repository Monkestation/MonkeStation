/datum/techweb_node/circuitresearch
	id = "circuitresearch"
	display_name = "Circuit Research"
	description = "Modular circuitry adaptable to a wide range of utilities."
	prereq_ids = list("datatheory")
	design_ids = list("icprinter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000

/datum/techweb_node/circuitupgrades
	id = "circuitupgrades"
	display_name = "Advanced Circuit Research"
	description = "Advanced designs that expand the possibilities of modular circuits."
	prereq_ids = list("circuitresearch")
	design_ids = list("icupgadv", "icupgclo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	export_price = 5000
