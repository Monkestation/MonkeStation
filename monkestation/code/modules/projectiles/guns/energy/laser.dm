/obj/item/gun/energy/laser/makeshift_lasrifle
	name = "makeshift laser rifle"
	desc = "A makeshift rifle that shoots lasers. Lacks factory precision, but the screwable bulb allows modulating the photonic output."
	icon_state = "lasrifle"
	item_state = "makeshiftlas"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = list(/obj/item/ammo_casing/energy/laser/makeshiftlasrifle, /obj/item/ammo_casing/energy/laser/makeshiftlasrifle/weak)
	icon = 'icons/obj/guns/energy.dmi'
	can_charge = TRUE
	charge_sections = 1
	ammo_x_offset = 2
	shaded_charge = FALSE //if this gun uses a stateful charge bar for more detail

/obj/item/ammo_casing/energy/laser/makeshiftlasrifle
	e_cost = 1000 //The amount of energy a cell needs to expend to create this shot.
	projectile_type = /obj/item/projectile/beam/laser/makeshiftlasrifle
	select_name = "strong"
	variance = 2

/obj/item/projectile/beam/laser/makeshiftlasrifle
	damage = 17

/obj/item/ammo_casing/energy/laser/makeshiftlasrifle/weak
	e_cost = 100 //The amount of energy a cell needs to expend to create this shot.
	projectile_type = /obj/item/projectile/beam/laser/makeshiftlasrifle/weak
	select_name = "weak"
	fire_sound = 'sound/weapons/laser2.ogg'

/obj/item/projectile/beam/laser/makeshiftlasrifle/weak
	name = "weak laser"
	damage = 5
