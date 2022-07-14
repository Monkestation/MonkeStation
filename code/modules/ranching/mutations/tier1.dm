/datum/ranching/mutation/brown
	chicken_type = /mob/living/simple_animal/chicken/brown
	happiness = 25
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/glass
	chicken_type = /mob/living/simple_animal/chicken/glass
	happiness = 50
	nearby_items = list(/obj/item/reagent_containers/glass/beaker/large, /obj/item/reagent_containers/syringe)

/datum/ranching/mutation/onagadori
	chicken_type = /mob/living/simple_animal/chicken/onagadori
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/ixworth
	chicken_type = /mob/living/simple_animal/chicken/ixworth
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/silkie_white
	chicken_type = /mob/living/simple_animal/chicken/silkie_white
	reagent_requirements = list(/datum/reagent/drug/methamphetamine)
	food_requirements = list(/obj/item/food/apple)
	needed_turfs = list(/turf/open/floor/grass)

/datum/ranching/mutation/silkie_black
	chicken_type = /mob/living/simple_animal/chicken/silkie_black
	needed_turfs = list(/turf/open/floor/grass)
	food_requirements = list(/obj/item/food/apple)
	reagent_requirements = list(/datum/reagent/toxin/chloralhydrate)

/datum/ranching/mutation/silkie
	chicken_type = /mob/living/simple_animal/chicken/silkie
	needed_turfs = list(/turf/open/floor/grass)
	food_requirements = list(/obj/item/food/apple)

/datum/ranching/mutation/void
	chicken_type = /mob/living/simple_animal/chicken/void
	happiness = -50
	reagent_requirements = (/datum/reagent/toxin/bad_food)

/datum/ranching/mutation/clown
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown
	player_job = "Clown"
