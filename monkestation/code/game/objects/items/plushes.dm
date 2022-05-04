/obj/item/toy/plush/duckyplush
	name = "ducky plushie"
	desc = "Manufactured in the Russ Sector"
	icon = 'monkestation/icons/obj/plushes.dmi'
	icon_state = "russducky"
	squeak_override = list('sound/items/bikehorn.ogg'=1)

/obj/item/toy/plush/lubeplush
	name = "living lube plushie"
	desc = "It feels... moist."
	icon = 'monkestation/icons/obj/plushes.dmi'
	icon_state = "living_lube"
	squeak_override = list('sound/items/bikehorn.ogg'=1)
	var/last_lubed = 0  //so you can't spam the floor with their lube

/obj/item/toy/plush/lubeplush/dropped(mob/user, silent)
	. = ..()
	if((last_lubed + 30 SECONDS) < world.time)
		var/turf/open/OT = get_turf(src)
		if(isopenturf(OT))
			OT.MakeSlippery(TURF_WET_WATER, 100)
			last_lubed = world.time


/obj/item/toy/plush/moth/ookplush
	name = "ook plushie"
	desc = "What's under the bag, anyway?"
	icon = 'monkestation/icons/obj/plushes.dmi'
	icon_state = "ook"
	squeak_override = list('monkestation/sound/voice/laugh/simian/monkey_laugh_1.ogg'=1)
	suicide_text = "is overcome with curiosity and tries to pull the bag off of"
	creepy_plush_type = "monkey"
	has_creepy_icons = TRUE

/obj/item/toy/plush/moth/tyriaplush
	name = "tyria plushie"
	desc = "Tyria plushie isn't real.  Tyria plushie can't hurt you."
	icon = 'monkestation/icons/obj/plushes.dmi'
	icon_state = "tyria"
	attack_verb = list("fluttered", "flapped")
	squeak_override = list('monkestation/sound/voice/laugh/moth/mothlaugh.ogg'=1)
	has_creepy_icons = TRUE


/obj/item/toy/plush/goatplushie
	name = "strange goat plushie"
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	squeak_override = list('sound/weapons/punch1.ogg'=1)
	/// Whether or not this goat is currently taking in a monsterous doink
	var/going_hard = FALSE
	/// Whether or not this goat has been flattened like a funny pancake
	var/splat = FALSE

/obj/item/toy/plush/goatplushie/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_TURF_INDUSTRIAL_LIFT_ENTER = .proc/splat,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/toy/plush/goatplushie/attackby(obj/item/clothing/mask/cigarette/rollie/fat_dart, mob/user, params)
	if(!istype(fat_dart))
		return ..()
	if(splat)
		to_chat(user, "<span_class='notice'>[src] doesn't seem to be able to go hard right now."))
		return
	if(going_hard)
		to_chat(user, "<span_class='notice'>[src] is already going too hard!"))
		return
	if(!fat_dart.lit)
		to_chat(user, "<span_class='notice'>You'll have to light that first!"))
		return
	to_chat(user, "<span_class='notice'>You put [fat_dart] into [src]'s mouth."))
	qdel(fat_dart)
	going_hard = TRUE
	update_icon(UPDATE_OVERLAYS)

/obj/item/toy/plush/goatplushie/proc/splat(datum/source)
	SIGNAL_HANDLER
	if(splat)
		return
	if(going_hard)
		going_hard = FALSE
		update_icon(UPDATE_OVERLAYS)
	icon_state = "goat_splat"
	playsound(src, "desecration", 50, TRUE)
	visible_message("<span_class='danger'>[src] gets absolutely flattened!"))
	splat = TRUE

/obj/item/toy/plush/goatplushie/examine()
	. = ..()
	if(splat)
		. += "<span_class='notice'>[src] might need medical attention.")
	if(going_hard)
		. += "<span_class='notice'>[src] is going so hard, feel free to take a picture.")

/obj/item/toy/plush/goatplushie/update_overlays()
	. = ..()
	if(going_hard)
		. += "goat_dart"
