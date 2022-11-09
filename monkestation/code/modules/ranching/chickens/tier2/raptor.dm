/mob/living/simple_animal/chicken/raptor
	icon_suffix = "raptor"

	breed_name = "Raptor"
	breed_name_male = "Tiercel"
	egg_type = /obj/item/food/egg/raptor
	chicken_path = /mob/living/simple_animal/chicken/raptor
	mutation_list = list(/datum/mutation/ranching/chicken/rev_raptor)
	ai_controller = /datum/ai_controller/chicken/hostile
	health = 100
	maxHealth = 100
	melee_damage = 8
	obj_damage = 10

/obj/item/food/egg/raptor
	name = "Raptor Egg"
	icon_state = "raptor"
