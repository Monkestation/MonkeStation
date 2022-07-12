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

/mob/living/simple_animal/chicken/dreamsicle
	breed_name = "Dreamsicle"
	egg_type = /obj/item/food/egg/dreamsicle
	chicken_path = /mob/living/simple_animal/chicken/dreamsicle
	mutation_list = list()

/obj/item/food/egg/dreamsicle
	name = "Dreamsicle Egg"

/obj/item/food/egg/dreamsicle/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	to_chat(eater, "<span class='warning'>You start to feel a dreamsicle high coming on.</span>")
	eater.apply_status_effect(SNOWY_EGG)
	eater.apply_status_effect(SUGAR_RUSH)



/mob/living/simple_animal/chicken/hostile/cockatrice
	breed_name_male = "Cockatrice"
	breed_name_female = "Cockatrice"

	hostile = FALSE

	ranged = TRUE
	projectiletype = /obj/item/projectile/magic/venomous_spit
	ranged_cooldown_time = 45 SECONDS

	chicken_type = /mob/living/simple_animal/chicken/hostile/cockatrice
	egg_type = /obj/item/food/egg/cockatrice

/obj/item/food/egg/cockatrice
	name = "Petrifying Egg"

/obj/item/food/egg/cockatrice/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	. = ..()
	eater.apply_status_effect(PETRIFICATION_SPIT)

/datum/status_effect/ranching/cockatrice_eaten
	id= "cockatrice_egg"
	duration = 60 SECONDS
	var/obj/effect/proc_holder/spell/power = /obj/effect/proc_holder/spell/aimed/venomous_spit

/datum/status_effect/ranching/cockatrice_eaten/on_apply()
	power = new power()
	power.action_background_icon_state = "bg_tech_blue_on"
	power.panel = "Spell"
	owner.AddSpell(power)
	return ..()

/datum/status_effect/ranching/cockatrice_eaten/on_remove()
	owner.RemoveSpell(power)

/obj/effect/proc_holder/spell/aimed/venomous_spit
	name = "Venomous Spit"
	desc = "You Spit petrifying venom at your opponents."

	clothes_req = FALSE
	range = 20
	charge_max = 30 SECONDS
	action_icon_state = "charge"

	base_icon_state = "projectile"
	active_icon_state = "projectile"

	projectile_amount = 1
	projectile_type = /obj/item/projectile/magic/venomous_spit

/mob/living/simple_animal/chicken/hostile/cockatrice/Initialize(mapload)
	. = ..()
	if(gender == MALE)
		hostile = TRUE

/obj/item/ammo_casing/venomous_spit
	projectile_type = /obj/item/projectile/magic/venomous_spit

/obj/item/projectile/magic/venomous_spit
	name = "venomous spit"
	icon_state = "ion"
	damage = 5
	damage_type = BURN

/obj/item/projectile/magic/venomous_spit/on_hit(atom/target, blocked)
	if(iscarbon(target))
		var/mob/living/carbon/user = target
		user.petrify(10)

/mob/living/simple_animal/chicken/hostile/retaliate/robot
	breed_name = "Robotic"

	maxHealth = 100 //Weaker because emp good
	obj_damage = 1
	melee_damage = 4

	egg_type = /obj/item/food/egg/robot
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/robot

/mob/living/simple_animal/chicken/hostile/retaliate/robot/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_HOSTILE_ATTACKINGTARGET, .proc/emp_burst)

/mob/living/simple_animal/chicken/hostile/retaliate/robot/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_HOSTILE_ATTACKINGTARGET)

/mob/living/simple_animal/chicken/hostile/retaliate/robot/proc/emp_burst(target)
	var/turf/location = get_turf(target)
	empulse(location, 1, 2, 0)

/obj/item/food/egg/robot
	name = "Robotic Egg"

/obj/item/food/egg/robot/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	. = ..()
	var/turf/location = get_turf(eater)
	empulse(location, 5, 7, 1)
