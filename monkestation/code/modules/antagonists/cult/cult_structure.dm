/obj/structure/destructible/cult/forge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		if(!iscultist(user))
			to_chat(user, "<span class='warning'>The heat radiating from [src] pushes you back.</span>")
			return
		var/obj/item/ingot/notsword = I
		to_chat(user, "You heat the [notsword] in the [src].")
		notsword.workability = "shapeable"
