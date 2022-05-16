/obj/structure/destructible/cult/forge/attackby(obj/item/I, mob/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>The heat radiating from [src] pushes you back.</span>")
		return
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/notsword = I
		to_chat(user, "You heat the [notsword] in the [src].")
		notsword.workability = "shapeable"
