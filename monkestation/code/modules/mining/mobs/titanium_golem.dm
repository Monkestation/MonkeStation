/obj/item/projectile/beam/disabler/heavy
	damage = 42

/mob/living/simple_animal/hostile/asteroid/golem/titanium
	name = "titanium golem"
	desc = "A moving pile of rocks with titanium specks in it."

	icon_state = "golem_titanium"
	ore_type = /obj/item/stack/ore/titanium

	move_to_delay = 6

	health = 100
	maxHealth = 100

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/beam/disabler/heavy
	projectilesound = 'sound/weapons/burn.ogg'
	casingtype = null
	ranged_cooldown = 3 SECONDS
	ranged_message = "fires"
	minimum_distance = 3
	retreat_distance = 3
