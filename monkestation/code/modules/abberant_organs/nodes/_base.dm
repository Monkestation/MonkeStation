/datum/abberant_organs
	var/name = ""
	var/desc = ""
	///the purity of the node
	var/node_purity = 100
	///the tier of the node
	var/tier = 1
	///is it a special node?
	var/is_special = FALSE
	///the slot this takes up
	var/slot = INPUT_NODE

	///the pull weight for when scramble or randomly selecting the base nodes happens
	var/pull_weight = 15


	///the attached objects related to a carbon
	var/mob/living/carbon/hosted_carbon
	var/obj/item/organ/attached_organ

	///a special node that interacts with either the input or output
	var/datum/abberant_organs/special/attached_special

	var/ui_icon = "soap"
	var/stability_cost = 10 //this is a placeholder until i get some math for purity/tier increasing

/datum/abberant_organs/proc/setup()
	return

/datum/abberant_organs/proc/get_node_data()
	return list(
		"name" = name,
		"icon" = ui_icon,
		"desc" = desc,
		"stability" = stability_cost,
		"purity" = node_purity,
		"tier" = tier,
		"ref" = REF(src),
		"active" = check_active())

/datum/abberant_organs/proc/check_active()
	return

/datum/abberant_organs/proc/set_values(node_purity, tier)
	src.node_purity = node_purity
	src.tier = tier
