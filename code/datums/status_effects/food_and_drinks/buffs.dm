/datum/status_effect/food/stamina_increase_t1
	id = "t1_stamina"
	duration = 3000
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	status_type = STATUS_EFFECT_REPLACE

/atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	name = "Tiny Stamina Increase"
	desc = "Increases your stamina by a tiny amount"
	icon_state = "shadow_mend" //TEMP

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
