/mob/living/simple_animal/hostile/golem
	name = "Base Golem"
	desc = "You shouldn't see this"


	icon = 'monkestation/icons/mob/mining/golems.dmi'
	icon_state = "golem_iron"

	health = 100
	maxHealth = 100
	melee_damage = 10
	obj_damage = 10
	move_to_delay = 8

	faction = list("golem")
	wanted_objects = list(/obj/machinery/drill)

	var/ore_type = /obj/item/stack/ore/iron
	var/wave_spawned = 1
	var/freeform = TRUE


/mob/living/simple_animal/hostile/golem/Initialize(mapload)
	. = ..()
	if(freeform == TRUE)
		var/drill = locate(/obj/machinery/drill) in view(10, src.loc)
		if(drill)
			target = drill


/mob/living/simple_animal/hostile/golem/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	.=..()

/mob/living/simple_animal/hostile/golem/ListTargets() //Step 1, find out what we can see
	var/atom/target_from = GET_TARGETS_FROM(src)
	if(!search_objects)
		var/static/target_list = typecacheof(list(/obj/machinery/porta_turret, /obj/machinery/drill)) //mobs are handled via ismob(A)
		. = list()
		for(var/atom/A as() in dview(vision_range, get_turf(target_from), SEE_INVISIBLE_MINIMUM))
			if((ismob(A) && A != src) || target_list[A.type])
				if(ishostile(A))
					var/mob/living/simple_animal/hostile/temp = A
					if("golem" in temp.faction)
						return
				. += A
	else
		. = oview(vision_range, target_from)
