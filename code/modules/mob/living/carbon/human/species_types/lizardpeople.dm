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

	speedmod = 0.1 //slightly slower by default than humans

	base_body_temperature = BODYTEMP_NORMAL_LIZARD


	//NOTE: the hot and cold caches are hear exclusively for lag reasons if we get a freeze and things update to fast you will offset your stuff forever this fixes that - Borbop

	//used to handle the difference for adding and subtracting speed
	var/metabolism_cache_cold = 0
	var/metabolism_cache_hot = 0
	//used to handle the difference for adding and subtracting speed
	var/speed_cache = 0
	//used to handle the hunger drain increase or decrease from temperature
	var/hunger_drain_modifier = 1
	var/hunger_drain_cache_hot = 0
	var/hunger_drain_cache_cold = 0



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
	if(human_host.bodytemperature > BODYTEMP_NORMAL_LIZARD)
		if(metabolism_cache_cold)
			human_host.metabolism_efficiency += metabolism_cache_cold
			metabolism_cache_cold = 0

		var/metabolism_variable =  round(min(0.5, (1 - (BODYTEMP_NORMAL_LIZARD / human_host.bodytemperature )) * 3), 0.1)
		human_host.metabolism_efficiency += metabolism_variable - metabolism_cache_hot
		metabolism_cache_hot = metabolism_variable

		var/speed_variable = round(min(0.15, (1 - (BODYTEMP_NORMAL_LIZARD / human_host.bodytemperature)) * 1.25 ), 0.01) //this round can be changed if we want them to update less or more
		if(speed_variable != speed_cache)
			speedmod -= speed_variable - speed_cache
			speed_cache = speed_variable
			update_species_speed_mod(human_host)

		if(hunger_drain_cache_cold)
			hunger_drain_modifier += hunger_drain_cache_cold
			hunger_drain_cache_cold = 0

		var/hunger_variable = round(min(0.75, (human_host.bodytemperature / BODYTEMP_NORMAL_LIZARD) * 3), 0.01)
		hunger_drain_modifier += hunger_variable - hunger_drain_cache_hot
		hunger_drain_cache_hot = hunger_variable

	else
		if(speed_cache)
			speedmod += speed_cache
			speed_cache = 0
			update_species_speed_mod(human_host)

		if(metabolism_cache_hot)
			human_host.metabolism_efficiency -= metabolism_cache_hot
			metabolism_cache_hot = 0

		var/metabolism_variable =  round(min(0.5, 1 - (BODYTEMP_NORMAL_LIZARD / human_host.bodytemperature)), 0.1)
		human_host.metabolism_efficiency -= metabolism_variable - metabolism_cache_cold
		metabolism_cache_cold = metabolism_variable

		if(hunger_drain_cache_hot)
			hunger_drain_modifier -= hunger_drain_cache_hot
			hunger_drain_cache_hot = 0

		var/hunger_variable = round(min(0.75, (BODYTEMP_NORMAL_LIZARD / human_host.bodytemperature) * 2), 0.01)
		hunger_drain_modifier -= hunger_variable - hunger_drain_cache_cold
		hunger_drain_cache_cold = hunger_variable

/datum/species/lizard/on_species_gain(mob/living/carbon/human_host, datum/species/old_species, pref_load)
	. = ..()
	human_host.AddSpell(new /obj/effect/proc_holder/spell/self/tail_sweep)
	human_host.AddSpell(new /obj/effect/proc_holder/spell/self/molt)
/datum/species/lizard/on_species_loss(mob/living/carbon/human/human_host, datum/species/new_species, pref_load)
	. = ..()
	human_host.RemoveSpell(/obj/effect/proc_holder/spell/self/tail_sweep)
	human_host.RemoveSpell(/obj/effect/proc_holder/spell/self/molt)

/////ABILITIES

/obj/effect/proc_holder/spell/self/tail_sweep
	name = "Tail Sweep"
	desc = "Sweep nearby creatures back and potentially on their asses"
	charge_max = 2 MINUTES
	clothes_req = FALSE
	invocation_type = "none"

	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_background_icon_state = "bg_hive"
	action_icon_state = "scan"
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/tail_sweep/cast(mob/living/carbon/human/user)
	if(islizard(user))
		if(user.getorgan(/obj/item/organ/tail/lizard))
			visible_message(span_notice("[user.name] launches everyone around them back!"))
			for(var/mob/living/target in range(1, user.loc))
				var/throwing_range = 2

				if(user.dna.check_mutation(HULK))
					throwing_range = 5

				var/throw_dir = get_dir(user,target)
				var/turf/throw_at = get_ranged_target_turf(target, throw_dir, throwing_range)
				target.throw_at(throw_at, throw_range, 3)
		else
			to_chat(user, "You swing around sadly, hitting nothing.")

		user.adjustStaminaLoss(30)
		user.emote("spin")


/obj/effect/proc_holder/spell/self/molt
	name = "Molt"
	desc = "Shed your outter most layer of scales, leaving behind a hollow husk of you with all your clothing still attached"
	charge_max = 5 MINUTES
	clothes_req = FALSE
	invocation_type = "none"

	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_background_icon_state = "bg_hive"
	action_icon_state = "scan"
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/molt/cast(mob/living/carbon/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/human_caster = user
		var/list/list_of_items = list()
		list_of_items |= user.get_equipped_items()
		list_of_items |= user.held_items

		user.apply_status_effect(/datum/status_effect/vulnerable)

		var/mob/living/carbon/human/molt/shedded_you = new /mob/living/carbon/human/molt(human_caster.loc)

		shedded_you.hardset_dna(human_caster.dna.uni_identity, human_caster.dna.mutation_index, human_caster.name, null, human_caster.dna.species, human_caster.dna.features)

		for(var/obj/object in list_of_items)
			object.forceMove(shedded_you.loc)
			shedded_you.equip_to_appropriate_slot(object)

		shedded_you.desc = "The husk of [human_caster.name]'s shedded scales"

/mob/living/carbon/human/molt
	maxHealth = 1

/mob/living/carbon/human/molt/attack_hand(mob/user)
	. = ..()
	visible_message(span_notice("[src.name] crumbles to dust."))
	unequip_everything()
	qdel(src)

/mob/living/carbon/human/molt/bullet_act(obj/item/projectile/P, def_zone, piercing_hit)
	. = ..()
	visible_message(span_notice("[src.name] crumbles to dust."))
	unequip_everything()
	qdel(src)

/mob/living/carbon/human/molt/attackby(obj/item/I, mob/user, params)
	. = ..()
	visible_message(span_notice("[src.name] crumbles to dust."))
	unequip_everything()
	qdel(src)


/datum/status_effect/vulnerable
	id = "vulnerable"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	examine_text = "<span class='warning'>You are exteremly vulnerable without your scales.</span>"
	alert_type = /atom/movable/screen/alert/status_effect/trance

/datum/status_effect/vulnerable/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/vulnerable_human = owner
		vulnerable_human.physiology.brute_mod += 1.5

/datum/status_effect/vulnerable/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/vulnerable_human = owner
		vulnerable_human.physiology.brute_mod -= 1.5
