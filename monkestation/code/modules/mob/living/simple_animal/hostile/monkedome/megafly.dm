/mob/living/simple_animal/hostile/monkedome_fauna/megafly
	name = "megafly"
	icon = 'monkestation/icons/mob/monkedome/monkedome_monsters.dmi'
	icon_state = "megafly"
	icon_living = "megafly"
	icon_dead = "megafly_dead"

	health = 35
	maxHealth = 35

	melee_damage = 10

	faction = list("dome","hostile")

	movement_type = FLYING

	move_to_delay = 0.15 SECONDS

/mob/living/simple_animal/hostile/monkedome_fauna/megafly/AttackingTarget()
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.blood_volume -= rand(7,16)
