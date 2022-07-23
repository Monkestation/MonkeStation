/mob/living/simple_animal/chicken/hostile/retaliate/robot
	breed_name = "Robotic"

	maxHealth = 100 //Weaker because emp good
	obj_damage = 1
	melee_damage = 4

	egg_type = /obj/item/food/egg/robot
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/robot

/mob/living/simple_animal/chicken/hostile/retaliate/robot/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_HOSTILE_ATTACKINGTARGET, .proc/emp_burst)

/mob/living/simple_animal/chicken/hostile/retaliate/robot/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_HOSTILE_ATTACKINGTARGET)

/mob/living/simple_animal/chicken/hostile/retaliate/robot/proc/emp_burst(target)
	var/turf/location = get_turf(target)
	empulse(location, 1, 2, 0)

/obj/item/food/egg/robot
	name = "Robotic Egg"
