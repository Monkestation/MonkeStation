/datum/mutation/ranching/chicken/phoenix
	chicken_type = /mob/living/simple_animal/chicken/phoenix
	egg_type = /obj/item/food/egg/phoenix
	required_rooster = /mob/living/simple_animal/chicken/onagadori

/datum/mutation/ranching/chicken/dreamsicle
	chicken_type = /mob/living/simple_animal/chicken/dreamsicle
	egg_type = /obj/item/food/egg/dreamsicle
	required_rooster = /mob/living/simple_animal/chicken/snowy

/datum/mutation/ranching/chicken/cockatrice
	chicken_type = /mob/living/simple_animal/chicken/cockatrice
	egg_type = /obj/item/food/egg/cockatrice
	food_requirements = list(/obj/item/food/meat/slab/chicken)
	nearby_items = list(/obj/item/organ/tail/lizard) //This will probably rarely ever be done lol

/datum/mutation/ranching/chicken/robot
	chicken_type = /mob/living/simple_animal/chicken/robot
	egg_type = /obj/item/food/egg/robot
	reagent_requirements = list(/datum/reagent/iron, /datum/reagent/uranium) /// lol emp attacks
	nearby_items = list(/obj/item/organ/cyberimp/chest/nutriment)
	happiness = 45

/datum/mutation/ranching/chicken/rev_raptor
	chicken_type = /mob/living/simple_animal/chicken/rev_raptor
	egg_type = /obj/item/food/egg/rev_raptor
	reagent_requirements = list(/datum/reagent/consumable/ethanol/cuba_libre)
	nearby_items = list(/obj/item/assembly/flash/handheld)
