/obj/item/armament/hell_hammer
	name = "hell hammer"
	desc = "A hammer forged from the rocks of hell. Activate in hand to trigger a shockwave."
	icon_state = "hell_hammer"
	item_state = "hell_hammer"
	lefthand_file = 'monkestation/icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'monkestation/icons/mob/inhands/weapons/hammers_lefthand.dmi'
	sharpness = IS_BLUNT
	hitsound = "swing_hit"
	attack_weight = 2
	force = 20
	ability_cooldown = 25 SECONDS

/obj/item/armament/hell_hammer/Initialize(mapload)
	. = ..()

/obj/item/armament/hell_hammer/attack_self(mob/user)
	. = ..()
	if(.)
		return
	user.visible_message("<span class='danger'>[user] slams [src] onto the ground, creating a shockwave.</span>", "<span class='notice'>You slam [src] into the ground, creating a shockwave.</span>")
	playsound(src, 'sound/effects/grillehit.ogg', 100)
	for(var/atom/movable/shockwave_target as mob|obj in oview(5,user))
		if(shockwave_target.anchored)
			continue
		var/throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(shockwave_target, user)))
		shockwave_target.throw_at(throwtarget, 5, 2)
		if(isliving(shockwave_target))
			var/mob/living/living_target = shockwave_target
			living_target.Knockdown(3 SECONDS)
			living_target.Stun(3 SECONDS)

/obj/item/armament/hell_hammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return
