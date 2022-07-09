/mob/living/simple_animal/chicken/phoenix
	breed_name = "Phoenix"
	egg_type = /obj/item/food/egg/phoenix
	chicken_path = /mob/living/simple_animal/chicken/phoenix
	mutation_list = list()

/mob/living/simple_animal/chicken/phoenix/death()
	GLOB.total_chickens++
	new /obj/effect/decal/cleanable/ash(loc)
	var/obj/item/food/egg/phoenix/rebirth = new /obj/item/food/egg/phoenix(loc)
	rebirth.layer_hen_type = src.chicken_type
	START_PROCESSING(SSobj, rebirth)
	del_on_death = TRUE
	..()

/obj/item/food/egg/phoenix
	name = "Burning Egg"

/obj/item/food/egg/phoenix/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(/datum/status_effect/ranching/phoneix)


/datum/status_effect/ranching/phoneix
	id = "ranching_phoenix"
	duration = 60 SECONDS
	tick_interval = 1 SECONDS
	var/healing_timer = 0

/datum/status_effect/ranching/phoneix/tick()
	if(ishuman(owner))
		var/mob/living/carbon/human/user = owner
		if(healing_timer < 9)
			healing_timer ++
			user.adjustBruteLoss(-10)
			user.adjustFireLoss(-10)
			user.adjustToxLoss(-10)

