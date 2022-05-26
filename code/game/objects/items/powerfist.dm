/obj/item/melee/powerfist
	name = "power-fist"
	desc = "A metal gauntlet with a piston-powered ram ontop for that extra 'ompfh' in your punch."
	icon_state = "powerfist"
	item_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	attack_verb = list("whacked", "fisted", "power-punched")
	force = 20
	attack_weight = 1
	throwforce = 10
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 40, "stamina" = 0)
	resistance_flags = FIRE_PROOF
	var/click_delay = 2.5
	var/fisto_setting = 1
	var/gasperfist = 3
	var/obj/item/tank/internals/tank = null //Tank used for the gauntlet's piston-ram.
	var/baseforce = 20
	var/lock //if this is locked to the user


/obj/item/melee/powerfist/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += "<span class='notice'>You'll need to get closer to see any more.</span>"
		return
	if(tank)
		. += "<span class='notice'>[icon2html(tank, user)] It has \a [tank] mounted onto it.</span>"


/obj/item/melee/powerfist/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank/internals))
		if(!tank)
			var/obj/item/tank/internals/IT = W
			if(IT.volume <= 3)
				to_chat(user, "<span class='warning'>\The [IT] is too small for \the [src].</span>")
				return
			if(!lock)
				ADD_TRAIT(src, TRAIT_NODROP, POWERFIST_STICK)
				lock ++
				to_chat(user, "The Powerfist seals to your arm, removal is unlikely.")
			updateTank(W, 0, user)
	else if(W.tool_behaviour == TOOL_WRENCH)
		switch(fisto_setting)
			if(1)
				fisto_setting = 2
			if(2)
				fisto_setting = 3
			if(3)
				fisto_setting = 1
		W.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You tweak \the [src]'s piston valve to [fisto_setting].</span>")
	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(tank)
			updateTank(tank, 1, user)

/obj/item/melee/powerfist/proc/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, "<span class='notice'>\The [src] currently has no tank attached to it.</span>")
			return
		to_chat(user, "<span class='notice'>You detach \the [thetank] from \the [src].</span>")
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
	if(!removing)
		if(tank)
			to_chat(user, "<span class='warning'>\The [src] already has a tank.</span>")
			return
		if(!user.transferItemToLoc(thetank, src))
			return
		to_chat(user, "<span class='notice'>You hook \the [thetank] up to \the [src].</span>")
		tank = thetank


/obj/item/melee/powerfist/attack(mob/living/target, mob/living/user)
	//no tank?
	if(!tank)
		to_chat(user, "<span class='warning'>\The [src] can't operate without a source of gas!</span>")
		return FALSE
	//so we can release the used gas later
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/moles_used = gasperfist * fisto_setting //How many moles to use
	//empty tank?
	if(!moles_used)
		to_chat(user, "<span class='warning'>\The [src]'s tank is empty!</span>")
		force = (baseforce / 5)
		attack_weight = 1
		playsound(loc, 'sound/weapons/punch1.ogg', 50, 1)
		target.visible_message("<span class='danger'>[user]'s powerfist lets out a dull thunk as [user.p_they()] punch[user.p_es()] [target.name]!</span>", \
		"<span class='userdanger'>[user] punches you!</span>")
		return
	//less than the amount needed
	if(tank.air_contents.total_moles() < moles_used)
		to_chat(user, "<span class='warning'>\The [src]'s piston-ram lets out a weak hiss, it needs more gas!</span>")
		playsound(loc, 'sound/weapons/punch4.ogg', 50, 1)
		force = (baseforce / 2)
		attack_weight = 1
		target.visible_message("<span class='danger'>[user]'s powerfist lets out a weak hiss as [user.p_they()] punch[user.p_es()] [target.name]!</span>", \
			"<span class='userdanger'>[user]'s punch strikes with force!</span>")
		return
	//removing gas moment
	T.assume_air_moles(tank.air_contents, gasperfist * fisto_setting)
	T.air_update_turf()
	//damage calc
	force = (baseforce * fisto_setting)
	attack_weight = fisto_setting
	target.apply_damage(force, BRUTE)
	//Shield check
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.check_shields(src, force))
			return
	//messages and sounds
	target.visible_message("<span class='danger'>[user]'s powerfist lets out a loud hiss as [user.p_they()] punch[user.p_es()] [target.name]!</span>", \
		"<span class='userdanger'>You cry out in pain as [user]'s punch flings you backwards!</span>")
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
	playsound(loc, 'sound/weapons/genhit2.ogg', 50, 1)
	//knockback
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 5 * fisto_setting, 0.5 + (fisto_setting / 2))
	//log and end
	log_combat(user, target, "power fisted", src)
	user.changeNext_move(CLICK_CD_MELEE * click_delay)
	return TRUE
