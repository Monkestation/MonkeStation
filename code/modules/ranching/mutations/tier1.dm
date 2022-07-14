/datum/ranching/mutation/brown
	chicken_type = /mob/living/simple_animal/chicken/brown
	egg_type = /obj/item/food/egg/brown
	happiness = 25
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/glass
	chicken_type = /mob/living/simple_animal/chicken/glass
	egg_type = /obj/item/food/egg/glass
	happiness = 50
	nearby_items = list(/obj/item/reagent_containers/glass/beaker/large, /obj/item/reagent_containers/syringe)

/datum/ranching/mutation/onagadori
	chicken_type = /mob/living/simple_animal/chicken/onagadori
	egg_type = /obj/item/food/egg/onagadori
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/ixworth
	chicken_type = /mob/living/simple_animal/chicken/ixworth
	egg_type = /obj/item/food/egg/ixworth
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/silkie_white
	chicken_type = /mob/living/simple_animal/chicken/silkie_white
	egg_type = /obj/item/food/egg/silkie_white
	reagent_requirements = list(/datum/reagent/drug/methamphetamine)
	food_requirements = list(/obj/item/food/grown/apple)
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/silkie_black
	chicken_type = /mob/living/simple_animal/chicken/silkie_black
	egg_type = /obj/item/food/egg/silkie_black
	needed_turfs = list(/turf/open/floor/grass)
	food_requirements = list(/obj/item/food/grown/apple)
	reagent_requirements = list(/datum/reagent/toxin/chloralhydrate)

/datum/ranching/mutation/silkie
	chicken_type = /mob/living/simple_animal/chicken/silkie
	egg_type = /obj/item/food/egg/silkie
	needed_turfs = list(/turf/open/floor/grass)
	food_requirements = list(/obj/item/food/grown/apple)

/datum/ranching/mutation/void
	chicken_type = /mob/living/simple_animal/chicken/void
	egg_type = /obj/item/food/egg/void
	happiness = -50
	reagent_requirements = (/datum/reagent/toxin/bad_food)

/datum/ranching/mutation/clown
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown
	egg_type = /obj/item/food/egg/clown
	player_job = "Clown"
