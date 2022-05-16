/obj/structure/alien/resin
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_RESIN)

/obj/structure/alien/resin/wall
	icon = 'icons/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/turf/closed/indestructible/sandstone
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/riveted
	icon = 'iconturf/walls/riveted.dmi'
	icon_state = "riveted-0"
	base_icon_state = "riveted"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)

/turf/closed/indestructible/syndicate
	icon = 'iconturf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SYNDICATE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)

/turf/closed/indestructible/riveted/uranium
	icon = 'iconturf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/fakeglass
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi'
	icon_state = "fake_window"
	base_icon_state = "reinforced_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/closed/indestructible/opsglass
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)

/turf/closed/indestructible/riveted/boss
	icon = 'icon/turf/walls/boss_wall.dmi'
	icon_state = "boss_wall-0"
	base_icon_state = "boss_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_BOSS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BOSS_WALLS)

////////////////////////////////////////
// MINERAL WALL
///////////////////////////////////////


/turf/closed/wall/mineral
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)

/turf/closed/wall/mineral/reinforced
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/mineral/uranium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_URANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_URANIUM_WALLS)

/turf/closed/wall/mineral/gold
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/gold_wall.dmi'
	icon_state = "gold_wall-0"
	base_icon_state = "gold_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_GOLD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_GOLD_WALLS)

/turf/closed/wall/mineral/silver
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/silver_wall.dmi'
	icon_state = "silver_wall-0"
	base_icon_state = "silver_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SILVER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SILVER_WALLS)

/turf/closed/wall/mineral/copper
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/copper_wall.dmi'
	icon_state = "copper_wall-0"
	base_icon_state = "copper_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_COPPER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_COPPER_WALLS)

/turf/closed/wall/mineral/diamond
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/diamond_wall.dmi'
	icon_state = "diamond_wall-0"
	base_icon_state = "diamond_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_DIAMOND_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_DIAMOND_WALLS)

/turf/closed/wall/mineral/plasma
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/plasma_wall.dmi'
	icon_state = "plasma_wall-0"
	base_icon_state = "plasma_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASMA_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_PLASMA_WALLS)

/turf/closed/wall/mineral/bananium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/bananium_wall.dmi'
	icon_state = "bananium_wall-0"
	base_icon_state = "bananium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_GOLD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_GOLD_WALLS)

/turf/closed/wall/mineral/sandstone
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SANDSTONE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SANDSTONE_WALLS)

/turf/closed/wall/mineral/wood
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WOOD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_WALLS)

/turf/closed/wall/mineral/bamboo
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/bamboo_wall.dmi'
	icon_state = "bamboo_wall-0"
	base_icon_state = "bamboo_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BAMBOO_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BAMBOO_WALLS)

/turf/closed/wall/mineral/iron
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-0"
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_IRON_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_IRON_WALLS)

/turf/closed/wall/mineral/abductor
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-0"
	base_icon_state = "abductor_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ABDUCTOR_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ABDUCTOR_WALLS)

/turf/closed/wall/mineral/plastitanium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_PLASTITANIUM_WALLS)

/turf/closed/wall/mineral/titanium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-0"
	base_icon_state = "shuttle_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_TITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_TITANIUM_WALLS)

/turf/closed/wall/mineral/brass
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BRASS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BRASS_WALLS)

