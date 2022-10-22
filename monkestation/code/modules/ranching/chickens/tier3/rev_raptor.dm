/mob/living/simple_animal/chicken/rev_raptor
	icon_suffix = "rev_raptor"

	breed_name = "Revolutionary Raptor"
	breed_name_male = "Revolutionary Tiercel"
	egg_type = /obj/item/food/egg/raptor
	chicken_path = /mob/living/simple_animal/chicken/rev_raptor

	ai_controller = /datum/ai_controller/chicken/hostile/rev
	health = 150
	maxHealth = 100
	melee_damage = 6
	obj_damage = 10

	gold_core_spawnable = FALSE


/obj/item/food/egg/rev_raptor
	name = "Revolutionary Egg"
	icon_state = "rev_raptor"
