/datum/status_effect/food
	duration = 3000
	status_type = STATUS_EFFECT_REPLACE


/datum/status_effect/food/stamina_increase_t1
	id = "t1_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t1

/atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	name = "Tiny Stamina Increase"
	desc = "Increases your stamina by a tiny amount"
	icon_state = "stam_t1" //TEMP

/datum/status_effect/food/stamina_increase_t1/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage += 15
	return ..()

/datum/status_effect/food/stamina_increase_t1/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage -= 15
		user.applied_food_buffs --

/datum/status_effect/food/stamina_increase_t2
	id = "t2_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t2

/atom/movable/screen/alert/status_effect/food/stamina_increase_t2
	name = "Medium Stamina Increase"
	desc = "Increases your stamina by a moderate amount"
	icon_state = "stam_t2" //TEMP

/datum/status_effect/food/stamina_increase_t2/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage += 15
	return ..()

/datum/status_effect/food/stamina_increase_t2/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage -= 15
		user.applied_food_buffs --

/datum/status_effect/food/stamina_increase_t3
	id = "t3_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t3

/atom/movable/screen/alert/status_effect/food/stamina_increase_t3
	name = "Large Stamina Increase"
	desc = "Increases your stamina greatly"
	icon_state = "stam_t3" //TEMP

/datum/status_effect/food/stamina_increase_t3/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage += 15
	return ..()

/datum/status_effect/food/stamina_increase_t3/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage -= 15
		user.applied_food_buffs --
