/datum/abberant_organs
	var/name = ""
	var/desc = ""
	var/node_purity = 100
	var/tier = 1
	var/is_special = FALSE
	var/slot = INPUT_NODE

	var/mob/living/carbon/hosted_carbon
	var/obj/item/organ/attached_organ

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
