/mob/living/simple_animal/hostile/golem/uranium
	name = "uranium golem"
	desc = "A moving pile of rocks with uranium specks in it."

	icon_state = "golem_uranium_idle"

	maxHealth = 150
	health = 150

	melee_damage = 0
	obj_damage = 0

	retreat_distance = 5

	ore_type = /obj/item/stack/ore/uranium


/mob/living/simple_animal/hostile/golem/uranium/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#8AD55D")

/mob/living/simple_animal/hostile/golem/uranium/Destroy()
	set_light(0)
	. = ..()

// Special capacity of uranium golem: quickly repair all nearby golems.
/mob/living/simple_animal/hostile/golem/uranium/Life()
	for(var/mob/living/simple_animal/hostile/golem/area_golem in view(5, src.loc))
		if(!istype(area_golem, /mob/living/simple_animal/hostile/golem/uranium))  // Uraniums do not regen
			area_golem.adjustBruteLoss(-10) // Regeneration
			area_golem.adjustFireLoss(-10)
	. = ..()
