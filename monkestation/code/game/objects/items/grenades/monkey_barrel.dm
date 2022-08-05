/obj/item/grenade/monkey_barrel
	name = "angry monkey barrel"
	desc = "A barrel full of monkeys ready to hand out a beating."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrel"
	item_state = "barrel"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'

/obj/item/grenade/monkey_barrel/preprime(mob/user, delayoverride, msg = TRUE, volume = 60)
	var/turf/T = get_turf(src)
	log_grenade(user, T)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, "<span class='warning'>You shake the barrel, angering the monkeys inside!</span>")
	playsound(src, 'sound/creatures/monkey/monkey_screech_7.ogg', volume, 1)
	active = TRUE
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time, delayoverride)
	addtimer(CALLBACK(src, .proc/prime), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/monkey_barrel/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		return TRUE
	else
		return ..()

/obj/item/grenade/monkey_barrel/prime(mob/living/lanced_by)
	. = ..()

	var/current_turf = get_turf(src)

	playsound(current_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)

	for(var/i in 1 to 6)
		new /mob/living/carbon/monkey/angry(current_turf, FALSE)

	qdel(src)
