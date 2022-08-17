/mob/living/simple_animal/hostile/asteroid/golem/uranium
	name = "uranium golem"
	desc = "A moving pile of rocks with uranium specks in it."

	icon_state = "golem_uranium_idle"

	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	melee_damage = 0
	obj_damage = 0

	retreat_distance = 5

	ore_type = /obj/item/stack/ore/uranium


/mob/living/simple_animal/hostile/asteroid/golem/uranium/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#8AD55D")

/mob/living/simple_animal/hostile/asteroid/golem/uranium/Destroy()
	set_light(0)
	. = ..()

// Special capacity of uranium golem: quickly repair all nearby golems.
/mob/living/simple_animal/hostile/asteroid/golem/uranium/Life()
	if(controller)
		for(var/mob/living/simple_animal/hostile/asteroid/golem/area_golem in view(5, src.loc))
			if(!istype(area_golem, /mob/living/simple_animal/hostile/asteroid/golem/uranium))  // Uraniums do not regen
				area_golem.adjustBruteLoss(-10) // Regeneration
				area_golem.adjustFireLoss(-10)
	. = ..()
