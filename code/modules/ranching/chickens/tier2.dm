/mob/living/simple_animal/chicken/spicy
	breed_name = "Spicy"
	egg_type = /obj/item/food/egg/spicy
	chicken_path = /mob/living/simple_animal/chicken/spicy
	mutation_list = list(/datum/ranching/mutation/phoenix)

/obj/item/food/egg/spicy
	name = "Spicy Egg"

/mob/living/simple_animal/chicken/hostile/raptor
	breed_name = "Raptor"
	breed_name_male = "Tiercel"
	egg_type = /obj/item/food/egg/raptor
	chicken_path = /mob/living/simple_animal/chicken/hostile/raptor

/obj/item/food/egg/raptor
	name = "Raptor Egg"

/mob/living/simple_animal/chicken/cotton_candy
	breed_name = "Cotton Candy"
	egg_type = /obj/item/food/egg/cotton_candy
	chicken_path = /mob/living/simple_animal/chicken/cotton_candy
	mutation_list = list()

/obj/item/food/egg/cotton_candy
	name = "Sugary Egg"

/obj/item/food/egg/cotton_candy/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(/datum/status_effect/ranching/sugar_rush)

/datum/status_effect/ranching/sugar_rush
	id = "sugar_rush"
	duration = 10 SECONDS
	tick_interval = 1

/datum/status_effect/ranching/sugar_rush/on_apply()
	return ..()

/datum/status_effect/ranching/sugar_rush/tick()
	owner.Move(get_step(owner.loc, owner.dir))
	owner.Move(get_step(owner.loc, owner.dir))
