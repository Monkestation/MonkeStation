/obj/item/armament/daemon_blade
	name = "daemon blade"
	desc = "A blade formed out of demonic energy. Activate in hand to throw flames."
	icon_state = "daemon_blade"
	item_state = "daemon_blade"
	lefthand_file = 'monkestation/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'monkestation/icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 12
	ability_cooldown = 20 SECONDS
	var/flame_toggle = FALSE

/obj/item/armament/daemon_blade/Initialize(mapload)
	. = ..()

/obj/item/armament/daemon_blade/attack_self(mob/user)
	if(!COOLDOWN_FINISHED(src,armament_cooldown)) //Can't turn it on if its on cooldown
		to_chat(user, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, armament_cooldown)*0.1] seconds to use [src] again!</span>")
		flame_toggle = FALSE
		return
	flame_toggle = !flame_toggle
	if (flame_toggle)
		icon_state = "daemon_blade_fire"
		to_chat(user, "<span class='warning'>[src] glows bright with mysterious runes. Click a target to burn it</span>")
	else
		icon_state = "daemon_blade"
		to_chat(user, "<span class='warning'>[src] stops glowing.</span>")
	return

/obj/item/armament/daemon_blade/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!flame_toggle)
		return
	. = ..()
	if(.)
		return
	var/turflist = get_line(user, get_turf(target))
	flame_turf(turflist)
	flame_toggle = FALSE
	icon_state = "daemon_blade"
	to_chat(user, "<span class='warning'>[src] stops glowing.</span>")

/obj/item/armament/daemon_blade/proc/flame_turf(turflist)
	var/turf/previous_turf = get_turf(src)
	for(var/turf/current_turf in turflist)
		if(current_turf == get_turf(src))
			continue
		if(previous_turf == get_turf(src))
			previous_turf = current_turf
			continue
		if(isclosedturf(previous_turf)) //Can't fire fire through walls
			break
		new /obj/effect/hotspot(previous_turf)
		for(var/mob/living/hit_creature in previous_turf)
			hit_creature.adjustFireLoss(6)
			hit_creature.throw_at(current_turf, 1, 2)
			hit_creature.Stun(0.5 SECONDS)
		previous_turf = current_turf
		sleep(1)
		//Once last hit for the final turf
		if(!isclosedturf(previous_turf))
			new /obj/effect/hotspot(previous_turf)
			for(var/mob/living/hit_creature in previous_turf)
				hit_creature.adjustFireLoss(12)
				hit_creature.Stun(1 SECONDS)
