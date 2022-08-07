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

/turf/closed/mineral //wall piece
	icon_state = "rock"
	base_icon_state = "smoothrocks"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_MINERAL_WALLS)

/turf/closed/mineral/iron/ice
	base_icon_state = "icerock_wall"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/icerock_wall.dmi'

/turf/closed/mineral/diamond/ice
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/icerock_wall.dmi'
	base_icon_state = "icerock_wall"

/turf/closed/mineral/plasma/ice
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/icerock_wall.dmi'
	base_icon_state = "icerock_wall"

/turf/closed/mineral/ash_rock //wall piece
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/mining.dmi'
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/rock_wall.dmi'
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)

/turf/closed/mineral/snowmountain
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/mining.dmi'
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/mountain_wall.dmi'
	icon_state = "mountain_wall-0"
	base_icon_state = "mountain_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)

/turf/closed/mineral/snowmountain/cavern
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/mining.dmi'
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/icerock_wall.dmi'
	icon_state = "icerock_wall-0"
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER

////////////////////////////////////////
// MINERAL WALL
///////////////////////////////////////

/turf/closed/wall/mineral/reinforced
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/mineral/brass
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BRASS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BRASS_WALLS)

/obj/effect/clockwork/overlay/wall
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BRASS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BRASS_WALLS)

/obj/effect/temp_visual/hierophant/wall //smoothing and pooling were not friends, but pooling is dead.
	icon_state = "hierophant_wall_temp-0"
	base_icon_state = "hierophant_wall_temp"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_HIERO_WALL)
	canSmoothWith = list(SMOOTH_GROUP_HIERO_WALL)

/obj/effect/temp_visual/elite_tumor_wall
	icon_state = "hierophant_wall_temp-0"
	base_icon_state = "hierophant_wall_temp"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_HIERO_WALL)
	canSmoothWith = list(SMOOTH_GROUP_HIERO_WALL)

/turf/closed/indestructible/hotelwall
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_HOTEL_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_HOTEL_WALLS)

/turf/closed/indestructible/turbolift
	smoothing_flags = SMOOTH_BITMASK


/turf/closed/wall/mineral/titanium/survival/pod
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_SURVIVAL_TIANIUM_POD)
	canSmoothWith = list(SMOOTH_GROUP_SURVIVAL_TIANIUM_POD)
