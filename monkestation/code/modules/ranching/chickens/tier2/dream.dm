/mob/living/simple_animal/chicken/dream
	breed_name = "Dream"
	egg_type = /obj/item/food/egg/dream
	chicken_type = /mob/living/simple_animal/chicken/dream
	mutation_list = list()

/obj/item/food/egg/dream
	name = "Dream Egg"

/obj/item/food/egg/dream/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(DREAM_STATE)

/datum/status_effect/ranching/dream_state
	id = "dream_state"
	duration = 60 SECONDS

/datum/status_effect/ranching/dream_state/on_apply()
	owner.visible_message("<span class='notice'>[owner] goes into a deep sleep!</span>")
	owner.fakedeath("dream_state") //play dead
	owner.update_stat()
	owner.update_mobility()
	return ..()

/datum/status_effect/ranching/dream_state/on_remove()
	owner.visible_message("<span class='notice'>[owner] awakes from their deep sleep!</span>")
	owner.cure_fakedeath("dream_state")
	owner.adjustBruteLoss(-100)
	owner.adjustFireLoss(-100)
	owner.adjustToxLoss(-100)
	owner.adjustCloneLoss(-100)
	owner.regenerate_organs()
