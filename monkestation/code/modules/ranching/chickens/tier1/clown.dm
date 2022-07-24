/mob/living/simple_animal/chicken/clown
	breed_name_female = "Henk"
	breed_name_male = "Henkster"

	ai_controller = /datum/ai_controller/chicken/clown

	egg_type = /obj/item/food/egg/clown
	mutation_list = list(/datum/ranching/mutation/mime, /datum/ranching/mutation/clown_sad)
	chicken_type = /mob/living/simple_animal/chicken/clown
	minimum_living_happiness = -2000

/obj/item/food/egg/clown
	name = "Clown Egg?"
	food_reagents = list(/datum/reagent/water = 50)
