/obj/item/gun/ballistic/automatic/pistol/makeshift //a weird frankenstein mix of pistol and mosin
	name = "makeshiftov pistol"
	desc = "A small, makeshift 10mm handgun. It's a miracle if it'll even fire."
	icon_state = "makeshift"
	mag_type = /obj/item/ammo_box/magazine/internal/makeshift
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	internal_magazine = TRUE

/obj/item/gun/ballistic/automatic/pistol/makeshift/update_icon()
	..()
	add_overlay("[icon_state]_bolt[bolt_locked ? "_locked" : ""]")

/obj/item/gun/ballistic/automatic/pistol/makeshift/rack(mob/user = null)
	if(bolt_locked == FALSE)
		to_chat(user, "<span class='notice'>You open the bolt of \the [src].</span>")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_icon()
		return
	drop_bolt(user)

/obj/item/gun/ballistic/automatic/pistol/makeshift/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/automatic/pistol/makeshift/attackby(obj/item/A, mob/user, params)
	if (!bolt_locked)
		to_chat(user, "<span class='notice'>The bolt is closed!</span>")
		return
	return ..()

/obj/item/gun/ballistic/automatic/pistol/makeshift/examine(mob/user)
	. = ..()
	. += "The bolt is [bolt_locked ? "open" : "closed"]."
