/mob/living/simple_animal/chicken/dreamsicle
	breed_name = "Dreamsicle"
	egg_type = /obj/item/food/egg/dreamsicle
	chicken_path = /mob/living/simple_animal/chicken/dreamsicle
	mutation_list = list()

/obj/item/food/egg/dreamsicle
	name = "Dreamsicle Egg"
	icon_state = "dreamsicle"

/obj/item/food/egg/dreamsicle/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	to_chat(eater, "<span class='warning'>You start to feel a dreamsicle high coming on.</span>")
	eater.apply_status_effect(SNOWY_EGG)
	eater.apply_status_effect(SUGAR_RUSH)
