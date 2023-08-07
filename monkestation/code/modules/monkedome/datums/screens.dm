/atom/movable/screen/fullscreen/trip
	icon_state = "trip"
	layer = TRIP_LAYER
	alpha = 0 //we animate it ourselves

//floor trip
/atom/movable/screen/fullscreen/ftrip
	icon_state = "ftrip"
	icon = 'monkestation/icons/mob/screen_full_big.dmi'
	screen_loc = "CENTER-9,CENTER-7"
	appearance_flags = TILE_BOUND
	layer = ABOVE_OPEN_TURF_LAYER
	plane = BLACKNESS_PLANE
	alpha = 0 //we animate it ourselves

//wall trip
/atom/movable/screen/fullscreen/gtrip
	icon_state = "gtrip"
	icon = 'monkestation/icons/mob/screen_full_big.dmi'
	screen_loc = "CENTER-9,CENTER-7"
	appearance_flags = TILE_BOUND
	layer = BELOW_MOB_LAYER
	plane = BLACKNESS_PLANE
	alpha = 0 //we animate it ourselves
