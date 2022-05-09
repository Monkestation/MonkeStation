/obj/item/stack/tile/iron/elevated
	name = "elevated floor tile"
	singular_name = "elevated floor tile"
	turf_type = /turf/open/floor/iron/elevated
	icon = 'monkestation/code/modules/liquids/icons/items/tiles.dmi'
	icon_state = "elevated"

/obj/item/stack/tile/iron/lowered
	name = "lowered floor tile"
	singular_name = "lowered floor tile"
	turf_type = /turf/open/floor/iron/lowered
	icon = 'monkestation/code/modules/liquids/icons/items/tiles.dmi'
	icon_state = "lowered"
/obj/item/stack/tile/iron/pool
	name = "pool floor tile"
	singular_name = "pool floor tile"
	turf_type = /turf/open/floor/iron/pool
	icon = 'monkestation/code/modules/liquids/icons/items/tiles.dmi'
	icon_state = "pool"

/turf/open/floor/iron/pool
	name = "pool floor"
	floor_tile = /obj/item/stack/tile/iron/pool
	icon = 'monkestation/code/modules/liquids/icons/turf/pool_tile.dmi'
	base_icon_state = "pool_tile"
	icon_state = "pool_tile"
	liquid_height = -30
	turf_height = -30


/turf/open/floor/iron/pool/rust_heretic_act()
	return

/turf/open/floor/iron/elevated
	name = "elevated floor"
	floor_tile = /obj/item/stack/tile/iron/elevated
	icon = 'monkestation/code/modules/liquids/icons/turf/elevated_iron.dmi'
	icon_state = "elevated_plasteel-0"
	base_icon_state = "elevated_plasteel"
	liquid_height = 30
	turf_height = 30


/turf/open/floor/iron/elevated/rust_heretic_act()
	return

/turf/open/floor/iron/lowered
	name = "lowered floor"
	floor_tile = /obj/item/stack/tile/iron/lowered
	icon = 'monkestation/code/modules/liquids/icons/turf/lowered_iron.dmi'
	icon_state = "lowered_plasteel-0"
	base_icon_state = "lowered_plasteel"
	liquid_height = -30
	turf_height = -30


/turf/open/floor/iron/lowered/rust_heretic_act()
	return
