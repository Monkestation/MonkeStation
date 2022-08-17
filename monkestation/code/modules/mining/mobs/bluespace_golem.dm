/mob/living/simple_animal/hostile/asteroid/golem/bluespace
	name = "bluespace golem"
	desc = "A moving pile of rocks with bluespace crystals in it."

	icon_state = "golem_blue_idle"
	icon_dead = "golem_blue"

	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	melee_damage = 0
	obj_damage = 0

	retreat_distance = 5

	ore_type = /obj/item/stack/ore/bluespace_crystal

	ranged_message = "fires"
	minimum_distance = 6
	retreat_distance = 6

	// Cooldown of special ability
	var/teleport_cooldown = 0

/mob/living/simple_animal/hostile/asteroid/golem/bluespace/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#82C2D8")

/mob/living/simple_animal/hostile/asteroid/golem/bluespace/Destroy()
	set_light(0)
	. = ..()

// Special capacity of ansible golem: it will focus and teleport a miner near other golems
/mob/living/simple_animal/hostile/asteroid/golem/bluespace/proc/teleport_target()

	// Teleport target near random golem
	if(target && isliving(target))
		var/list/golems = list()
		for(var/mob/living/simple_animal/hostile/asteroid/golem/surrounding_golem in range(10, src.loc))
			golems |= surrounding_golem
		var/mob/living/target_mob = target
		to_chat(target_mob, span_warning("You are transported away by the [src.name]!"))
		target_mob.forceMove(get_step(pick(golems), pick(GLOB.cardinals)))
		playsound(target, 'sound/magic/wand_teleport.ogg', 50)

/mob/living/simple_animal/hostile/asteroid/golem/bluespace/proc/focus_target()
	// Display focus animation
	var/image/img = image('monkestation/icons/mob/mining/golems.dmi', target)
	target << img
	flick("bluespace_focus", img)

	// Callback to function that will teleport the target
	// Animation lasts 90 frames with 0.6 tick delay between frames
	addtimer(CALLBACK(src, .proc/teleport_target,), 54)

/mob/living/simple_animal/hostile/asteroid/golem/bluespace/Life()
	if(controller)
		if(isliving(target) && (world.time - teleport_cooldown > 1 MINUTES))  // Do not teleport the drill
			teleport_cooldown = world.time
			focus_target()
	. = ..()
