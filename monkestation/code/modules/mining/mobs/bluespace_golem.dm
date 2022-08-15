/mob/living/simple_animal/hostile/golem/bluespace
	name = "bluespace golem"
	desc = "A moving pile of rocks with bluespace crystals in it."

	icon_state = "golem_blue_idle"
	icon_dead = "golem_blue"

	maxHealth = 75
	health = 75

	melee_damage = 0
	obj_damage = 0

	retreat_distance = 5

	ore_type = /obj/item/stack/ore/bluespace_crystal

	ranged_message = "fires"
	minimum_distance = 6
	retreat_distance = 6

	// Cooldown of special ability
	var/teleport_cooldown = 0

/mob/living/simple_animal/hostile/golem/bluespace/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#82C2D8")

/mob/living/simple_animal/hostile/golem/bluespace/Destroy()
	set_light(0)
	. = ..()

// Special capacity of ansible golem: it will focus and teleport a miner near other golems
/mob/living/simple_animal/hostile/golem/bluespace/proc/teleport_target(var/atom/teleportee)

	// Teleport target near random golem
	if(teleportee && isliving(teleportee))
		var/list/golems = list()
		for(var/mob/living/simple_animal/hostile/golem/surrounding_golem in range(10, src.loc))
			golems |= surrounding_golem
		var/mob/living/teleportee = target
		to_chat(teleportee, span_warning("You are transported away by the [src.name]!"))
		teleportee.forceMove(get_step(pick(golems), pick(GLOB.cardinals)))
		playsound(teleportee, 'sound/magic/wand_teleport.ogg', 50)

/mob/living/simple_animal/hostile/golem/bluespace/proc/focus_target()
	// Display focus animation
	var/image/img = image('monkestation/icons/mob/mining/golems.dmi', target)
	target << img
	flick("bluespace_focus", img)

	// Callback to function that will teleport the target
	// Animation lasts 90 frames with 0.6 tick delay between frames
	addtimer(CALLBACK(src, .proc/teleport_target(target),), 54)

/mob/living/simple_animal/hostile/golem/bluespace/Life()
	if(isliving(target) && (world.time - teleport_cooldown > 1 MINUTES))  // Do not teleport the drill
		teleport_cooldown = world.time
		focus_target()
	. = ..()
