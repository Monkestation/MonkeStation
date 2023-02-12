/obj/effect/distortion
	icon = 'monkestation/icons/effects/displacement_maps.dmi'
	appearance_flags = PIXEL_SCALE | RESET_COLOR | RESET_TRANSFORM | RESET_ALPHA | NO_CLIENT_COLOR
	vis_flags = VIS_INHERIT_DIR

/obj/effect/distortion/Initialize(mapload)
	. = ..()
	render_target = "*\ref[src]"
