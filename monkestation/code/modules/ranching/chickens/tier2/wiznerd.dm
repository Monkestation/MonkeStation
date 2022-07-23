/mob/living/simple_animal/chicken/hostile/retaliate/wiznerd //No matter what you say Zanden this is staying as wiznerd
	maxHealth = 150
	melee_damage = 7
	obj_damage = 5

	breed_name_female = "Witchen"
	breed_name_male = "Wizter"
	egg_type = /obj/item/food/egg/wiznerd
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/wiznerd
	mutation_list = list()

	ranged = TRUE
	projectiletype = /obj/item/projectile/magic/magic_missle_weak
	ranged_cooldown = 10 SECONDS

/obj/item/food/egg/wiznerd
	name = "Bewitching Egg"

/obj/item/food/egg/wiznerd/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(WIZNERD_EGG)

/datum/status_effect/ranching/wiznerd
	id = "wiznerd_egg"
	duration = 60 SECONDS
	var/obj/effect/proc_holder/spell/power = /obj/effect/proc_holder/spell/aimed/magic_missle_weak

/datum/status_effect/ranching/wiznerd/on_apply()
	power = new power()
	power.action_background_icon_state = "bg_tech_blue_on"
	power.panel = "Spell"
	owner.AddSpell(power)
	return ..()

/datum/status_effect/ranching/wiznerd/on_remove()
	owner.RemoveSpell(power)

/obj/effect/proc_holder/spell/aimed/magic_missle_weak
	name = "Magic Missle"
	desc = "This spell launches a barrage of missles at the target dealing moderate damage."

	clothes_req = FALSE
	range = 20
	charge_max = 20 SECONDS
	action_icon_state = "charge"

	base_icon_state = "projectile"
	active_icon_state = "projectile"

	projectile_amount = 3
	projectile_type = /obj/item/projectile/magic/magic_missle_weak

/obj/item/ammo_casing/magic/magic_missle_weak
	projectile_type = /obj/item/projectile/magic/magic_missle_weak

/obj/item/projectile/magic/magic_missle_weak
	name = "magic missile"
	icon_state = "ion"
	damage = 5
	damage_type = BRUTE
