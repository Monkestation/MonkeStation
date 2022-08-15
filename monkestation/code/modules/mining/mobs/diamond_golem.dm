/mob/living/simple_animal/hostile/golem/diamond
	name = "diamond golem"
	desc = "A moving pile of rocks with diamond specks in it."

	icon_state = "golem_diamond"

	maxHealth = 300
	health = 300

	melee_damage = 8
	obj_damage = 8

	ore_type = /obj/item/stack/ore/diamond

	var/destroy_cooldown = 0

/mob/living/simple_animal/hostile/golem/diamond/Life()
	if((world.time - destroy_cooldown > 1 MINUTES))
		destroy_cooldown = world.time
		DestroyPathToTarget()
