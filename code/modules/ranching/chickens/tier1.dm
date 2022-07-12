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

#define CLOWNIN_COOLDOWN 10 SECONDS
/mob/living/simple_animal/chicken/hostile/retaliate/clown
	breed_name_female = "Henk"
	breed_name_male = "Henkster"
	egg_type = /obj/item/food/egg/clown
	mutation_list = list()
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown
	COOLDOWN_DECLARE(clownin_time)
	var/mob/living/clownin_target = null
	var/turf/old_loc


/mob/living/simple_animal/chicken/hostile/retaliate/clown/Life()
	.=..()
	if(prob(5) && !clownin_target)
		var/list/people_list = list()
		for(var/mob/living/carbon/human/user in oview(10, src))
			people_list |= user
		clownin_target = pick(people_list)
		if(!old_loc)
			old_loc = get_turf(src.loc)


	else if(clownin_target && COOLDOWN_FINISHED(src, clownin_time))
		var/atom/target_from = GET_TARGETS_FROM(src)
		if(isturf(target_from.loc) && clownin_target.Adjacent(target_from))
			clownin_target.slip(20)
			clownin_target = null
			say("HENK")
			playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
			COOLDOWN_START(src, clownin_time, CLOWNIN_COOLDOWN)
			return
		else
			Goto(clownin_target, 3, 1)
			return

	else if(old_loc)
		if(!src.Adjacent(old_loc))
			Goto(old_loc, 3, 1)
		else
			old_loc = null

#undef CLOWNIN_COOLDOWN

/obj/item/food/egg/clown
	name = "Clown Egg?"
	food_reagents = list(/datum/reagent/water = 50)
