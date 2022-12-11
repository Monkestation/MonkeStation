#define PROGRESSBAR_HEIGHT 6
#define PROGRESSBAR_ANIMATION_TIME 5

/datum/progressbar
	var/goal = 1
	var/last_progress = 0
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/listindex

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		EXCEPTION("Invalid target given")
	if (goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0", HUD_LAYER)
	bar.plane = ABOVE_HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User
	if(user)
		client = user.client

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len
	bar.pixel_y = 0
	bar.alpha = 0
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/proc/update(progress)
	if (!user || !user.client)
		shown = FALSE
		return
	if (user.client != client)
		if (client)
			client.images -= bar
		if (user.client)
			user.client.images += bar

	progress = CLAMP(progress, 0, goal)
	last_progress = progress
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if (!shown)
		user.client.images += bar
		shown = TRUE

/datum/progressbar/proc/shiftDown()
	--listindex
	bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
	var/dist_to_travel = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = dist_to_travel, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/Destroy()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"
	for(var/I in user?.progressbars[bar.loc])
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)

	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	addtimer(CALLBACK(src, .proc/remove_from_client), PROGRESSBAR_ANIMATION_TIME, TIMER_CLIENT_TIME)
	QDEL_IN(bar, PROGRESSBAR_ANIMATION_TIME * 2) //for garbage collection safety
	. = ..()

/datum/progressbar/proc/remove_from_client()
	if(client)
		client.images -= bar
		client = null

///Called on progress end, be it successful or a failure. Wraps up things to delete the datum and bar.
/datum/progressbar/proc/end_progress()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"
	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	QDEL_IN(src, PROGRESSBAR_ANIMATION_TIME)

////TODO: make prog_bars not really really bad just convert to a single image being transformed across a matrix

/obj/effect/world_progressbar
	///The progress bar visual element.
	icon = 'monkestation/icons/effects/progessbar.dmi'
	icon_state = "border"
	plane = RUNECHAT_PLANE
	appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM | KEEP_APART | TILE_BOUND
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_y = 32
	pixel_y = 32
	var/obj/effect/bar/bar
	var/obj/effect/additional_image/additional_image
	///The target where this progress bar is applied and where it is shown.
	var/atom/movable/bar_loc
	///The atom who "created" the bar
	var/atom/owner
	///Effectively the number of steps the progress bar will need to do before reaching completion.
	var/goal = 1
	///Control check to see if the progress was interrupted before reaching its goal.
	var/last_progress = 0
	///Variable to ensure smooth visual stacking on multiple progress bars.
	var/listindex = 0
	///the look of the bar inside the progress bar
	var/bar_look
	///does this use the old format of icons(useful for totally unqiue progress bars)
	var/old_format = FALSE

	///the color of the bar for new style bars
	var/finish_color
	var/active_color
	var/fail_color

/obj/effect/world_progressbar/Initialize(mapload, atom/owner, goal, atom/target, bar_look = "prog_bar", old_format = FALSE, active_color = "#6699FF", finish_color = "#FFEE8C", fail_color = "#FF0033" , mutable_appearance/additional_image)
	. = ..()
	if(!owner || !target || !goal)
		return INITIALIZE_HINT_QDEL

	src.bar_look = bar_look
	src.old_format = old_format
	src.owner = owner
	src.goal = goal
	src.bar_loc = target
	if(additional_image)
		src.additional_image = new /obj/effect/additional_image
		src.additional_image.icon = additional_image.icon
		src.additional_image.icon_state = additional_image.icon_state
		src.additional_image.plane = src.plane
		src.additional_image.layer = src.layer + 0.1
		src.additional_image.add_filter("outline", 1, list(type = "outline", size = 1,  color = "#FFFFFF"))
		src.bar_loc.vis_contents += src.additional_image

	src.bar_loc:vis_contents += src

	src.bar = new /obj/effect/bar
	src.bar.icon = icon
	src.bar.icon_state = bar_look
	src.bar.layer = src.layer +0.1
	src.bar.plane = src.plane
	src.bar_loc.vis_contents += src.bar
	src.bar.alpha = 0

	src.finish_color = finish_color
	src.active_color = active_color
	src.fail_color = fail_color

	src.add_filter("outline", 1, list(type = "outline", size = 1,  color = "#FFFFFF"))

	RegisterSignal(bar_loc, COMSIG_PARENT_QDELETING, .proc/bar_loc_delete)
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, .proc/owner_delete)

/obj/effect/world_progressbar/Destroy()
	owner = null
	bar_loc?:vis_contents -= src
	cut_overlays()
	return ..()

/obj/effect/world_progressbar/proc/bar_loc_delete()
	qdel(src)

/obj/effect/world_progressbar/proc/owner_delete()
	qdel(src)

///Updates the progress bar image visually.
/obj/effect/world_progressbar/proc/update(progress)
	bar.alpha = 255
	bar.color = active_color
	var/complete = clamp(progress / goal, 0, 1)
	progress = clamp(progress, 0, goal)
	if(progress == last_progress)
		return
	last_progress = progress
	if(old_format)
		bar.icon_state = "[bar_look]_[round(((progress / goal) * 100), 5)]"
	else
		bar.transform = matrix(complete, 0, -10 * (1 - complete), 0, 1, 0)

/obj/effect/world_progressbar/proc/end_progress()
	if(last_progress != goal)
		bar.icon_state = "[bar_look]_fail"
		bar.color = fail_color
	bar.color = finish_color
	animate(src, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	animate(src.bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	animate(src.additional_image, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)


	QDEL_IN(src, PROGRESSBAR_ANIMATION_TIME)
	QDEL_IN(src.bar, PROGRESSBAR_ANIMATION_TIME)
	QDEL_IN(src.additional_image, PROGRESSBAR_ANIMATION_TIME)

#undef PROGRESSBAR_ANIMATION_TIME
#undef PROGRESSBAR_HEIGHT

/obj/effect/bar
	plane = RUNECHAT_PLANE
	base_pixel_y = 32
	pixel_y = 32
	appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM | KEEP_APART | TILE_BOUND
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/additional_image
	plane = RUNECHAT_PLANE
	base_pixel_y = 32
	pixel_y = 32
	appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM | KEEP_APART | TILE_BOUND
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
