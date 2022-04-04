/obj/item/gun/ballistic/SRN_rocketlauncher
	desc = "A rocket designed with the power of bluespace to send a singularity or tesla back to the shadow realm"
	name = "Spatial Rift Nullifier (SRN) Rocket Launcher"
	icon = 'monkestation/icons/obj/guns/guns.dmi'
	icon_state = "srnlauncher"
	lefthand_file = 'monkestation/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'monkestation/icons/mob/inhands/weapons/guns_righthand.dmi'
	item_state = "srnlauncher"
	mag_type = /obj/item/ammo_box/magazine/internal/SRN_rocket
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	w_class = WEIGHT_CLASS_HUGE
	can_suppress = FALSE
	pin = /obj/item/firing_pin
	burst_size = 1
	fire_delay = 0
	casing_ejector = FALSE
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	cartridge_wording = "rocket"
	empty_indicator = TRUE
	tac_reloads = FALSE

/obj/item/gun/ballistic/SRN_rocketlauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/SRN_rocketlauncher/afterattack()
	. = ..()
	magazine.get_round(FALSE) //Hack to clear the mag after it's fired

/obj/item/gun/ballistic/SRN_rocketlauncher/attack_self_tk(mob/user)
	return //too difficult to remove the rocket with TK
