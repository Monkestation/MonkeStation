/obj/vehicle/ridden/monkey_ball
	name = "Monkey Ball"
	desc = "An ominously monkey-sized ball."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "wheelchair"
	max_integrity = 200

/obj/vehicle/ridden/Initialize(mapload)
	. = ..()
	var/datum/component/riding/riding_component = LoadComponent(/datum/component/riding)
	riding_component.vehicle_move_delay = 1

/obj/vehicle/ridden/monkey_ball/Destroy()
	if(has_buckled_mobs())
		var/mob/living/carbon/driver = buckled_mobs[1]
		unbuckle_mob(driver)
	return ..()

/obj/vehicle/ridden/monkey_ball/Moved()
	. = ..()
	cut_overlays()

/obj/vehicle/ridden/monkey_ball/unbuckle_mob(mob/living/buckled_mob, force)
	if((usr != buckled_mob && do_after(usr, 5 SECONDS, null, buckled_mob)) || usr == buckled_mob)
		. = ..()

/obj/vehicle/ridden/monkey_ball/Bump(atom/movable/victim)
	. = ..()
	var/mob/living/driver = buckled_mobs[1]
	if(isliving(victim))
		var/atom/throw_target = get_edge_target_turf(driver, driver.dir)
		var/mob/living/living_victim = victim
		living_victim.throw_at(throw_target, 4, 5)
		living_victim.Knockdown(4 SECONDS)
		living_victim.adjustStaminaLoss(35)
		playsound(src, 'sound/effects/bang.ogg', 50, 1)

