/datum/status_effect/food
	duration = 3000
	status_type = STATUS_EFFECT_REPLACE


/datum/status_effect/food/stamina_increase
	id = "t1_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	var/stam_increase = 10

/atom/movable/screen/alert/status_effect/food/stamina_increase_t1
	name = "Tiny Stamina Increase"
	desc = "Increases your stamina by a tiny amount"
	icon_state = "stam_t1"

/datum/status_effect/food/stamina_increase/t2
	id = "t2_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t2
	stam_increase = 20

/atom/movable/screen/alert/status_effect/food/stamina_increase_t2
	name = "Medium Stamina Increase"
	desc = "Increases your stamina by a moderate amount"
	icon_state = "stam_t2"

/datum/status_effect/food/stamina_increase/t3
	id = "t3_stamina"
	alert_type = /atom/movable/screen/alert/status_effect/food/stamina_increase_t3
	stam_increase = 30

/atom/movable/screen/alert/status_effect/food/stamina_increase_t3
	name = "Large Stamina Increase"
	desc = "Increases your stamina greatly"
	icon_state = "stam_t3"

/datum/status_effect/food/stamina_increase/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage += stam_increase
	return ..()

/datum/status_effect/food/stamina_increase/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		for(var/obj/item/bodypart/limbs in user.bodyparts)
			limbs.max_stamina_damage -= stam_increase
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

/datum/status_effect/food/sweaty
	id = "food_sweaty"
	alert_type = /atom/movable/screen/alert/status_effect/food/sweaty
	var/list/sweat = list(/datum/reagent/water = 4, /datum/reagent/sodium = 1.25)
	var/metabolism_increase = 0.5

/atom/movable/screen/alert/status_effect/food/sweaty
	name = "Sweaty"
	desc = "You're feeling rather sweaty"
	icon_state = "food_sweat"

/datum/status_effect/food/sweaty/plus
	id = "food_sweaty_plus"
	alert_type = /atom/movable/screen/alert/status_effect/food/sweaty_plus
	sweat = list(/datum/reagent/lube = 5)

/atom/movable/screen/alert/status_effect/food/sweaty_plus
	name = "Wacky Sweat"
	desc = "You're feeling rather sweaty, and incredibly wacky?"
	icon_state = "food_sweat"

/datum/status_effect/food/sweaty/on_apply()
	if(ishuman(owner))
		owner.metabolism_efficiency += metabolism_increase
	return ..()

/datum/status_effect/food/sweaty/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		owner.metabolism_efficiency -= metabolism_increase
		user.applied_food_buffs --

/datum/status_effect/food/sweaty/tick()
	. = ..()
	if(prob(5))
		var/turf/puddle_location = get_turf(owner)
		puddle_location.add_liquid_list(sweat, FALSE, 300)

/datum/status_effect/food/health_increase
	id = "t1_health"
	alert_type = /atom/movable/screen/alert/status_effect/food/health_increase_t1
	var/health_increase = 10

/atom/movable/screen/alert/status_effect/food/health_increase_t1
	name = "Small Health Increase"
	desc = "You feel slightly heartier"
	icon_state = "food_hp_small"

/datum/status_effect/food/health_increase/t2
	id = "t1_health"
	alert_type = /atom/movable/screen/alert/status_effect/food/health_increase_t2
	health_increase = 25

/atom/movable/screen/alert/status_effect/food/health_increase_t2
	name = "Small Health Increase"
	desc = "You feel heartier"
	icon_state = "food_hp_medium"

/datum/status_effect/food/health_increase/t3
	id = "t1_health"
	alert_type = /atom/movable/screen/alert/status_effect/food/health_increase_t3
	health_increase = 50

/atom/movable/screen/alert/status_effect/food/health_increase_t3
	name = "Large Health Increase"
	desc = "You feel incredibly hearty"
	icon_state = "food_hp_large"

/datum/status_effect/food/health_increase/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		user.maxHealth += health_increase
	return ..()

/datum/status_effect/food/health_increase/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		user.maxHealth -= health_increase
		user.applied_food_buffs --

/datum/status_effect/food/belly_slide
	id = "food_slide"
	alert_type = /atom/movable/screen/alert/status_effect/food/belly_slide
	var/sliding = FALSE

/atom/movable/screen/alert/status_effect/food/belly_slide
	name = "Slippery Belly"
	desc = "You feel like you could slide really fast"
	icon_state = "slippery_belly"

/datum/status_effect/food/belly_slide/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/user = owner
		ADD_TRAIT(user, FOOD_SLIDE, "food_buffs")
	return ..()

/datum/status_effect/food/belly_slide/on_remove()
	if(ishuman(owner))
		REMOVE_TRAIT(owner, FOOD_SLIDE, "food_buffs")
		var/mob/living/carbon/user = owner
		if(owner.has_movespeed_modifier("belly_slide"))
			owner.remove_movespeed_modifier("belly_slide")
		user.applied_food_buffs --
