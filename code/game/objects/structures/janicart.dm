/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "This is the alpha and omega of sanitation."
	icon = 'monkestation/icons/obj/janitor/janitorial_cart.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

	//Is there a trash bag in the cart?
	var/obj/item/storage/bag/trash/mybag
	//Is there a mop in the cart?
	var/obj/item/mop/mymop
	//Is there a broom in the cart?
	var/obj/item/pushbroom/mybroom
	//Is there cleaner spray in the cart?
	var/obj/item/reagent_containers/spray/cleaner/myspray
	//Is there a light replacer in the cart?
	var/obj/item/lightreplacer/myreplacer
	//Is there signs in the cart?
	var/signs = 0
	//The max amount of signs the cart can store
	var/max_signs = 4
	//Allows for mop to insert into cart after drying
	var/mop_insert_double_click = FALSE


/obj/structure/janitorialcart/Initialize(mapload)
	. = ..()
	create_reagents(400, OPENCONTAINER)

/obj/structure/janitorialcart/examine(mob/user)
	. = ..()
	. += span_info("<b>Click</b> with a wet mop to wring out the fluids into the mop bucket.")
	if(reagents.total_volume > 1)
		. += span_info("<b>Click</b> with a mop to wet it.")
		. += span_info("There is currently [reagents.total_volume] units in [src].")
		. += span_info("<b>Crowbar</b> it to empty it onto [get_turf(src)].")
	if(!mymop)
		. += span_info("<b>Click</b> with a dry mop to store it in [src]")
	if(mybag)
		. += span_info("<b>Click</b> with an object to put it in [mybag].")

/obj/structure/janitorialcart/proc/wet_mop(obj/item/mop/your_mop, mob/user)
	if(your_mop.reagents.total_volume >= your_mop.reagents.maximum_volume)
		to_chat(user, span_warning("[your_mop] is already soaked!"))
		return FALSE
	if(reagents.total_volume < 1)
		to_chat(user, span_warning("[src]'s mop bucket is empty!"))
		mop_insert_double_click = TRUE
		return FALSE
	reagents.trans_to(your_mop, your_mop.reagents.maximum_volume, transfered_by = user)
	to_chat(user, span_notice("You wet [your_mop] in [src]."))
	playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	mop_insert_double_click = FALSE
	return TRUE

/obj/structure/janitorialcart/proc/dry_mop(obj/item/mop/your_mop, mob/user)
	if(your_mop.reagents.total_volume <= 20)
		to_chat(user, span_warning("[your_mop] is as dry as a wet mop can get!"))
		return FALSE
	if(reagents.total_volume >= reagents.maximum_volume)
		to_chat(user, span_warning("[src]'s mop bucket is full!"))
		return FALSE
	your_mop.reagents.trans_to(src, reagents.maximum_volume, transfered_by = user)
	to_chat(user, span_notice("You wring [your_mop] out into the mop bucket using the wringer."))
	playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	mop_insert_double_click = TRUE
	return TRUE

/obj/structure/janitorialcart/proc/put_in_cart(obj/item/Item, mob/user)
	if(!user.transferItemToLoc(Item, src))
		return FALSE
	to_chat(user, span_notice("You put [Item] into [src]."))
	update_icon()
	return TRUE

/obj/structure/janitorialcart/attackby(obj/item/Item, mob/user, params)
	var/fail_msg = span_warning("There is already a [Item] in [src]!")

	if(istype(Item, /obj/item/mop))
		if(mymop)
			to_chat(user, fail_msg)
			return
		var/obj/item/mop/your_mop = Item
		if(your_mop.reagents.total_volume <= 20 && mop_insert_double_click == TRUE)
			mymop = Item
			mop_insert_double_click = FALSE
			if(!put_in_cart(Item, user))
				mymop = null
			return
		if(your_mop.reagents.total_volume <= your_mop.reagents.maximum_volume)
			if(wet_mop(your_mop, user))
				return
		if(your_mop.reagents.total_volume >= 20 && mop_insert_double_click == FALSE)
			if(dry_mop(your_mop, user))
				return
		return

	else if(istype(Item, /obj/item/pushbroom))
		if(mybroom)
			to_chat(user, fail_msg)
			return
		mybroom = Item
		if(!put_in_cart(Item, user))
			mybroom = null
		return

	else if(istype(Item, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, fail_msg)
			return
		mybag = Item
		if(!put_in_cart(Item, user))
			mybag = null
		return

	else if(istype(Item, /obj/item/reagent_containers/spray/cleaner))
		if(myspray)
			to_chat(user, fail_msg)
			return
		myspray = Item
		if(!put_in_cart(Item, user))
			myspray = null
		return

	else if(istype(Item, /obj/item/lightreplacer))
		if(myreplacer)
			to_chat(user, fail_msg)
			return
		myreplacer = Item
		if(!put_in_cart(Item, user))
			myreplacer = null
		return

	else if(istype(Item, /obj/item/clothing/suit/caution))
		if(signs >= max_signs)
			to_chat(user, span_warning("[src] can't hold any more signs!"))
			return
		signs++
		if(!put_in_cart(Item, user))
			signs--
		return

	else if(Item.tool_behaviour == TOOL_CROWBAR)
		if(reagents.total_volume < 1)
			to_chat(user, span_warning("[src]'s mop bucket is empty!"))
			return
		user.visible_message(span_notice("[user] begins to empty the contents of [src]."), span_notice("You begin to empty the contents of [src]..."))
		if(Item.use_tool(src, user, 5 SECONDS))
			to_chat(usr, span_notice("You empty the contents of [src]'s mop bucket onto the floor."))
			reagents.reaction(src.loc)
			src.reagents.clear_reagents()
			update_icon()
		return

	else if(mybag)
		mybag.attackby(Item, user)

	if(Item.is_drainable())
		return FALSE //so we can fill the cart via our afterattack without bludgeoning it

	return ..()


/obj/structure/janitorialcart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/list/items = list()
	if(mybag)
		items += list("Trash bag" = image(icon = mybag.icon, icon_state = mybag.icon_state))
	if(mymop)
		items += list("Mop" = image(icon = mymop.icon, icon_state = mymop.icon_state))
	if(mybroom)
		items += list("Broom" = image(icon = mybroom.icon, icon_state = mybroom.icon_state))
	if(myspray)
		items += list("Spray bottle" = image(icon = myspray.icon, icon_state = myspray.icon_state))
	if(myreplacer)
		items += list("Light replacer" = image(icon = myreplacer.icon, icon_state = myreplacer.icon_state))
	var/obj/item/clothing/suit/caution/sign = locate() in src
	if(sign)
		items += list("Sign" = image(icon = sign.icon, icon_state = sign.icon_state))

	if(!length(items))
		return

	var/pick = items[1]
	if(length(items) > 1)
		items = sort_list(items)
		pick = show_radial_menu(user, src, items, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 38, require_near = TRUE)

	if(!pick)
		return
	switch(pick)
		if("Trash bag")
			if(!mybag)
				return
			user.put_in_hands(mybag)
			to_chat(user, span_notice("You take [mybag] from [src]."))
			mybag = null
		if("Mop")
			if(!mymop)
				return
			user.put_in_hands(mymop)
			to_chat(user, span_notice("You take [mymop] from [src]."))
			mymop = null
		if("Broom")
			if(!mybroom)
				return
			user.put_in_hands(mybroom)
			to_chat(user, span_notice("You take [mybroom] from [src]."))
			mybroom = null
		if("Spray bottle")
			if(!myspray)
				return
			user.put_in_hands(myspray)
			to_chat(user, span_notice("You take [myspray] from [src]."))
			myspray = null
		if("Light replacer")
			if(!myreplacer)
				return
			user.put_in_hands(myreplacer)
			to_chat(user, span_notice("You take [myreplacer] from [src]."))
			myreplacer = null
		if("Sign")
			if(signs <= 0)
				return
			user.put_in_hands(sign)
			to_chat(user, span_notice("You take \a [sign] from [src]."))
			signs--
		else
			return

	update_icon()

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/structure/janitorialcart/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/structure/janitorialcart/update_overlays()
	. = ..()
	if(mybag)
		if(istype(mybag, /obj/item/storage/bag/trash/bluespace))
			. += "cart_bluespace_garbage"
		else
			. += "cart_garbage"
	if(mymop)
		. += "cart_mop"
	if(mybroom)
		. += "cart_broom"
	if(myspray)
		. += "cart_spray"
	if(myreplacer)
		. += "cart_replacer"
	if(signs)
		. += "cart_sign[signs]"
	if(reagents.total_volume > 0)
		. += "cart_water"
