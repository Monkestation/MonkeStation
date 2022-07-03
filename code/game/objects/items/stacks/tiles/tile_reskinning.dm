/////////////////////
// Tile reskinning //
/////////////////////
// Q: What is this?
// A: A simple function to allow you to change what tiles you place with a stack of tiles.
// Q: Why do it this way?
// A: This allows players more freedom to do beautiful-looking builds.
// Q: Great! Can I use this for all floors?
// A: Unfortunately, this does not work on subtypes of plasteel and instead we must change the icon_state of these turfs instead, as the icon_regular_floor var that "saves" what type of floor a plasteel subtype turf was so once repaired...
// ... it'll go back to the floor it was instead of grey (medical floors turn white even after crowbaring the tile and putting it back). This stops changing turf_type from working.

GLOBAL_LIST_EMPTY(tile_reskin_lists)

/**
  * Caches associative lists with type path index keys and images of said type's initial icon state (typepath -> image).
  */
/obj/item/stack/tile/proc/tile_reskin_list(list/values)
	var/string_id = values.Join("-")
	. = GLOB.tile_reskin_lists[string_id]
	if(.)
		return
	for(var/path in values)
		var/obj/item/stack/tile/type_cast_path = path
		values[path] = image(icon = initial(type_cast_path.icon), icon_state = initial(type_cast_path.icon_state))
	return GLOB.tile_reskin_lists[string_id] = values


/obj/item/stack/tile/attack_self(mob/user)
	if(!tile_reskin_types)
		return ..()
	var/obj/item/stack/tile/choice = show_radial_menu(user, src, tile_reskin_types, radius = 48, require_near = TRUE)
	if(!choice || choice == type)
		return
	choice = new choice(user.drop_location(), amount)
	moveToNullspace()
	if(!QDELETED(choice)) // Tile could have merged with stuff on the ground. The user will have to pick it up if so.
		user.put_in_active_hand(choice)
	qdel(src)
