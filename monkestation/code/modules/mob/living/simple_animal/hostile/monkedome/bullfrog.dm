/mob/living/simple_animal/hostile/monkedome_fauna/bullfrog
	name = "bullfrog"
	icon = 'monkestation/icons/mob/monkedome/monkedome_monsters.dmi'
	icon_state = "bullfrog"
	icon_living = "bullfrog"
	icon_dead = "bullfrog_dead"

	ranged = TRUE
	projectiletype = /obj/item/projectile/bullfrog_tongue

	health = 75
	maxHealth = 75

	melee_damage = 25
	obj_damage = 15

	faction = list("dome","hostile")

	ranged_message = "launches it's tongue at"
	ranged_cooldown_time = 5 SECONDS

	check_friendly_fire = TRUE

	move_to_delay = 0.5 SECONDS

//Projectile

/obj/item/projectile/bullfrog_tongue
	name = "rock"
	icon_state = "bullet"
	pass_flags = PASSTABLE
	range = 8
	var/tongue
	flag = "bullet"

/obj/item/projectile/bullfrog_tongue/fire(setAngle)
	if(firer)
		tongue = firer.Beam(src, icon_state = "tentacle", time = INFINITY, maxdistance = INFINITY, beam_sleep_time = 1)
	..()

/obj/item/projectile/bullfrog_tongue/on_hit(atom/target, blocked)
	. = ..()
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.visible_message("<span class='danger'>[living_target] is grabbed by [firer]'s tongue!</span>","<span class='userdanger'>A tongue grabs you and pulls you towards [firer]!</span>")
		living_target.throw_at(get_step_towards(firer,living_target), 8, 2, firer, TRUE, TRUE)
		living_target.Stun(2 SECONDS)
		living_target.Knockdown(3 SECONDS)
		return BULLET_ACT_HIT

/obj/item/projectile/bullfrog_tongue/Destroy()
	qdel(tongue)
	return ..()
