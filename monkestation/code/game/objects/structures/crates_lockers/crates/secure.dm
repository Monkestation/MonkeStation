/obj/structure/closet/crate/secure/clown
	name = "clown crate"
	icon = 'monkestation/icons/obj/crates.dmi'
	open_sound = 'sound/items/bikehorn.ogg'
	close_sound = 'sound/items/bikehorn.ogg'
	desc = "A very funny crate. Faint honking echoes from inside."
	icon_state = "clown_crate"
	icon_door_override = FALSE

/obj/structure/closet/crate/secure/clown/togglelock(mob/living/user, silent)
	if(secure && !broken)
		if(user.mind.assigned_role == "Clown")
			if(iscarbon(user))
				add_fingerprint(user)
			locked = !locked
			user.visible_message("<span class='notice'>[user] [locked ? null : "un"]locks [src].</span>",
							"<span class='notice'>You [locked ? null : "un"]lock [src].</span>")
			update_icon()
		else if(!silent)
			to_chat(user, "<span class='warning'>Try as you might you just don't seem funny enough to unlock this.</span>")
	else if(secure && broken)
		to_chat(user, "<span class='warning'>\The [src] is broken!</span>")

/obj/structure/closet/crate/secure/clown/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1,)
	. = ..()
	if(prob(33))
		visible_message("<span class='danger'>[src] spews out a ton of space lube!</span>")
		new /obj/effect/particle_effect/foam(loc)
