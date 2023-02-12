/atom/proc/apply_large_displacement_icon()
	var/obj/effect/distortion/large/distortion_effect = new
	src.add_filter("blank_large_displacemnt", 1, displacement_map_filter(size= -127 , render_source = distortion_effect.render_target))
	src.vis_contents += distortion_effect
