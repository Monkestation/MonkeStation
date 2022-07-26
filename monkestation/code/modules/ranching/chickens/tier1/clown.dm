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

/obj/item/food/egg/clown/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //was it caught by a mob?
		var/turf/epicenter = get_turf(hit_atom)
		if(istype(epicenter, /turf/closed))
			epicenter = get_step_towards(epicenter, throwingdatum.thrower)
		create_reagents(1000)
		reagents.add_reagent_list(food_reagents)
		epicenter.add_liquid_from_reagents(src.reagents)
