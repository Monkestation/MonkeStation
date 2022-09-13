#define SHARP_WEAPON_TRANSFORMATIONS list(/obj/item/claymore, /obj/item/katana, /obj/item/melee/sabre)
#define BLUNT_WEAPON_TRANSFORMATIONS list(/obj/item/staff/bostaff, /obj/item/melee/baseball_bat, /obj/item/club)

/obj/item/autosurgeon/neuromod/weapon_transformation
	name = "weapon transformation neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/weapon_transformation)

/obj/item/organ/cyberimp/neuromod/weapon_transformation
	name = "Weapon Transformation"
	desc = "This neuromod allows you to transform normal items into weapons."
	cooldown = 2 MINUTES
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/weapon_transformation/ui_action_click()
	. = ..()
	if(.)
		return
	var/list/hand_items = list(owner.get_active_held_item(),owner.get_inactive_held_item())
	for(var/obj/item/item in hand_items) //Put the item away
		if(item.item_flags & ABSTRACT)
			continue

		var/obj/item/new_item = get_item(item)
		owner.visible_message("<span class='notice'>\The [item] turns into a [new_item].</span>","<span class='notice'>\The [item] turns black, before reshaping into a [new_item].</span>")
		item.forceMove(new_item)
		owner.put_in_hands(new_item)
		addtimer(CALLBACK(src, .proc/untransform, new_item, item), 45 SECONDS)
		break

/obj/item/organ/cyberimp/neuromod/weapon_transformation/proc/get_item(obj/item/item)
	var/list/possible_items = list()
	var/list/priority_items = list()
	if(item.is_sharp() || is_pointed(item))
		possible_items |= SHARP_WEAPON_TRANSFORMATIONS
	if(!item.is_sharp() && !is_pointed(item))
		possible_items |= BLUNT_WEAPON_TRANSFORMATIONS
	// Priority Items
	if(istype(item,/obj/item/toy/sword))
		priority_items |= list(/obj/item/melee/transforming/energy/sword/bananium,/obj/item/melee/transforming/energy/sword/saber/blue)
	if(istype(item,/obj/item/toy/katana))
		priority_items |= list(/obj/item/katana)

	var/obj/item/new_item = priority_items.len ? pick(priority_items) : pick(possible_items)

	if(!new_item) //Fallback weapon, just in case
		new_item = /obj/item/crowbar

	return new_item

/obj/item/organ/cyberimp/neuromod/weapon_transformation/proc/untransform(obj/current_item, obj/original_item)
	var/current_loc = current_item.loc
	original_item.visible_message("<span class='notice'>\The [current_item] reverts back into a [original_item].</span>")
	if(ismob(current_loc))
		var/mob/wielder = current_loc
		current_item.moveToNullspace()
		wielder.put_in_hands(original_item)
	else
		original_item.forceMove(current_loc)
	qdel(current_item)


#undef SHARP_WEAPON_TRANSFORMATIONS
#undef BLUNT_WEAPON_TRANSFORMATIONS
