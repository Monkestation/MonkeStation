/obj/item/armament/blood_scythe
	name = "blood scythe"
	desc = "A scythe created from the blood of demons. Click on a distant target to bring them closer."
	icon_state = "blood_scythe"
	item_state = "blood_scythe"
	lefthand_file = 'monkestation/icons/mob/inhands/polearms_lefthand.dmi'
	righthand_file = 'monkestation/icons/mob/inhands/polearms_righthand.dmi'
	force = 15
	ability_cooldown = 15 SECONDS

/obj/item/armament/blood_scythe/Initialize(mapload)
	. = ..()

/obj/item/armament/blood_scythe/attack_self(mob/user)
	. = ..()

/obj/item/armament/blood_scythe/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag && get_dist(user,target) < 7)
		if(!isliving(target))
			return
		. = ..()
		if(.)
			return
		var/target_turf = get_step(user, user.dir)
		var/mob/living/living_target = target
		if(isopenturf(target_turf))
			do_teleport(living_target, target_turf, channel = TELEPORT_CHANNEL_FREE, no_effects = TRUE, teleport_mode = TELEPORT_MODE_DEFAULT)
			living_target.Stun(1 SECONDS)
			living_target.Knockdown(3 SECONDS)
