/mob/living/simple_animal/chicken/phoenix
	breed_name = "Phoenix"
	egg_type = /obj/item/food/egg/phoenix
	chicken_path = /mob/living/simple_animal/chicken/phoenix
	mutation_list = list()

/obj/item/food/egg/phoenix
	name = "Burning Egg"
	food_reagents = list()
	max_volume = 5

/mob/living/simple_animal/chicken/phoenix/death()
	GLOB.total_chickens++
	new /obj/effect/decal/cleanable/ash(loc)
	var/obj/item/food/egg/phoenix/rebirth = new /obj/item/food/egg/phoenix(loc)
	rebirth.layer_hen_type = src.chicken_type
	START_PROCESSING(SSobj, rebirth)
	del_on_death = TRUE
	..()
