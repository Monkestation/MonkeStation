/mob/living/simple_animal/chicken/glass
	breed_name = "Glass"
	egg_type = /obj/item/food/egg/glass
	chicken_path = /mob/living/simple_animal/chicken/glass
	mutation_list = list()

/obj/item/food/egg/glass
	name = "Glass Egg"
	food_reagents = list()
	max_volume = 5

/mob/living/simple_animal/chicken/brown
	breed_name = "Brown"
	egg_type = /obj/item/food/egg/brown
	chicken_path = /mob/living/simple_animal/chicken/brown
	mutation_list = list(/datum/ranching/mutation/spicy, /datum/ranching/mutation/raptor)

/obj/item/food/egg/brown
	name = "Brown Egg"

/mob/living/simple_animal/chicken/onagadori
	breed_name = "Onagadori"
	egg_type = /obj/item/food/egg/onagadori
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/onagadori

/obj/item/food/egg/onagadori
	name = "Onagadori Egg"

/mob/living/simple_animal/chicken/ixworth
	breed_name = "Ixworth"
	egg_type = /obj/item/food/egg/ixworth
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/ixworth

/obj/item/food/egg/ixworth
	name = "Ixworth Egg"

/mob/living/simple_animal/chicken/silkie_white
	breed_name = "White Silkie"
	egg_type = /obj/item/food/egg/silkie_white
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/silkie_white

/obj/item/food/egg/silkie_white
	name = "White Selkie Egg"

/mob/living/simple_animal/chicken/silkie_black
	breed_name = "Black Selkie"
	egg_type = /obj/item/food/egg/silkie_black
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/silkie_black

/obj/item/food/egg/silkie_black
	name = "Black Selkie Egg"

/mob/living/simple_animal/chicken/silkie
	breed_name = "Selkie"
	egg_type = /obj/item/food/egg/silkie
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/silkie

/obj/item/food/egg/silkie
	name = "Selkie Egg"

/mob/living/simple_animal/chicken/void
	breed_name = "Void"
	egg_type = /obj/item/food/egg/void
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/void

/obj/item/food/egg/void
	name = "Void Egg"

/obj/item/food/egg/void/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(/datum/status_effect/ranching/void_egg)

/datum/status_effect/ranching/void_egg
	id="void_ranching"
	duration = 10 SECONDS
	var/has_passdoor = 0
	var/has_passgrille = 0
	var/has_passglass = 0
	var/has_passmob = 0

/datum/status_effect/ranching/void_egg/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/user = owner
		for(var/flag in owner.pass_flags)
			if(flag == PASSDOORS)
				has_passdoor = 1
			if(flag == PASSGRILLE)
				has_passgrille = 1
			if(flag == PASSGLASS)
				has_passglass = 1
			if(flag == PASSMOB)
				has_passmob = 1

		if(!has_passmob)
			owner.pass_flags |= PASSMOB
		if(!has_passdoor)
			owner.pass_flags |= PASSDOORS
		if(!has_passgrille)
			owner.pass_flags |= PASSGRILLE
		if(!has_passglass)
			owner.pass_flags |= PASSGLASS

		user.physiology.brute_mod *= 2
		user.physiology.burn_mod *= 2
		user.transform = user.transform.Scale(0.5, 0.5)
	return ..()

/datum/status_effect/ranching/void_egg/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/user = owner
		if(!has_passmob)
			owner.pass_flags -= PASSMOB
		if(!has_passdoor)
			owner.pass_flags -= PASSDOORS
		if(!has_passgrille)
			owner.pass_flags -= PASSGRILLE
		if(!has_passglass)
			owner.pass_flags -= PASSGLASS

		user.physiology.brute_mod *= 0.5
		user.physiology.burn_mod *= 0.5
		user.transform = user.transform.Scale(2, 2)

/mob/living/simple_animal/chicken/clown
	breed_name_female = "Henk"
	breed_name_male = "Henkster"
	egg_type = /obj/item/food/egg/clown
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/clown

/obj/item/food/egg/clown
	name = "Clown Egg?"
	food_reagents = list(/datum/reagent/water = 50)
