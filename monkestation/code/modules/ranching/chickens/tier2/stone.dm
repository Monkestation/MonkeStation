#define MINIMUM_BREAK_FORCE 10
/mob/living/simple_animal/chicken/stone
	breed_name = "Stone"
	egg_type = /obj/item/food/egg/stone
	chicken_type = /mob/living/simple_animal/chicken/stone
	mutation_list = list(/datum/mutation/ranching/chicken/cockatrice)

/obj/item/food/egg/stone
	name = "Rocky Egg"
	icon_state = "stone"

/obj/item/food/egg/stone/attackby(obj/item/attacked_item, mob/user, params)
	. = ..()
	if(istype(attacked_item, /obj/item/stack/ore))
		visible_message("<span class='notice'>The [attacked_item] starts to melt into the [src]!</span>")
		production_type = attacked_item
		qdel(attacked_item)
	if(attacked_item.force > MINIMUM_BREAK_FORCE && production_type)
		visible_message("<span class='notice'>[src] is cracked open revealing [production_type.name] inside!</span>")

		new production_type.type(src.loc, 1)
		for(var/mob/living/simple_animal/chicken/viewer_chicken in view(3, src))
			visible_message("<span class='notice'>[viewer_chicken] becomes upset from seeing an egg broken near them!</span>")
			viewer_chicken.happiness -= 10
		qdel(src)
#undef MINIMUM_BREAK_FORCE
