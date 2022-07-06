/datum/status_effect/food
	duration = 3000
	status_type = STATUS_EFFECT_REPLACE


/datum/status_effect/food/stamina_increase_t1
	id = "t1_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t1

/atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	name = "Tiny Stamina Increase"
	desc = "Increases your stamina by a tiny amount"
	icon_state = "stam_t1"

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
	icon_state = "stam_t2"

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
	icon_state = "stam_t3"

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

/datum/status_effect/food/resistance
	id = "resistance_food"
	alert_type = /atom/movable/screen/alert/status_effect/food/resistance

/atom/movable/screen/alert/status_effect/food/resistance
	name = "Damage resistance"
	desc = "Slightly decreases damage you take"
	icon_state = "resistance"

/datum/status_effect/food/resistance/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.brute_reduction += 3
	return ..()

/datum/status_effect/food/resistance/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.brute_reduction -= 3
		user.applied_food_buffs --

/datum/status_effect/food/fire_burps
	id = "fire_food"
	alert_type = /atom/movable/screen/alert/status_effect/food/fire_burps
	var/range = 4
	var/duration_loss = 250

/atom/movable/screen/alert/status_effect/food/fire_burps
	name = "Firey Burps"
	desc = "Lets you burp out a line of fire"
	icon_state = "resistance"

/datum/status_effect/food/fire_burps/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		ADD_TRAIT(user, TRAIT_FOOD_FIRE_BURPS, "food_buffs")
	return ..()

/datum/status_effect/food/fire_burps/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		REMOVE_TRAIT(user, TRAIT_FOOD_FIRE_BURPS, "food_buffs")
		user.applied_food_buffs --

/datum/status_effect/food/fire_burps/proc/Burp()
	var/turf/turfs = get_step(owner,owner.dir)
	var/range_check = 1
	while((get_dist(owner, turfs) < range) && (range_check < 20))
		turfs = get_step(turfs, owner.dir)
		range_check ++
	var/list/affected_turfs = getline(owner, turfs)

	//var/turf/current_turf
	//var/turf/last_turf
	for(var/turf/checking in affected_turfs)
		//last_turf = current_turf
		//current_turf = checking
		if(checking.density || istype(checking, /turf/open/space))
			break
		if(checking == get_turf(owner))
			continue
		if(get_dist(owner, checking) > range)
			continue
		create_fire(checking)

	src.duration -= min(duration_loss, src.duration)
	if(src.duration <= 0)
		if(src.owner)
			src.owner.remove_status_effect(STATUS_EFFECT_FOOD_FIREBURPS)

/datum/status_effect/food/fire_burps/proc/create_fire(turf/exposed)
	if(isplatingturf(exposed))
		var/turf/open/floor/plating/exposed_floor = exposed
		if(prob(10 + exposed_floor.burnt + 5*exposed_floor.broken)) //broken or burnt plating is more susceptible to being destroyed
			exposed_floor.ex_act(EXPLODE_DEVASTATE)
	if(isfloorturf(exposed))
		var/turf/open/floor/exposed_floor = exposed
		if(prob(10))
			exposed_floor.make_plating()
		else if(prob(10))
			exposed_floor.burn_tile()
		if(isfloorturf(exposed_floor))
			for(var/turf/open/turf in RANGE_TURFS(1,exposed_floor))
				if(!locate(/obj/effect/hotspot) in turf)
					new /obj/effect/hotspot(exposed_floor)
	if(iswallturf(exposed))
		var/turf/closed/wall/exposed_wall = exposed
		if(prob(10))
			exposed_wall.ex_act(EXPLODE_DEVASTATE)
