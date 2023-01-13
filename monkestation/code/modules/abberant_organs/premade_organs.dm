/obj/item/organ/liver/alcoholic
	name = "Ol Reliable"
	desc = "A perfect companion for any drinker"
	can_synth = FALSE

/obj/item/organ/liver/alcoholic/Initialize(mapload)
	. =..()

	AddComponent(/datum/component/abberant_organ, inputs = list(/datum/abberant_organs/input/reagent/alcohol/special), outputs = list(/datum/abberant_organs/output/alcoholic/special))

/obj/item/organ/liver/plague_liver
	name = "Plague Liver"
	desc = "Filled to the brim with nodes to extract. Debug Item!"
	can_synth = FALSE

/obj/item/organ/liver/plague_liver/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_gene, pull_from_tiers_weighted(10))
