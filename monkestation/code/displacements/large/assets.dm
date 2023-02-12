/obj/effect/distortion
	icon = 'monkestation/icons/effects/displacement_maps.dmi'
	appearance_flags = PIXEL_SCALE | RESET_COLOR | RESET_TRANSFORM | RESET_ALPHA | NO_CLIENT_COLOR
	vis_flags = VIS_INHERIT_DIR

/obj/effect/distortion/Initialize(mapload)
	. = ..()
	render_target = "*\ref[src]"

/obj/effect/distortion/large
	icon = 'monkestation/icons/effects/displacement_96x96.dmi'
	icon_state = "blank"

/obj/effect/distortion/large/long_legs
	icon_state = "leg_increase"
