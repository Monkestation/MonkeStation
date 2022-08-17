/mob/living/simple_animal/hostile/asteroid/golem/diamond
	name = "diamond golem"
	desc = "A moving pile of rocks with diamond specks in it."

	icon_state = "golem_diamond"
	icon_dead = "golem_diamond"

	maxHealth = GOLEM_HEALTH_ULTRA
	health = GOLEM_HEALTH_ULTRA

	melee_damage = GOLEM_DMG_LOW
	obj_damage = GOLEM_DMG_MED

	ore_type = /obj/item/stack/ore/diamond

	var/destroy_cooldown = 0

/mob/living/simple_animal/hostile/asteroid/golem/diamond/Life()
	if((world.time - destroy_cooldown > 1 MINUTES))
		destroy_cooldown = world.time
		DestroyPathToTarget()
