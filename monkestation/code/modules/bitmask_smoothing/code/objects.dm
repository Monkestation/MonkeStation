/obj/structure/barricade/sandbags
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/sandbags.dmi'
	icon_state = "sandbags-0"
	base_icon_state = "sandbags"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SANDBAGS)

/obj/structure/alien/weeds
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/weeds1.dmi'
	icon_state = "weeds1-0"
	base_icon_state = "weeds1"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WEEDS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WEEDS, SMOOTH_GROUP_WALLS)
	transform = matrix(1, 0, -4, 0, 1, -4)

/obj/structure/alien/resin/membrane
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/resin_membrane.dmi'
	icon_state = "resin_membrane-0"
	base_icon_state = "resin_membrane"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/obj/structure/bed/nest
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/nest.dmi'
	icon_state = "nest-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_NEST)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_NEST)
