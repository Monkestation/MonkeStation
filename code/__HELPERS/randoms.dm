///Get a random food item exluding the blocked ones
/proc/get_random_food()
	var/list/blocked = list(/obj/item/food/bread,
		/obj/item/food/breadslice,
		/obj/item/food/cake,
		/obj/item/food/cakeslice,
		/obj/item/reagent_containers/food/snacks/store,
		/obj/item/food/pie,
		/obj/item/reagent_containers/food/snacks/kebab,
		/obj/item/food/pizza,
		/obj/item/food/pizzaslice,
		/obj/item/reagent_containers/food/snacks/salad,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat/slab,
		/obj/item/reagent_containers/food/snacks/soup,
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/food/deepfryholder,
		/obj/item/reagent_containers/food/snacks/clothing,
		/obj/item/reagent_containers/food/snacks/grown/shell, //base types
		/obj/item/food/bread,
		/obj/item/reagent_containers/food/snacks/grown/nettle
		)
	blocked |= typesof(/obj/item/reagent_containers/food/snacks/customizable)

	return pick(subtypesof(/obj/item/reagent_containers/food/snacks) - blocked)

///Gets a random drink excluding the blocked type
/proc/get_random_drink()
	var/list/blocked = list(/obj/item/reagent_containers/food/drinks/soda_cans,
		/obj/item/reagent_containers/food/drinks/bottle
		)
	return pick(subtypesof(/obj/item/reagent_containers/food/drinks) - blocked)

/// Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ion_num()
	return "[pick("!","@","#","$","%","^","&")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

/proc/random_nukecode()
	var/val = rand(0, 99999)
	var/str = "[val]"
	while(length(str) < 5)
		str = "0" + str
	. = str
