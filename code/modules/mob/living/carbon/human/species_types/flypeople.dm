/datum/species/fly
	name = "\improper Flyperson"
	id = SPECIES_FLY
	bodyflag = FLAG_FLY
	say_mod = "buzzes"
	species_traits = list(NOEYESPRITES, NO_UNDERWEAR, TRAIT_BEEFRIEND)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_BUG)
	mutanttongue = /obj/item/organ/tongue/fly
	mutantliver = /obj/item/organ/liver/fly
	mutantstomach = /obj/item/organ/stomach/fly
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	mutant_bodyparts = list("insect_type")
	default_features = list("insect_type" = "housefly", "body_size" = "Normal")
	burnmod = 1.4
	brutemod = 1.4
	speedmod = 0.7
	disliked_food = null
	liked_food = GROSS | MEAT | RAW | FRUIT
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/fly

	species_chest = /obj/item/bodypart/chest/fly
	species_head = /obj/item/bodypart/head/fly
	species_l_arm = /obj/item/bodypart/l_arm/fly
	species_r_arm = /obj/item/bodypart/r_arm/fly
	species_l_leg = /obj/item/bodypart/l_leg/fly
	species_r_leg = /obj/item/bodypart/r_leg/fly

/datum/species/fly/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 29 //Flyswatters deal 30x damage to flypeople.
	return 0

/obj/item/organ/stomach/fly/on_life()
	for(var/bile in reagents.reagent_list)
		if(!istype(bile, /datum/reagent/consumable))
			continue
		var/datum/reagent/consumable/chunk = bile
		if(chunk.nutriment_factor <= 0)
			continue
		var/mob/living/carbon/body = owner
		var/turf/pos = get_turf(owner)
		body.vomit(reagents.total_volume, FALSE, FALSE, 2, TRUE)
		playsound(pos, 'sound/effects/splat.ogg', 50, TRUE)
		body.visible_message("<span class='danger'>[body] vomits on the floor!</span>", \
					"<span class='userdanger'>You throw up on the floor!</span>")
	return ..()
