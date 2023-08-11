/obj/item/kitchen/knife/makeshift
	name = "makeshift knife"
	icon = 'monkestation/icons/obj/improvised.dmi'
	icon_state = "knife_makeshift"
	desc = "A flimsy, poorly made replica of a classic cooking utensil."
	force = 8
	throwforce = 8

/obj/item/kitchen/knife/makeshift/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(prob(5))
		to_chat(user, span_danger("[src] crumbles apart in your hands!"))
		qdel(src)
		return
