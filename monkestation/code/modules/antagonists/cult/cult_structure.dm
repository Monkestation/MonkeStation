/obj/structure/destructible/cult/forge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		if(!iscultist(user))
			to_chat(user, "<span class='warning'>The heat radiating from [src] pushes you back.</span>")
			return
		var/obj/item/ingot/worked_ingot = I
		to_chat(user, "You heat the [worked_ingot] in the [src].")
		worked_ingot.workability = TRUE
