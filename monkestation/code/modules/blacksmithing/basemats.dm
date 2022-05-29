//Place for all the material datums used because we overwrite alot of strength modifers also we add a few more variables ourselfs to these bad boys for future use like armours, blunt weapons, wealth, the sort

/atom/proc/set_smithing_vars(var/list/materials)
	for(var/material in materials)
		var/datum/material/custom_material = material
		custom_material.transfer_smithing_vars(src)

/datum/material/proc/transfer_smithing_vars(obj/item/smithing/Object)
	Object.blunt_mult = blunt_strength
	Object.sharp_mult = sharp_strength
	Object.wealth_mult = wealth_bonus

/datum/material //all new variables declared here
	//these are multipliers to quality for bonus don't go overboard
	var/blunt_strength = 1
	var/sharp_strength = 1
	var/wealth_bonus = 1
	var/fail_multipler = 1

	var/weight = 1 //default weight 1 unit is 1 pound

/datum/material/iron
	wealth_bonus = 0.75
	blunt_strength = 0.75
	sharp_strength = 0.75
	fail_multipler = 0.5

/datum/material/glass
	wealth_bonus = 1.25
	fail_multipler = 2.25

/datum/material/silver
	wealth_bonus = 1.5
	sharp_strength = 0.5
	blunt_strength = 1.1

/datum/material/gold
	wealth_bonus = 3
	fail_multipler = 2
	blunt_strength = 0.45
	sharp_strength = 1.1

/datum/material/diamond
	wealth_bonus = 3.25
	blunt_strength = 1.1
	sharp_strength = 0.75

/datum/material/uranium
	wealth_bonus = 0.25


/datum/material/plasma
	blunt_strength = 0.7
	sharp_strength = 0.7
	wealth_bonus = 1.5
	fail_multipler = 2

/datum/material/bluespace
	blunt_strength = 0.2
	sharp_strength = 0.2
	wealth_bonus = 8
	fail_multipler = 4

/datum/material/bananium
	blunt_strength = 0.3
	sharp_strength = 0.5

/datum/material/titanium
	blunt_strength = 1.25
	sharp_strength = 1.25


/datum/material/plastic
	blunt_strength = 0
	sharp_strength = 0

/datum/material/biomass

/datum/material/copper
	wealth_bonus = 0.7
	blunt_strength = 1.12
	sharp_strength = 0.65

/datum/material/adamantine
	name = "adamantine"
	desc = "A powerful material made out of magic, I mean science!"
	color = "#6d7e8e"
	strength_modifier = 1.3
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/adamantine
	wealth_bonus = 10
	blunt_strength = 1.5
	sharp_strength = 1.5
	weight = 2


/datum/material/runedmetal
	name = "runed metal"
	desc = "Mir'ntrath barhah Nar'sie."
	color = "#3C3434"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	strength_modifier = 1.2
	sharp_strength = 1.2
	blunt_strength = 1.2
	sheet_type = /obj/item/stack/sheet/runed_metal

/datum/material/bronze
	name = "bronze"
	desc = "Clock Cult? Never heard of it."
	color = "#92661A"
	strength_modifier = 1.1
	sharp_strength = 1.1
	blunt_strength = 1.1
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	sheet_type = /obj/item/stack/tile/bronze
