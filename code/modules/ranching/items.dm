/obj/structure/nestbox
	name = "Nesting Box"
	desc = "A warm box perfect for a chicken"
	density = FALSE
	icon = 'icons/obj/structures.dmi'
	icon_state = "nestbox"
	anchored = FALSE
	var/is_egg_on = FALSE

/obj/structure/nestbox/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/nestbox/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/structure/nestbox/process()
	if(locate(/obj/item/food/egg) in  get_turf(src))
		is_egg_on = TRUE
	else
		is_egg_on = FALSE
