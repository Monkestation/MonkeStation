/obj/machinery/mother_tree
	name = "Strange Tree"
	desc = "A strange tree sent by Nano-Transen, I'd be best if I kept this alive."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER -0.1

	///the list of level choices we currently have
	var/list/level_choices = list()
	///the component attached to the tree called often enough to justify defining it
	var/datum/component/botany_tree/attached_component

	var/current_leaf_stage = 2
	var/current_trunk_style = 1
	var/current_fruit_style = 1

	var/obj/effect/tree/trunk/trunk
	var/obj/effect/tree/leaf/leaves
	var/obj/effect/tree/fruit/fruits
	var/obj/effect/tree/accessory/accessories

	var/trunk_color = "#64483F"
	var/leaf_color = "#95B458"
	var/sapling_color = "#95B458"

	var/debug = FALSE

/obj/machinery/mother_tree/Initialize(mapload)
	. = ..()
	trunk = new()
	leaves = new()

	trunk.icon_state = "sapling_1"

	trunk.color = sapling_color
	leaves.color = leaf_color

	add_overlay(trunk)
	add_overlay(leaves)

	AddComponent(/datum/component/botany_tree)
	attached_component = src.GetComponent(/datum/component/botany_tree)

/obj/machinery/mother_tree/update_overlays()
	. = ..()

	trunk.icon_state = "trunk_[current_trunk_style]"
	leaves.icon_state = "leaf_[current_trunk_style]_[current_leaf_stage]"

	trunk.color = trunk_color
	leaves.color = leaf_color
	. += trunk
	. += leaves

	if(fruits)
		. += fruits

/obj/machinery/mother_tree/AltClick(mob/user)
	. = ..()
	if(!attached_component.unfufilled_requirements.len || debug)
		level_choices = attached_component.trigger_level()
		run_choice()
		return
	if(level_choices.len)
		run_choice()
		return

/obj/machinery/mother_tree/proc/run_choice()
	var/datum/tree_node/choice = input("Select a trait for the tree", "Strange Tree") as null|anything in level_choices
	if(!choice)
		return
	if(choice.visual_change)
		if(choice.color_change_trunk)
			trunk_color = choice.color_change_trunk
		if(choice.color_change_leaf)
			leaf_color = choice.color_change_leaf
		switch(choice.visual_change)
			if("Trunk")
				current_trunk_style = choice.visual_numerical_change
			if("Fruit")
				if(attached_component.current_level >= 5)
					if(!fruits)
						fruits = new()

					var/random_number = rand(fruits.offsets_for_sprites[current_trunk_style][1].len)
					var/picked_pixel_x = fruits.offsets_for_sprites[current_trunk_style][1][random_number]
					var/picked_pixel_y = fruits.offsets_for_sprites[current_trunk_style][2][random_number]

					fruits.offsets_for_sprites[current_trunk_style][2][random_number].Remove()
					fruits.offsets_for_sprites[current_trunk_style][1][random_number].Remove()

					var/image/new_image = image(fruits.icon, fruits, "fruit_[choice.visual_numerical_change]", fruits.layer, pixel_x = picked_pixel_x, pixel_y = picked_pixel_y)
					fruits.stored_images += new_image
					fruits.vis_contents += new_image
		update_overlays()

	attached_component.handle_added_node(choice)
	attached_component.handle_levelup()
	handle_levelup()
	level_choices = list()

/obj/machinery/mother_tree/proc/handle_levelup()
	var/current_level = attached_component.current_level


/obj/effect/tree
	icon = 'monkestation/icons/obj/mother_tree.dmi'
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -16
	pixel_y = 12
	///offsets for where the sprite should be placed goes x,y
	var/list/offsets_for_sprites

/obj/effect/tree/trunk
	icon_state = "tree_trunk_1"

/obj/effect/tree/leaf
	icon_state = "tree_leaf_1"

/obj/effect/tree/fruit
	var/list/stored_images
	offsets_for_sprites = list(
		//REGULAR TREE OFFSETS
		list(
			list(0,5,7,5,-12,24,11,-13,-22),
			list(0,5,3,12,15,-10,-16,-17,-5)
		),
		//STRANGE TREE OFFSETS
		list(
			list(4,0,17,17,22-14,-17),
			list(-1,19,19,8,4,2,15)
		)
	)
