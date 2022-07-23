#define inflict_suffering 60 SECONDS
/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad
	breed_name_male = "huOnkHoNkHoeNK"
	breed_name_female = "huOnkHoNkHoeNK"
	minbodytemp = 0
	retaliates = FALSE

	egg_type = /obj/item/food/egg/clown_sad
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown_sad
	mutation_list = list()
	var/mob/living/carbon/human/fuck_this_dude
	COOLDOWN_DECLARE(misery)
	var/invalid_area_typecache = list(/area/space, /area/lavaland, /area/centcom, /area/shuttle/syndicate)
	var/turf/old_loc = null

/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad/Initialize(mapload)
	. = ..()
	var/list/pick_holders = list()
	for(var/mob/living/carbon/human/pickee in GLOB.player_list)
		var/area/pickee_area = get_area(src.loc)
		if(!is_type_in_typecache(pickee_area, invalid_area_typecache))
			pick_holders |= pickee
	if(pick_holders.len)
		fuck_this_dude = pick(pick_holders)

/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad/Life()
	.=..()
	if(COOLDOWN_FINISHED(src, misery) && fuck_this_dude)
		if(!old_loc)
			old_loc = src.loc
		var/atom/target_from = GET_TARGETS_FROM(src)
		if(isturf(target_from.loc) && fuck_this_dude.Adjacent(target_from))
			switch(rand(1,100))
				if(0 to 50)
					fuck_this_dude.slip(50)
					emote("cries")
					COOLDOWN_START(src, misery, inflict_suffering)
					return

				if(51 to 100)
					var/obj/item/food/pie/cream/pie_time = new /obj/item/food/pie/cream()

					pie_time.throw_at(fuck_this_dude, 10 , 3, src, TRUE)
					emote("cries")
					COOLDOWN_START(src, misery, inflict_suffering)
					return
		else

			if(prob(10))
				apply_status_effect(ANGRY_HONK_SPEED)
			Goto(fuck_this_dude, 2, 1)
			return
	else
		if(prob(10))
			apply_status_effect(ANGRY_HONK_SPEED)
		Goto(old_loc, 1 , 1)

#undef inflict_suffering

/obj/item/food/egg/clown_sad
	name = "Clown? Egg"

/datum/status_effect/ranching/angry_honk
	id = "pissed_sad_clown"
	duration = 3 SECONDS

/datum/status_effect/ranching/angry_honk/on_apply()
	owner.pass_flags |= PASSMOB
	owner.pass_flags |= PASSDOORS
	owner.pass_flags |= PASSGRILLE
	owner.pass_flags |= PASSGLASS
	owner.pass_flags |= PASSCLOSEDTURF
	return ..()

/datum/status_effect/ranching/angry_honk/on_remove()
	owner.pass_flags -= PASSMOB
	owner.pass_flags -= PASSDOORS
	owner.pass_flags -= PASSGRILLE
	owner.pass_flags -= PASSGLASS
	owner.pass_flags -= PASSCLOSEDTURF
