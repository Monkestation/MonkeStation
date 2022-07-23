#define CLOWNIN_COOLDOWN 10 SECONDS
/mob/living/simple_animal/chicken/hostile/retaliate/clown
	breed_name_female = "Henk"
	breed_name_male = "Henkster"
	egg_type = /obj/item/food/egg/clown
	mutation_list = list(/datum/ranching/mutation/mime, /datum/ranching/mutation/clown_sad)
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown
	retaliates = FALSE
	minimum_living_happiness = -2000
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

/mob/living/simple_animal/chicken/hostile/retaliate/clown/death(gibbed)
	. = ..()
	clownin_target = null

/mob/living/simple_animal/chicken/hostile/retaliate/clown/Destroy()
	. = ..()
	clownin_target = null

#undef CLOWNIN_COOLDOWN

/obj/item/food/egg/clown
	name = "Clown Egg?"
	food_reagents = list(/datum/reagent/water = 50)
