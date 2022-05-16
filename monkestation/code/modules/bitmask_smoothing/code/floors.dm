/turf/open/indestructible/hierophant
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/hierophant_floor.dmi'
	smoothing_flags = SMOOTH_CORNERS

/turf/open/chasm
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/chasms.dmi'
	icon_state = "chasms-255"
	base_icon_state = "chasms"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_TURF_CHASM)
	canSmoothWith = list(SMOOTH_GROUP_TURF_CHASM)

/turf/open/floor/bamboo
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/bamboo_mat.dmi'
	icon_state = "mat-0"
	base_icon_state = "mat"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_BAMBOO_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_BAMBOO_FLOOR)

/turf/open/floor/carpet
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet.dmi'
	icon_state = "carpet-255"
	base_icon_state = "carpet"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET)
	canSmoothWith = list(SMOOTH_GROUP_CARPET)

/turf/open/floor/carpet/black
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_black.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_BLACK)

/turf/open/floor/carpet/blue
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_blue.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_BLUE)

/turf/open/floor/carpet/cyan
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_cyan.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_CYAN)

/turf/open/floor/carpet/green
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_green.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_GREEN)

/turf/open/floor/carpet/orange
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_orange.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ORANGE)

/turf/open/floor/carpet/purple
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_purple.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_PURPLE)

/turf/open/floor/carpet/red
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_red.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_RED)

/turf/open/floor/carpet/royalblack
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_royalblack.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ROYAL_BLACK)

/turf/open/floor/carpet/royalblue
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_royalblue.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ROYAL_BLUE)

/turf/open/floor/carpet/grimy
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/carpet_grimy.dmi'
	canSmoothWith = list(SMOOTH_GROUP_CARPET_GRIMY)

/turf/open/floor/fakepit
	base_icon_state = "chasms"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_TURF_CHASM)
	canSmoothWith = list(SMOOTH_GROUP_TURF_CHASM)
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/floors/Chasms.dmi'
	icon_state = "chasms-0"
