// Normal types of golems
GLOBAL_LIST_INIT(golems_normal, list(
                                    /mob/living/simple_animal/hostile/asteroid/golem/iron,
									/mob/living/simple_animal/hostile/asteroid/golem/coal,))

// Special types of golems
GLOBAL_LIST_INIT(golems_special, list(
									 /mob/living/simple_animal/hostile/asteroid/golem/plasma,
									 /mob/living/simple_animal/hostile/asteroid/golem/diamond,
									 /mob/living/simple_animal/hostile/asteroid/golem/bluespace,
									 /mob/living/simple_animal/hostile/asteroid/golem/titanium,
									 /mob/living/simple_animal/hostile/asteroid/golem/silver,
									 /mob/living/simple_animal/hostile/asteroid/golem/uranium))

/obj/structure/golem_burrow
	name = "golem burrow"
	icon = 'monkestation/icons/obj/burrows.dmi'
	icon_state = "maint_hole"
	desc = "A pile of rocks that regularly pulses as if it was alive."
	density = TRUE
	anchored = TRUE

	var/max_health = 50
	var/health = 50
	var/datum/golem_controller/controller
	var/obj/machinery/drill/nearby_drill

/obj/structure/golem_burrow/New(loc, parent, obj/machinery/drill)
	..()
	controller = parent  // Link burrow with golem controller
	nearby_drill = drill

/obj/structure/golem_burrow/Destroy()
	visible_message(span_danger("\The [src] crumbles!"))
	if(controller)
		controller.burrows -= src
		controller.destroyed_burrows ++
		controller = null
	..()

/obj/structure/golem_burrow/attack_generic(mob/user, damage)
	user.do_attack_animation(src)
	visible_message(span_danger("\The [user] smashes \the [src]!"))
	take_damage(damage)
	//user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

/obj/structure/golem_burrow/attackby(obj/item/I, mob/user)
	if (user.a_intent == INTENT_HARM && user.Adjacent(src))
		if(!(I.sharpness == IS_BLUNT))
			user.do_attack_animation(src)
			var/damage = I.force
			var/volume =  min(damage * 3.5, 15)
			if (I.hitsound)
				playsound(src, I.hitsound, volume, 1, -1)
			visible_message(span_danger("[src] has been hit by [user] with [I]."))
			take_damage(damage)
			//user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)
	return TRUE

/obj/structure/golem_burrow/bullet_act(obj/item/projectile/Proj)
	..()
        // Bullet not really efficient against a pile of rock
	take_damage(Proj.force * 0.25)

/obj/structure/golem_burrow/take_damage(value)
	health = min(max(health - value, 0), max_health)
	if(health == 0)
		qdel(src)

/obj/structure/golem_burrow/proc/stop()
	qdel(src)  // Delete burrow
