/mob/living/simple_animal/hostile/asteroid/golem
	name = "Base Golem"
	desc = "You shouldn't see this"


	icon = 'monkestation/icons/mob/mining/golems.dmi'
	icon_state = "golem_iron"

	health = GOLEM_HEALTH_LOW
	maxHealth = GOLEM_HEALTH_LOW

	melee_damage = GOLEM_DMG_LOW * 0.5
	obj_damage = GOLEM_DMG_LOW

	move_to_delay = GOLEM_SPEED_SLUG

	vision_range = 10

	faction = list("golem")
	wanted_objects = list(/obj/machinery/drill)

	var/ore_type = /obj/item/stack/ore/iron
	var/wave_spawned = 1
	var/obj/machinery/drill/nearby_drill

	// Controller that spawned the golem
	var/datum/golem_controller/controller

	var/timeout_death


/mob/living/simple_animal/hostile/asteroid/golem/New(loc, obj/machinery/drill, datum/golem_controller/parent)
	..()
	if(parent)
		controller = parent  // Link golem with golem controller
		controller.golems += src
	if(drill)
		nearby_drill = drill
		if(prob(50))
			target= drill

/mob/living/simple_animal/hostile/asteroid/golem/Initialize(mapload)
	. = ..()
	timeout_death = addtimer(CALLBACK(src, .proc/timeout_death), 3 MINUTES)
	icon_living = icon_state
	icon_aggro = icon_state
	nearby_drill = locate(/obj/machinery/drill) in range(10, src.loc)
	if(prob(50))
		target= nearby_drill
	else
		target = locate(/mob/living/carbon/human) in range(10, src.loc)

/mob/living/simple_animal/hostile/asteroid/golem/proc/timeout_death()
	visible_message(span_notice("\The [src] crumbles into dust"))
	qdel(src)

/mob/living/simple_animal/hostile/asteroid/golem/Destroy()
	. = ..()
	nearby_drill = null

/mob/living/simple_animal/hostile/asteroid/golem/death(gibbed)
	if(controller) // Unlink from controller
		controller.golems -= src
		controller = null

	. = ..()

	// Spawn ores
	if(ore_type)
		var/nb_ores = rand(3, 5) + wave_spawned
		for(var/i in 1 to nb_ores)
			new ore_type(loc)

	// Poof
	qdel(src)

/mob/living/simple_animal/hostile/asteroid/golem/ListTargets() //Step 1, find out what we can see
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(!search_objects)
		var/static/target_list = typecacheof(list(/obj/machinery/porta_turret, /obj/machinery/drill)) //mobs are handled via ismob(atom_target)
		. = list()
		for(var/atom/atom_target as() in dview(vision_range, get_turf(target_from), SEE_INVISIBLE_MINIMUM))
			if((ismob(atom_target) && atom_target != src) || target_list[atom_target.type])
				if(ishostile(atom_target))
					var/mob/living/simple_animal/hostile/temp = atom_target
					if("golem" in temp.faction)
						return
				. += atom_target
	else
		. = oview(vision_range, target_from)

/mob/living/simple_animal/hostile/asteroid/golem/DestroySurroundings()
	// Get next turf the golem wants to walk on
	var/turf/attacked_turf = get_step_towards(src, target)
	if(isclosedturf(attacked_turf))  // Wall breaker attack
		attacked_turf.attack_animal(src, obj_damage)
	else
		var/obj/structure/obstacle = locate(/obj/structure) in attacked_turf
		if(obstacle && !istype(obstacle, /obj/structure/golem_burrow))
			obstacle.attack_animal(src,obj_damage)

/mob/living/simple_animal/hostile/asteroid/golem/Life()
	. = ..()
	if(prob(20) && nearby_drill && !target)
		target= nearby_drill //i hate this but ai code is so slow i need to do this or risk massive delays in target finding
