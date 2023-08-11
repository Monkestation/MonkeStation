/obj/item/card/emag/improvised
	name = "improvised cryptographic sequencer"
	desc = "It's a card with some junk circuitry strapped to it. It doesn't look like it would be reliable or fast due to shoddy construction, and needs to be manually recharged with uranium sheets."
	icon_state = "emag_shitty"
	var/charges = 0 //how many times can we use the emag before needing to reload it?
	var/max_charges = 5
	var/emagging //are we currently emagging something

/obj/item/card/emag/improvised/afterattack(atom/target, mob/user, proximity)
	if(charges)
		if(emagging)
			to_chat(user, "<span class='notice'>You're already emagging something!")
			return
		if(!proximity && prox_check) //left in for badmins
			return
		emagging = TRUE
		if(do_after(user, rand(4, 7) SECONDS, target = target, progress = 1))
			log_combat(user, target, "attempted to emag")
			charges--
			if (prob(50)) //50% chance that it does nothing
				to_chat(user, "<span class='notice'>[src] emits a puff of smoke, but nothing happens.")
				emagging = FALSE
				return
			if (prob(20))//10% overall chance it catches you on fire
				var/mob/living/M = user
				M.adjust_fire_stacks(1)
				M.IgniteMob()
				to_chat(user, "<span class='danger'>The card shorts out and catches fire in your hands!")
				user.emote("scream")
				emagging = FALSE
				return
			if (prob(12.5))//5% overall chance it explodes (natural 1!)
				to_chat(user, "<span class='danger'>The card sizzles and causes all the electronics to explode!")
				explosion(target.loc, -1, 1, 3, 4) //same strength as a PDA bomb
				emagging = FALSE
				return
			target.emag_act(user)//35% overall chance we actually reach this point
		emagging = FALSE
	else
		to_chat(user, "<span class='notice'>[src] is out of charges!")

/obj/item/card/emag/improvised/attackby(obj/item/W, mob/user, params)
	. = ..()
	if (max_charges > charges)
		if (istype(W, /obj/item/stack/sheet/mineral/uranium))
			var/obj/item/stack/sheet/mineral/uranium/T = W
			T.use(1)
			charges++
			to_chat(user, "<span class='notice'>You add another charge to the [src]. It now has [charges] use[charges == 1 ? "" : "s"] remaining.")

/obj/item/card/emag/improvised/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The charge meter indicates that it has [charges] charge[charges == 1 ? "" : "s"] remaining out of [max_charges] charges."
