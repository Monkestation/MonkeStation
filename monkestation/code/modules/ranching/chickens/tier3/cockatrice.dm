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
