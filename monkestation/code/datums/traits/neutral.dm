/datum/quirk/bald
	name = "Bald"
	desc = "Your hair seems to have gone missing. Luckily, you will spawn with a wig."
	value = 0

/datum/quirk/bald/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/head/wig/W = new
	W.hair_color = "#[H.hair_color]"
	W.hair_style = H.hair_style
	log_world(H.hair_color)
	log_world(H.hair_style)
	H.equip_to_slot_if_possible(W, ITEM_SLOT_BACKPACK)
	W.update_icon()
	H.dna.species.go_bald(H)

/datum/quirk/anime
	name = "Anime"
	desc = "You are an anime enjoyer! You start the round with an Anime Dermal Implant kit, \
	which can be used to give yourself a skin-deep modification to make you look like a cat."
	mob_trait = TRAIT_ANIME
	value = 0

/datum/quirk/anime/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/choice_beacon/anime/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)

/datum/quirk/controlled_prosthetic
	name = "Controlled Prosthetic"
	desc = "You start the round with a Prosthetic Replacement kit, which will allow you to \
	quickly replace a limb you choose with a prosthetic or robotic replacement."
	mob_trait = TRAIT_CONT_PROSTHETIC
	value = 0

/datum/quirk/controlled_prosthetic/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/choice_beacon/prosthetic/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)
