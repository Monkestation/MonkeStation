/mob/living/simple_animal/hostile/monkedome_fauna/walker_snake
	name = "walker snake"
	icon = 'monkestation/icons/mob/monkedome/monkedome_monsters.dmi'
	icon_state = "walker_snake"
	icon_living = "walker_snake"
	icon_dead = "walker_snake_dead"

	ranged = TRUE
	projectiletype = /obj/item/projectile/walker_snake_rock

	health = 35
	maxHealth = 35

	melee_damage = 3
	obj_damage = 15

	faction = list("dome","hostile")

	ranged_message = "hurls a rock at"
	ranged_cooldown_time = 5 SECONDS
	retreat_distance = 2
	minimum_distance = 3

	check_friendly_fire = TRUE

	move_to_delay = 0.3 SECONDS

//Projectile

/obj/item/projectile/walker_snake_rock
	name = "rock"
	icon_state = "bullet"
	pass_flags = PASSTABLE
	damage = 5
	flag = "bullet"
