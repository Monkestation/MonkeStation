/mob/living/simple_animal/chicken/clown_sad
	breed_name_male = "huOnkHoNkHoeNK"
	breed_name_female = "huOnkHoNkHoeNK"
	minbodytemp = 0

	ai_controller = /datum/ai_controller/chicken/clown/sad

	egg_type = /obj/item/food/egg/clown_sad
	chicken_type = /mob/living/simple_animal/chicken/clown_sad
	mutation_list = list()

/obj/item/food/egg/clown_sad
	name = "Clown? Egg"

/datum/status_effect/ranching/angry_honk
	id = "pissed_sad_clown"
	duration = 5 SECONDS

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
