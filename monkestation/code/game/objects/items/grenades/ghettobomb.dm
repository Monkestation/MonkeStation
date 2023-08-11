/obj/item/grenade/pipebomb
	name = "improvised pipebomb"
	desc = "A weak, improvised explosive with a mousetrap attached. For all your mailbombing needs."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "pipebomb"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	active = 0
	var/armed = 0
	display_timer = 0

/obj/item/grenade/pipebomb/Initialize()
	. = ..()

/obj/item/grenade/pipebomb/attack_self(mob/user)
	if(!armed)
		to_chat(user, span_warning("You pull back the mousetrap, arming the [name]! It will detonate whenever someone opens the container it is put inside of!"))
		playsound(src, 'sound/weapons/handcuffs.ogg', 30, TRUE, -3)
		log_admin("[key_name(user)] armed a [name] at [AREACOORD(src)]")
		armed = 1
	else
		to_chat(user, span_warning("The [name] is already armed!"))

/obj/item/grenade/pipebomb/on_found(mob/finder)
	if(armed)
		if(finder)
			to_chat(finder, span_userdanger("Oh no-"))
			preprime(finder, TRUE, FALSE)
			return TRUE	//end the search!
		else
			visible_message(span_warning("[src] detonates!"))
			preprime(finder, TRUE, FALSE)
			return FALSE
	return FALSE

/obj/item/grenade/pipebomb/prime(mob/living/lanced_by) //Blowing that can up
	update_mob()
	explosion(src.loc,-1,-1,2, flame_range = 4)	// small explosion, plus a very large fireball. same as the IED.
	qdel(src)
