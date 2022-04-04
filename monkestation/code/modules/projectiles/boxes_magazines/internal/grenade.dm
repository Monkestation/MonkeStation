/obj/item/ammo_box/magazine/internal/SRN_rocket
	name = "SRN Rocket"
	ammo_type = /obj/item/ammo_casing/caseless/SRN_rocket
	caliber = "84mm"
	max_ammo = 3

/obj/item/ammo_box/magazine/internal/SRN_rocket/Initialize(mapload)
	stored_ammo += new ammo_type(src)
	. = ..()
