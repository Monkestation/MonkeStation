//Metal Hydrogen
GLOBAL_LIST_INIT(metalhydrogen_recipes, list(
	new /datum/stack_recipe("incomplete servant golem shell", /obj/item/golem_shell/servant, req_amount=20, res_amount=1),
	))

/obj/item/stack/sheet/mineral/metal_hydrogen
	name = "Metal Hydrogen"
	icon_state = "sheet-metalhydrogen"
	item_state = "sheet-metalhydrogen"
	singular_name = "Metal Hydrogen sheet"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE
	point_value = 100
	custom_materials = list(/datum/material/metalhydrogen=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/metal_hydrogen

