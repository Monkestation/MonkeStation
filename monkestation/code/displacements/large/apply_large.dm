/atom/movable/proc/apply_large_displacement_icon(obj/effect/distortion/large/type)
	var/obj/effect/distortion/large/distortion_effect = new(type)
	src.add_filter("large_displacement_[initial(type.name)]", 1, displacement_map_filter(size= -127 , render_source = distortion_effect.render_target))
	src.vis_contents += distortion_effect
