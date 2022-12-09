/obj/item/organ/liver/alcoholic
	name = "Ol Reliable"
	desc = "A perfect companion for any drinker"

/obj/item/organ/liver/alcoholic/Initialize(mapload)
	. =..()

	AddComponent(/datum/component/abberant_organ, inputs = list(/datum/abberant_organs/input/reagent/alcohol/special), outputs = list(/datum/abberant_organs/output/alcoholic/special))
