/obj/structure/alien/resin
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_RESIN)

/obj/structure/alien/resin/wall
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/turf/closed/mineral/snowmountain/cavern
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/mining.dmi'
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/icerock_wall.dmi'
	icon_state = "icerock_wall-0"
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER

////////////////////////////////////////
// MINERAL WALL
///////////////////////////////////////

/obj/effect/clockwork/overlay/wall
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"

/turf/closed/indestructible/hotelwall
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_HOTEL_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_HOTEL_WALLS)

/turf/closed/indestructible/turbolift
	smoothing_flags = SMOOTH_BITMASK


