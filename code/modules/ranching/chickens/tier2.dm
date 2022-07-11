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

/mob/living/simple_animal/chicken/cotton_candy/Life()
	.=..()
	if(prob(0.2))
		visible_message("<span class='warning'>[src] starts to shake seems like they are gonna have a sugar rush!</span>")
		sleep(3)
		src.apply_status_effect(HEN_RUSH)

/obj/item/food/egg/cotton_candy
	name = "Sugary Egg"

/obj/item/food/egg/cotton_candy/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(SUGAR_RUSH)


/datum/status_effect/ranching/hen_rush
	id = "hen_rush"
	duration = 10 SECONDS

/datum/status_effect/ranching/sugar_rush/on_apply()
	owner.add_movespeed_modifier("sugar_rush", update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))
	owner.Move()
	owner.Move()
	owner.Move()
	return ..()

/datum/status_effect/ranching/sugar_rush/on_remove()
	owner.remove_movespeed_modifier("sugar_rush")

/datum/status_effect/ranching/sugar_rush
	id = "sugar_rush"
	duration = 30 SECONDS
	tick_interval = 1 SECONDS

/datum/status_effect/ranching/sugar_rush/on_apply()
	owner.add_movespeed_modifier("sugar_rush", update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))
	return ..()

/datum/status_effect/ranching/sugar_rush/tick()
	var/datum/reagents/owners_reagents = owner.reagents
	if(owners_reagents)
		owners_reagents.add_reagent(/datum/reagent/consumable/sugar, 2)

/datum/status_effect/ranching/sugar_rush/on_remove()
	owner.remove_movespeed_modifier("sugar_rush")


/mob/living/simple_animal/chicken/snowy
	breed_name = "Snow"
	egg_type = /obj/item/food/egg/snowy
	chicken_path = /mob/living/simple_animal/chicken/snowy
	minbodytemp = 0
	maxbodytemp = 40

/obj/item/food/egg/snowy
	name = "Snowy Egg"


/obj/item/food/egg/snowy/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(SNOWY_EGG)

/datum/status_effect/ranching/snowy
	id = "snowy_egg"
	duration = 30 SECONDS
	tick_interval = 2 SECONDS
	var/base_alpha
	var/base_color
	var/old_temp

/datum/status_effect/ranching/snowy/on_apply()
	old_temp = owner.bodytemperature
	owner.bodytemperature = TCMB
	base_alpha = owner.alpha
	owner.alpha = 155
	base_color = owner.color
	owner.color = "#018eb9"
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/create_ice)
	return ..()

/datum/status_effect/ranching/snowy/tick()
	owner.bodytemperature = TCMB

/datum/status_effect/ranching/snowy/proc/create_ice()
	var/turf/open/owners_location = owner.loc
	if(owners_location)
		owners_location.MakeSlippery(TURF_WET_PERMAFROST, min_wet_time = 10, wet_time_to_add = 5)

/datum/status_effect/ranching/snowy/on_remove()
	owner.bodytemperature = old_temp
	owner.alpha = base_alpha
	owner.color = base_color
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
