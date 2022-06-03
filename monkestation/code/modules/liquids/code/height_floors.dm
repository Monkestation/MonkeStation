/obj/item/stack/tile/elevated
	name = "elevated floor tile"
	singular_name = "elevated floor tile"
	turf_type = /turf/open/floor/elevated
	icon = 'monkestation/code/modules/liquids/icons/obj/items/tiles.dmi'
	icon_state = "elevated"

/obj/item/stack/tile/lowered
	name = "lowered floor tile"
	singular_name = "lowered floor tile"
	turf_type = /turf/open/floor/lowered
	icon = 'monkestation/code/modules/liquids/icons/obj/items/tiles.dmi'
	icon_state = "lowered"

/obj/item/stack/tile/lowered/iron/pool
	name = "pool floor tile"
	singular_name = "pool floor tile"
	turf_type = /turf/open/floor/lowered/iron/pool
	icon = 'monkestation/code/modules/liquids/icons/obj/items/tiles.dmi'
	icon_state = "pool"

/turf/open/floor/lowered/iron/pool
	name = "pool floor"
	floor_tile = /obj/item/stack/tile/lowered/iron/pool
	icon = 'monkestation/code/modules/liquids/icons/turf/pool_tile.dmi'
	base_icon_state = "pool_tile"
	icon_state = "pool_tile"
	liquid_height = -30
	turf_height = -30


/turf/open/floor/iron/pool/rust_heretic_act()
	return

/turf/open/floor/elevated
	name = "elevated floor"
	floor_tile = /obj/item/stack/tile/elevated
	icon = 'monkestation/code/modules/liquids/icons/turf/elevated_plasteel.dmi'
	icon_state = "elevated_plasteel-0"
	base_icon_state = "elevated_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ELEVATED_PLASTEEL)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ELEVATED_PLASTEEL)
	liquid_height = 30
	turf_height = 30

/turf/open/floor/elevated/rust_heretic_act()
	return

/turf/open/floor/lowered
	name = "lowered floor"
	floor_tile = /obj/item/stack/tile/lowered
	icon = 'monkestation/code/modules/liquids/icons/turf/lowered_plasteel.dmi'
	icon_state = "lowered_plasteel-0"
	base_icon_state = "lowered_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_LOWERED_PLASTEEL)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_LOWERED_PLASTEEL)
	liquid_height = -30
	turf_height = -30


/turf/open/floor/lowered/rust_heretic_act()
	return
