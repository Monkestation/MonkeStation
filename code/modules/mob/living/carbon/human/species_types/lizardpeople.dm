/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "\improper Lizardperson"
	id = SPECIES_LIZARD
	bodyflag = FLAG_LIZARD
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,NO_UNDERWEAR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_REPTILE)
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings", "legs")
	mutanttongue = /obj/item/organ/tongue/lizard
	mutanttail = /obj/item/organ/tail/lizard
	default_features = list("mcolor" = "0F0", "tail_lizard" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "body_size" = "Normal")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/food/meat/slab/human/mutant/lizard
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	disliked_food = GRAIN | DAIRY
	liked_food = GROSS | MEAT | NUTS
	inert_mutation = FIREBREATH
	deathsound = 'sound/voice/lizard/deathsound.ogg'
	species_language_holder = /datum/language_holder/lizard
	digitigrade_customization = DIGITIGRADE_OPTIONAL

	species_chest = /obj/item/bodypart/chest/lizard
	species_head = /obj/item/bodypart/head/lizard
	species_l_arm = /obj/item/bodypart/l_arm/lizard
	species_r_arm = /obj/item/bodypart/r_arm/lizard
	species_l_leg = /obj/item/bodypart/l_leg/lizard
	species_r_leg = /obj/item/bodypart/r_leg/lizard

	speedmod = 0.9 //slightly slower by default than humans


	//NOTE: the hot and cold caches are hear exclusively for lag reasons if we get a freeze and things update to fast you will offset your stuff forever this fixes that - Borbop

	//used to handle the difference for adding and subtracting speed
	var/metabolism_cache_cold = 0
	var/metabolism_cache_hot = 0
	//used to handle the difference for adding and subtracting speed
	var/speed_cache = 0
	//used to handle the hunger drain increase or decrease from temperature
	var/hunger_drain_modifier = 1
	var/hunger_drain_cache_hot = 0
	var/hunger_drain_cache_hot = 0



/datum/species/lizard/random_name(gender, unique, lastname, attempts)
	if(gender == MALE)
		. = "[pick(GLOB.lizard_names_male)]-[pick(GLOB.lizard_names_male)]"
	else
		. = "[pick(GLOB.lizard_names_female)]-[pick(GLOB.lizard_names_female)]"

	if(unique && attempts < 10)
		if(findname(.))
			. = .(gender, TRUE, null, ++attempts)

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = "ashlizard"
	examine_limb_id = SPECIES_LIZARD
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS, NO_UNDERWEAR)
	inherent_traits = list(TRAIT_NOGUNS,TRAIT_NOBREATH)
	species_language_holder = /datum/language_holder/lizard/ash
	digitigrade_customization = DIGITIGRADE_FORCED


///this updates the various things needed to have lizards dynamically adjust to their temperature includes: speed, metabolism, and hunger
/datum/species/lizard/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/human_host)
	. = ..()
	//simple if statement checkers to determine what state the temperature of the body is compared to the outside
	if(human_host.bodytemperature > BODYTEMP_NORMAL)
		if(metabolism_cache_cold)
			human_host.metabolism_efficiency += metabolism_cache_cold
			metabolism_cache_cold = 0

		var/metabolism_variable =  round(min(0.5, 1 - ((human_host.bodytemperature / BODYTEMP_NORMAL) * 2)), 0.1)
		human_host.metabolism_efficiency += metabolism_variable - metabolism_cache_hot
		metabolism_cache_hot = metabolism_variable

		var/speed_variable = round(min(0.2, 1 - ((human_host.bodytemperature / BODYTEMP_NORMAL))), 0.01)
		speedmod += speed_variable - speed_cache
		speed_cache = speed_variable

		if(hunger_drain_cache_cold)
			hunger_drain_modifier += hunger_drain_cache_cold
			hunger_drain_cache_cold = 0

		var/hunger_variable = round(min(0.75, (human_host.bodytemperature / BODYTEMP_NORMAL) * 3), 0.01)
		hunger_drain_modifier += hunger_variable - hunger_drain_cache_hot
		hunger_drain_cache_hot = hunger_variable

	else
		if(speed_cache)
			speedmod -= speed_cache
			speed_cache = 0

		if(metabolism_cache_hot)
			human_host.metabolism_efficiency -= metabolism_cache_hot
			metabolism_cache_hot = 0

		var/metabolism_variable =  round(min(0.5, 1 - (T20C / human_host.bodytemperature)), 0.1)
		human_host.metabolism_efficiency -= metabolism_variable - metabolism_cache_cold
		metabolism_cache_cold = metabolism_variable

		if(hunger_drain_cache_hot)
			hunger_drain_modifier -= hunger_drain_cache_hot
			hunger_drain_cache_hot = 0

		var/hunger_variable = round(min(0.75, (human_host.bodytemperature / BODYTEMP_NORMAL) * 3), 0.01)
		hunger_drain_modifier -= hunger_variable - hunger_drain_cache_cold
		hunger_drain_cache_cold = hunger_variable
