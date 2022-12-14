/datum/tree_node/minor/random_stat_increase
	name = "Plant Improvement"
	desc = "Improves nearby plants on pulse."

	min_level = 3
	on_pulse = TRUE

	var/stat_to_increase

/datum/tree_node/minor/random_stat_increase/on_choice_generation()
	stat_to_increase = pick("potency", "yield", "lifespan", "maturation rate", "weed rate", "weed vulnerabilty", "production speed")
	desc = "Improves the [stat_to_increase] of nearby plants on pulse."

/datum/tree_node/minor/random_stat_increase/on_pulse(list/affected_plants, pulse_range)
	return

