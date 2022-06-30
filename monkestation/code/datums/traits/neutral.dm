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
	desc = "You are an anime enjoyer! Show your enthusiasm with some fashionable attire."
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

/datum/quirk/gigantism
	name = "Gigantism"
	desc = "You're huge! You start the round with the gigantism mutation. Even works on species without DNA!"
	value = 0

/datum/quirk/gigantism/post_add()
	. = ..()
	if(ishuman(quirk_holder))
		var/mob/living/carbon/human/gojira = quirk_holder
		if(gojira.dna)
			gojira.dna.add_mutation(GIGANTISM)

/datum/quirk/nudist
	name = "Nudist"
	desc = "You managed to get a rare invisible jumpsuit, it stills works as a normal jumpsuit."
	value = 0

/datum/quirk/nudist/on_spawn()
    var/mob/living/carbon/human/person = quirk_holder
    var/obj/item/clothing/under/invisible/clothing = new(get_turf(person))
    var/list/slots = list (
        "backpack" = ITEM_SLOT_BACKPACK,
        "hands" = ITEM_SLOT_HANDS,
    )
    person.equip_in_one_of_slots(clothing , slots , qdel_on_fail = TRUE)
