/datum/ranching/mutation/phoenix
	chicken_type = /mob/living/simple_animal/chicken/phoenix
	required_rooster = /mob/living/simple_animal/chicken/onagadori

/datum/ranching/mutation/dreamsicle
	chicken_type = /mob/living/simple_animal/chicken/dreamsicle
	required_rooster = /mob/living/simple_animal/chicken/snowy

/datum/ranching/mutation/cockatrice
	chicken_type = /mob/living/simple_animal/chicken/hostile/cockatrice
	food_requirements = list(/obj/item/food/meat/slab/chicken)
	nearby_items = list(/obj/item/organ/tail/lizard) //This will probably rarely ever be done lol

/datum/ranching/mutation/robot
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/robot
	reagent_requirements = list(/datum/reagent/iron, /datum/reagent/uranium) /// lol emp attacks
	nearby_items = list(/obj/item/organ/cyberimp/chest/nutriment)
	happiness = 45
