/*
 *	Pre-packed boxes for testing purposes
 */

/obj/item/storage/box/oilgrenade
	name = "box of explosive slime grenade assemblies"
	desc = "BOOM!"
	icon_state = "syndiebox"

/obj/item/storage/box/oilgrenade/PopulateContents()
	var/static/items_inside = list(
		/obj/item/grenade/chem_grenade/large=2,
		/obj/item/slime_extract/oil=2,
		/obj/item/reagent_containers/glass/beaker/bluespace=2,
		/obj/item/reagent_containers/glass/bottle/plasma=8,
		/obj/item/stack/cable_coil=1,
		/obj/item/screwdriver=1)
	generate_items_inside(items_inside,src)
