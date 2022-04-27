/obj/item/organ/tail/monkey
	name = "monkey tail"
	desc = "A severed monkey tail. If found, please call 1-800-OOK-EEEK"
	color = "#5f4637" //for debugging
	tail_type = "Chimp"
	mutant_bodypart_name = list("tail_human")

/obj/item/organ/tail/monkey/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!("tail_monkey" in H.dna.species.mutant_bodyparts))
			H.dna.features["tail_monkey"] = tail_type
			H.dna.species.mutant_bodyparts |= "tail_monkey"
		H.update_body()

/obj/item/organ/tail/monkey/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_monkey"
		tail_type = H.dna.features["tail_monkey"]
		H.update_body()

/obj/item/organ/tail/fox
	name = "fox tail"
	desc = "If you collect seven, you are considered lucky!"
	tail_type = "Fox"
	mutant_bodypart_name = list("tail_human")
	wagging_mutant_name = list("waggingtail_human")

/obj/item/organ/tail/wolf
	name = "wolf tail"
	desc = "There are two wolfs inside you.  One of them is an otaku, the other, a furry."
	tail_type = "Wolf"
	mutant_bodypart_name = list("tail_human")
	wagging_mutant_name = list("waggingtail_human")

/obj/item/organ/tail/shark
	name = "fox tail"
	desc = "A"
	tail_type = "Shark"
	mutant_bodypart_name = list("tail_human")
	wagging_mutant_name = list("waggingtail_human")

/obj/item/organ/tail/alien
	name = "alien tail"
	desc = "oh no, where did THIS come from?"
	tail_type = "Xeno"
	mutant_bodypart_name = list("tail_human")


