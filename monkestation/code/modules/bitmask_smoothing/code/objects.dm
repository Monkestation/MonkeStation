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
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WEEDS)
	transform = matrix(1, 0, -4, 0, 1, -4)

/obj/structure/alien/resin/membrane
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/resin_membrane.dmi'
	icon_state = "resin_membrane-0"
	base_icon_state = "resin_membrane"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/obj/structure/bed/nest
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/alien/nest.dmi'
	base_icon_state = "nest"
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
	canSmoothWith = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)

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
	base_icon_state = "glass_table"
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
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table.dmi'
	smooth_icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/fancy_table.dmi'
	icon_state = "fancy_table-0"
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

/////////////////////////////////////////
//             WINDOWS            	  //
///////////////////////////////////////

/obj/structure/window/plastitanium
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)

/obj/structure/window/paperframe
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/paperframes.dmi'
	icon_state = "paperframes-0"
	base_icon_state = "paperframes"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_PAPERFRAME)
	canSmoothWith = list(SMOOTH_GROUP_PAPERFRAME)

/obj/structure/table/survival_pod
	smoothing_flags = NONE

/obj/structure/alien/resin/flower_bud_enemy //inheriting basic attack/damage stuff from alien structures
	smoothing_flags = NONE

/obj/structure/table/glass/plasma
	icon = 'monkestation/code/modules/bitmask_smoothing/obj/smooth_structures/plasmaglass_table.dmi'
	icon_state = "plasmaglass_table-0"
	base_icon_state = "plasmaglass_table"

/obj/machinery/door/airlock
	smoothing_groups = list(SMOOTH_GROUP_AIRLOCK)
