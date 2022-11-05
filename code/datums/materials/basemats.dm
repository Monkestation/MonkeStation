///Has no special properties.
/datum/material/iron
	name = "iron"
	id = "iron"
	desc = "Common iron ore often found in sedimentary and igneous layers of the crust."
	color = "#878687"
	greyscale_colors = "#878687"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/iron
	value_per_unit = 0.0025

/datum/material/iron/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
	return TRUE

///Breaks extremely easily but is transparent.
/datum/material/glass
	name = "glass"
	id = "glass"
	desc = "Glass forged by melting sand."
	color = "#dae6f0"
	greyscale_colors = "#dae6f0"
	alpha = 150
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	integrity_modifier = 0.1
	sheet_type = /obj/item/stack/sheet/glass
	value_per_unit = 0.0025

/datum/material/glass/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(10, BRUTE, BODY_ZONE_HEAD) //cronch
	return TRUE

///Has no special properties. Could be good against vampires in the future perhaps.
/datum/material/silver
	name = "silver"
	id = "silver"
	desc = "Silver"
	color = "#bdbebf"
	greyscale_colors = "#bdbebf"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/silver
	value_per_unit = 0.025

/datum/material/silver/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
	return TRUE

///Slight force increase
/datum/material/gold
	name = "gold"
	id = "gold"
	desc = "Gold"
	color = "#f0972b"
	greyscale_colors = "#f0972b"
	strength_modifier = 1.2
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/gold
	value_per_unit = 0.0625

/datum/material/gold/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
	return TRUE

///Has no special properties
/datum/material/diamond
	name = "diamond"
	id = "diamond"
	desc = "Highly pressurized carbon"
	color = "#22c2d4"
	greyscale_colors = "#22c2d4"
	alpha = 150
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/diamond
	value_per_unit = 0.25

/datum/material/diamond/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(15, BRUTE, BODY_ZONE_HEAD)
	return TRUE

///Is slightly radioactive
/datum/material/uranium
	name = "uranium"
	id = "uranium"
	desc = "Uranium"
	color = "#1fb83b"
	greyscale_colors = "#1fb83b"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/uranium
	value_per_unit = 0.05

/datum/material/uranium/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/uranium, rand(4, 6))
	S?.reagents?.add_reagent(/datum/reagent/uranium, S.reagents.total_volume*(2/5))
	return TRUE

/datum/material/uranium/on_applied(atom/source, amount, material_flags)
	. = ..()
	source.AddComponent(/datum/component/radioactive, amount / 10, source, 0) //half-life of 0 because we keep on going.

/datum/material/uranium/on_removed(atom/source, material_flags)
	. = ..()
	qdel(source.GetComponent(/datum/component/radioactive))


///Adds firestacks on hit (Still needs support to turn into gas on destruction)
/datum/material/plasma
	name = "plasma"
	id = "plasma"
	desc = "Isn't plasma a state of matter? Oh whatever."
	color = "#c716b8"
	greyscale_colors = "#c716b8"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/plasma
	value_per_unit = 0.1

/datum/material/plasma/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/toxin/plasma, rand(6, 8))
	S?.reagents?.add_reagent(/datum/reagent/toxin/plasma, S.reagents.total_volume*(2/5))
	return TRUE

/datum/material/plasma/on_applied(atom/source, amount, material_flags)
	. = ..()
	if(ismovableatom(source))
		source.AddElement(/datum/element/firestacker, amount=1)
		source.AddComponent(/datum/component/explodable, 0, 0, amount / 1000, amount / 500)

/datum/material/plasma/on_removed(atom/source, material_flags)
	. = ..()
	source.RemoveElement(/datum/element/firestacker, amount=1)
	qdel(source.GetComponent(/datum/component/explodable))

///Can cause bluespace effects on use. (Teleportation) (Not yet implemented)
/datum/material/bluespace
	name = "bluespace crystal"
	id = "bluespace_crystal"
	desc = "Crystals with bluespace properties"
	color = "#506bc7"
	greyscale_colors = "#506bc7"
	categories = list(MAT_CATEGORY_ORE = TRUE)
	sheet_type = /obj/item/stack/sheet/bluespace_crystal
	value_per_unit = 0.15

/datum/material/bluespace/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/bluespace, rand(5, 8))
	S?.reagents?.add_reagent(/datum/reagent/bluespace, S.reagents.total_volume*(2/5))
	return TRUE

///Honks and slips
/datum/material/bananium
	name = "bananium"
	id = "bananium"
	desc = "Material with hilarious properties"
	color = "#fff263"
	greyscale_colors = "#fff263"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/bananium
	value_per_unit = 0.0125

/datum/material/bananium/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/consumable/banana, rand(8, 12))
	S?.reagents?.add_reagent(/datum/reagent/consumable/banana, S.reagents.total_volume*(2/5))
	return TRUE

/datum/material/bananium/on_applied(atom/source, amount, material_flags)
	. = ..()
	source.LoadComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 50)
	source.AddComponent(/datum/component/slippery, min(amount / 10, 80))

/datum/material/bananium/on_removed(atom/source, amount, material_flags)
	. = ..()
	qdel(source.GetComponent(/datum/component/slippery))
	qdel(source.GetComponent(/datum/component/squeak))


///Mediocre force increase
/datum/material/titanium
	name = "titanium"
	id = "titanium"
	desc = "Titanium"
	color = "#b3c0c7"
	greyscale_colors = "#b3c0c7"
	strength_modifier = 1.3
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	value_per_unit = 0.0625

/datum/material/titanium/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(15, BRUTE, BODY_ZONE_HEAD)
	return TRUE

///Force decrease
/datum/material/plastic
	name = "plastic"
	id = "plastic"
	desc = "plastic"
	color = "#caccd9"
	greyscale_colors = "#caccd9"
	strength_modifier = 0.85
	sheet_type = /obj/item/stack/sheet/plastic
	value_per_unit = 0.0125

/datum/material/plastic/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.adjust_disgust(17)
	return TRUE

///Force decrease and mushy sound effect. (Not yet implemented)
/datum/material/biomass
	name = "biomass"
	id = "biomass"
	desc = "Organic matter"
	color = "#735b4d"
	greyscale_colors = "#735b4d"
	strength_modifier = 0.8
	value_per_unit = 0.0125
/datum/material/copper
	name = "copper"
	id = "copper"
	desc = "Copper is a soft, malleable, and ductile metal with very high thermal and electrical conductivity."
	color = "#d95802"
	greyscale_colors = "#d95802"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/copper
	value_per_unit = 0.025

///Stronk force increase
/datum/material/adamantine
	name = "adamantine"
	id = "adamantine"
	desc = "A powerful material made out of magic, I mean science!"
	color = "#6d7e8e"
	strength_modifier = 1.5
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/adamantine
	value_per_unit = 0.25

/datum/material/adamantine/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.apply_damage(20, BRUTE, BODY_ZONE_HEAD)
	return TRUE

//I don't like sand. It's coarse, and rough, and irritating, and it gets everywhere.
/datum/material/sand
	name = "sand"
	id = "sand"
	desc = "You know, it's amazing just how structurally sound sand can be."
	color = "#EDC9AF"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/sandblock
	value_per_unit = 0.001
	strength_modifier = 0.5
	integrity_modifier = 0.1
	turf_sound_override = FOOTSTEP_SAND
	texture_layer_icon_state = "sand"

/datum/material/sand/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.adjust_disgust(17)
	return TRUE

//And now for our lavaland dwelling friends, sand, but in stone form! Truly revolutionary.
/datum/material/sandstone
	name = "sandstone"
	id = "sandstone"
	desc = "Bialtaakid 'ant taerif ma hdha."
	color = "#B77D31"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/sandstone
	value_per_unit = 0.0025
	turf_sound_override = FOOTSTEP_WOOD
	texture_layer_icon_state = "brick"

/datum/material/snow
	name = "snow"
	id = "snow"
	desc = "There's no business like snow business."
	color = "#FFFFFF"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/snow
	value_per_unit = 0.0025
	turf_sound_override = FOOTSTEP_SAND
	texture_layer_icon_state = "sand"

/datum/material/snow/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/water, rand(5, 10))
	return TRUE

/datum/material/runedmetal
	name = "runed metal"
	id = "runed metal"
	desc = "Mir'ntrath barhah Nar'sie."
	color = "#3C3434"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/runed_metal
	value_per_unit = 0.75
	texture_layer_icon_state = "runed"

/datum/material/runedmetal/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	M.reagents.add_reagent(/datum/reagent/fuel/unholywater, rand(8, 12))
	M.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
	return TRUE

/datum/material/bronze
	name = "bronze"
	id = "bronze"
	desc = "Clock Cult? Never heard of it."
	color = "#92661A"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/tile/bronze
	value_per_unit = 0.025

/datum/material/paper
	name = "paper"
	id = "paper"
	desc = "Ten thousand folds of pure starchy power."
	color = "#E5DCD5"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/paperframes
	value_per_unit = 0.0025
	turf_sound_override = FOOTSTEP_SAND
	texture_layer_icon_state = "paper"

/datum/material/paper/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/paper = source
		paper.resistance_flags |= FLAMMABLE
		paper.obj_flags |= UNIQUE_RENAME

/datum/material/paper/on_removed_obj(obj/source, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/paper = source
		paper.resistance_flags &= ~FLAMMABLE
	return ..()

/datum/material/cardboard
	name = "cardboard"
	id = "cardboard"
	desc = "They say cardboard is used by hobos to make incredible things."
	color = "#5F625C"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/cardboard
	value_per_unit = 0.003

/datum/material/cardboard/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/cardboard = source
		cardboard.resistance_flags |= FLAMMABLE
		cardboard.obj_flags |= UNIQUE_RENAME

/datum/material/cardboard/on_removed_obj(obj/source, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/cardboard = source
		cardboard.resistance_flags &= ~FLAMMABLE
	return ..()

/datum/material/bone
	name = "bone"
	id = "bone"
	desc = "Man, building with this will make you the coolest caveman on the block."
	color = "#e3dac9"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/bone
	value_per_unit = 0.05

/datum/material/bamboo
	name = "bamboo"
	id = "bamboo"
	desc = "If it's good enough for pandas, it's good enough for you."
	color = "#339933"
	categories = list(MAT_CATEGORY_RIGID = TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/bamboo
	value_per_unit = 0.0025
	turf_sound_override = FOOTSTEP_WOOD
	texture_layer_icon_state = "bamboo"
