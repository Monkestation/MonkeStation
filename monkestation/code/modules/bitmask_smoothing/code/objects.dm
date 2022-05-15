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

/obj/structure/lattice/catwalk
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk-0"
	base_icon_state = "catwalk"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_CATWALK, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_CATWALK)

/obj/structure/lattice
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice-255"
	base_icon_state = "lattice"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE)
	canSmoothWith = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_WALLS)

/////////////////////////////////////////
//             False Walls         	  //
///////////////////////////////////////

/obj/structure/falsewall
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)

/obj/structure/falsewall/reinforced
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK

/obj/structure/falsewall/uranium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_URANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_URANIUM_WALLS)

/obj/structure/falsewall/gold
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/gold_wall.dmi'
	icon_state = "gold_wall-0"
	base_icon_state = "gold_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_GOLD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_GOLD_WALLS)

/obj/structure/falsewall/silver
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/silver_wall.dmi'
	icon_state = "silver_wall-0"
	base_icon_state = "silver_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SILVER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SILVER_WALLS)

/obj/structure/falsewall/copper
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/copper_wall.dmi'
	icon_state = "copper_wall-0"
	base_icon_state = "copper_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_COPPER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_COPPER_WALLS)

/obj/structure/falsewall/diamond
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/diamond_wall.dmi'
	icon_state = "diamond_wall-0"
	base_icon_state = "diamond_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_DIAMOND_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_DIAMOND_WALLS)

/obj/structure/falsewall/plasma
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/plasma_wall.dmi'
	icon_state = "plasma_wall-0"
	base_icon_state = "plasma_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASMA_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_PLASMA_WALLS)

/obj/structure/falsewall/bananium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/bananium_wall.dmi'
	icon_state = "bananium_wall-0"
	base_icon_state = "bananium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_GOLD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_GOLD_WALLS)

/obj/structure/falsewall/sandstone
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SANDSTONE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SANDSTONE_WALLS)

/obj/structure/falsewall/wood
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WOOD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_WALLS)

/obj/structure/falsewall/bamboo
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/bamboo_wall.dmi'
	icon_state = "bamboo_wall-0"
	base_icon_state = "bamboo_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BAMBOO_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BAMBOO_WALLS)

/obj/structure/falsewall/iron
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-0"
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_IRON_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_IRON_WALLS)

/obj/structure/falsewall/abductor
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-0"
	base_icon_state = "abductor_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ABDUCTOR_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ABDUCTOR_WALLS)

/obj/structure/falsewall/plastitanium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_PLASTITANIUM_WALLS)

/obj/structure/falsewall/titanium
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-0"
	base_icon_state = "shuttle_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_TITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_TITANIUM_WALLS)

/obj/structure/falsewall/brass
	icon = 'monkestation/code/modules/bitmask_smoothing/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BRASS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BRASS_WALLS)

/////////////////////////////////////////
//             TABLES            	  //
///////////////////////////////////////

/obj/structure/table
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/table.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_TABLES)

/obj/structure/table/glass
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/glass_table.dmi'
	icon_state = "glass_table-0"
	bas_icon_state = "glass_table"
	smoothing_groups = list(SMOOTH_GROUP_GLASS_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_GLASS_TABLES)

/obj/structure/table/wood
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	smoothing_groups = list(SMOOTH_GROUP_WOOD_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_TABLES)

/obj/structure/table/wood/poker
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/poker_table.dmi'
	icon_state = "poker_table-0"
	base_icon_state = "poker_table"

/obj/structure/table/wood/fancy
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/structures.dmi'
	base_icon_state = "fancy_table"
	smoothing_groups = list(SMOOTH_GROUP_FANCY_WOOD_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES or SMOOTH_GROUP_WOOD_TABLES
	canSmoothWith = list(SMOOTH_GROUP_FANCY_WOOD_TABLES)

/obj/structure/table/wood/fancy/black
	base_icon_state = "fancy_table_black"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_black.dmi'

/obj/structure/table/wood/fancy/blue
	base_icon_state = "fancy_table_blue"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_blue.dmi'

/obj/structure/table/wood/fancy/cyan
	base_icon_state = "fancy_table_cyan"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_cyan.dmi'

/obj/structure/table/wood/fancy/green
	base_icon_state = "fancy_table_green"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_green.dmi'

/obj/structure/table/wood/fancy/orange
	base_icon_state = "fancy_table_orange"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_orange.dmi'

/obj/structure/table/wood/fancy/purple
	base_icon_state = "fancy_table_purple"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_purple.dmi'

/obj/structure/table/wood/fancy/red
	base_icon_state = "fancy_table_red"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_red.dmi'

/obj/structure/table/wood/fancy/royalblack
	base_icon_state = "fancy_table_royalblack"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_royalblack.dmi'

/obj/structure/table/wood/fancy/royalblue
	base_icon_state = "fancy_table_royalblue"
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table_royalblue.dmi'

/obj/structure/table/reinforced
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/reinforced_table.dmi'
	icon_state = "reinforced_table-0"
	base_icon_state = "reinforced_table"

/obj/structure/table/brass
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table-0"
	base_icon_state = "brass_table"
	smoothing_groups = list(SMOOTH_GROUP_BRONZE_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_BRONZE_TABLES)

/obj/structure/table/bronze
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table-0"
	base_icon_state = "brass_table"
	smoothing_groups = list(SMOOTH_GROUP_BRONZE_TABLES) //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = list(SMOOTH_GROUP_BRONZE_TABLES)
