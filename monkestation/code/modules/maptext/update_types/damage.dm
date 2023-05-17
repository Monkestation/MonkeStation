/obj/maptext/damage_popup
	maptext_width = 96

/obj/maptext/damage_popup/New(changed_value = 0)
	. = ..()

	if(abs(changed_value) < 1)
		qdel(src)
		return


	var/indicator_coloring = (changed_value < 0) ? "#09ff00" : "#ff0000"

	maptext = "<span style='color: [indicator_coloring];'> [changed_value < 0 ? "+" : "-"][round(changed_value, 1)]</span>"

	if(changed_value > 0)
		var/x_offset = rand(32, 78) * (prob(50) ? 1 : -1)
		var/y_offset = rand(60, 100)
		animate(src, maptext_y = y_offset, time = 8, easing = EASE_OUT | QUAD_EASING, flags = ANIMATION_RELATIVE)
		animate(alpha = -255, maptext_y = y_offset * -1, time = 8, easing = EASE_IN | QUAD_EASING, flags = ANIMATION_RELATIVE)
		animate(maptext_x = x_offset * 1.5, time = 16, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE)
	else
		animate(src, maptext_y = 56, time = 8, easing = EASE_OUT | QUAD_EASING)
		animate(time = 8)
		animate(maptext_y = 52, alpha = 0, time = 4, easing = EASE_OUT | CUBIC_EASING)

	addtimer(CALLBACK(src, .proc/delete_popup), 4 SECONDS)

/obj/maptext/damage_popup/proc/delete_popup()
	qdel(src)
