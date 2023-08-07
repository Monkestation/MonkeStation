/datum/ore_patch
	var/ore_type
	var/ore_quantity_lower
	var/ore_quantity_upper
	var/ore_color
	var/overlay_state

/datum/ore_patch/proc/spawn_at(turf/T)
	var/i = 0
	var/amt = rand(ore_quantity_lower,ore_quantity_upper)
	for(i = 0; i < amt; i++)
		new ore_type(T)
/datum/ore_patch/iron
	ore_type = /obj/item/stack/ore/iron
	ore_quantity_upper = 5
	ore_quantity_lower = 1
	ore_color = "#878687"
	overlay_state = "rock_Iron"

/datum/ore_patch/plasma
	ore_type = /obj/item/stack/ore/plasma
	ore_quantity_upper = 3
	ore_quantity_lower = 1
	ore_color = "#c716b8"
	overlay_state = "rock_Plasma"

/datum/ore_patch/uranium
	ore_type = /obj/item/stack/ore/uranium
	ore_quantity_upper = 3
	ore_quantity_lower = 1
	ore_color = "#1fb83b"
	overlay_state = "rock_Uranium"

/datum/ore_patch/titanium
	ore_type = /obj/item/stack/ore/titanium
	ore_quantity_upper = 4
	ore_quantity_lower = 1
	ore_color = "#b3c0c7"
	overlay_state = "rock_Titanium"

/datum/ore_patch/gold
	ore_type = /obj/item/stack/ore/gold
	ore_quantity_upper = 3
	ore_quantity_lower = 1
	ore_color = "#f0972b"
	overlay_state = "rock_Gold"

/datum/ore_patch/silver
	ore_type = /obj/item/stack/ore/silver
	ore_quantity_upper = 4
	ore_quantity_lower = 1
	ore_color = "#bdbebf"
	overlay_state = "rock_Silver"

/datum/ore_patch/diamond
	ore_type = /obj/item/stack/ore/diamond
	ore_quantity_upper = 2
	ore_quantity_lower = 1
	ore_color = "#22c2d4"
	overlay_state = "rock_Diamond"

/datum/ore_patch/bluespace
	ore_type = /obj/item/stack/ore/bluespace_crystal
	ore_quantity_upper = 2
	ore_quantity_lower = 1
	ore_color = "#506bc7"
	overlay_state = "rock_BScrystal"

/datum/ore_patch/dilithium
	ore_type = /obj/item/stack/ore/dilithium_crystal
	ore_quantity_upper = 2
	ore_quantity_lower = 1
	ore_color = "#bd50c7"
	overlay_state = "rock_Dilithium"

/datum/ore_patch/sand
	ore_type = /obj/item/stack/ore/glass/basalt
	ore_quantity_upper = 10
	ore_quantity_lower = 2
	ore_color = "#2d2a2d"
	overlay_state = "rock_Dilithium"
