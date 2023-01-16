/mob/living/simple_animal/chicken/golden
	icon_suffix = "gold"

	breed_name = "Golden"
	egg_type = /obj/item/food/egg/golden

/obj/item/food/egg/golden
	name = "Golden Egg"
	icon_state = "golden"

/obj/item/food/egg/golden/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	. = ..()
	eater.apply_status_effect(GOLD_SPARKLE)

/datum/status_effect/ranching/gold_egg
	id = "sparkly_egg"
	duration = 10 MINUTES


/datum/status_effect/ranching/gold_egg/on_apply()
	var/mutable_appearance/sparkle = mutable_appearance('icons/effects/effects.dmi')
	sparkle.icon_state = "blessed"
	owner.add_overlay(sparkle)
	return ..()

/datum/status_effect/ranching/gold_egg/on_remove()
	var/mutable_appearance/sparkle = mutable_appearance('icons/effects/effects.dmi')
	sparkle.icon_state = "blessed"
	owner.cut_overlay(sparkle)
