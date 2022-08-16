#define DET_STABLE 0
#define DET_BLOWING 1
#define DET_DEFUSED 2

/mob/living/simple_animal/hostile/asteroid/golem/plasma
	name = "plasma golem"
	desc = "A moving pile of rocks with plasma specks in it."

	icon_state = "golem_plasma"
	ore_type = /obj/item/stack/ore/plasma

	move_to_delay = 5

	health = 50
	maxHealth = 50

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/plasma
	projectilesound = 'sound/weapons/burn.ogg'
	casingtype = null
	ranged_cooldown = 1 SECONDS
	ranged_message = "fires"
	minimum_distance = 3
	retreat_distance = 3

	// How much time before detonation
	var/det_time = 5 SECONDS
	var/det_status = DET_STABLE

// Special capacity of plasma golem: blow up upon death except if hit with melee weapon
/mob/living/simple_animal/hostile/asteroid/golem/plasma/death(gibbed, message = deathmessage)
	if(det_status == DET_STABLE)
		det_status = DET_BLOWING
		icon_state = "golem_plasma_idle"
		minimum_distance = 1
		retreat_distance = null
		move_to_delay = 2
		visible_message(span_danger("\The [src] starts glowing!"))
		spawn(det_time)
			if(det_status == DET_BLOWING)  // Blowing up since no one defused it
				icon_state = "golem_plasma_explosion"
				spawn(1.5 SECONDS)
					// Plasma ball on location
					visible_message(span_danger("\The [src] explodes into a ball of burning plasma!"))
					for(var/turf/open/floor/target_tile in range(2, loc))
						explosion(target_tile, 0, 0, 4, flame_range = 2, adminlog = FALSE, smoke = TRUE)
					. = ..()
	else if(det_status == DET_DEFUSED)  // Will triger when hit by melee while blowing
		. = ..()

// Called when the mob is hit with an item in combat.
/mob/living/simple_animal/hostile/asteroid/golem/plasma/attacked_by(obj/item/I, mob/living/user)
	if(det_status == DET_BLOWING)
		det_status = DET_DEFUSED
		icon_state = "golem_plasma"
	. = ..()

#undef DET_STABLE
#undef DET_BLOWING
#undef DET_DEFUSED
