/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "This is the alpha and omega of sanitation."
	icon = 'monkestation/icons/obj/janitor/janitorial_cart.dmi'
	icon_state = "cart"
	max_integrity = 400
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
	if(broken)
		return
	create_reagents(400, OPENCONTAINER) //Let this be better than a normal bucket for a better early game

/obj/structure/janitorialcart/Destroy()
	if(broken)
		new /obj/item/stack/sheet/plastic(get_turf(src), 50)
		return ..()
	spill() //Spill out some contents
	drop_cart_contents() //Drop the rest at location
	cart_break_sounds()

	new /obj/structure/janitorialcart/broken(get_turf(src))
	return ..()

/obj/structure/janitorialcart/examine(mob/user)
	. = ..()
	if(broken)
		return
	. += span_info("<b>Click</b> with a wet mop to wring out the fluids into the mop bucket.")
	if(reagents.total_volume > 1)
		. += span_info("There is currently [reagents.total_volume] units in [src].")
		. += span_info("<b>Click</b> with a mop to wet it.")
		. += span_info("<b>Crowbar</b> it to empty it onto [get_turf(src)].")
	if(!mymop)
		. += span_info("<b>Click</b> with a dry mop to store it in [src]")
	if(mybag)
		. += span_info("<b>Click</b> with an object to put it in [mybag].")

/obj/structure/janitorialcart/proc/wet_mop(obj/item/mop/your_mop, mob/user)
	if(reagents.total_volume < 1)
		to_chat(user, span_warning("[src]'s mop bucket is empty!"))
		mop_insert_double_click = TRUE
		update_icon()
		return FALSE
	else
		reagents.trans_to(your_mop, your_mop.mopcap, transfered_by = user)
		to_chat(user, span_notice("You wet [your_mop] in [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		mop_insert_double_click = FALSE
	update_icon()
	return TRUE

/obj/structure/janitorialcart/proc/dry_mop(obj/item/mop/your_mop, mob/user)
	if(your_mop.reagents.total_volume <= 1)
		to_chat(user, span_warning("[your_mop] is as dry as a wet mop can get!"))
		return FALSE
	if(reagents.total_volume >= reagents.maximum_volume)
		to_chat(user, span_warning("[src]'s mop bucket is full!"))
		return FALSE
	your_mop.reagents.trans_to(src, reagents.maximum_volume, transfered_by = user)
	to_chat(user, span_notice("You wring [your_mop] out into the mop bucket using the wringer."))
	playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	mop_insert_double_click = TRUE
	update_icon()
	return TRUE

/obj/structure/janitorialcart/proc/put_in_cart(obj/item/Item, mob/user)
	if(!user.transferItemToLoc(Item, src))
		return FALSE
	to_chat(user, span_notice("You put [Item] into [src]."))
	update_icon()
	return TRUE

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/janitorialcart/proc/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if(mymop && prob(chance))
		mymop.forceMove(dropspot)
		mymop.tumble(2)
		mymop = null

	if(myspray && prob(chance))
		myspray.forceMove(dropspot)
		myspray.tumble(3)
		myspray = null

	if(myreplacer && prob(chance))
		myreplacer.forceMove(dropspot)
		myreplacer.tumble(3)
		myreplacer = null

	if(signs)
		for(var/obj/item/clothing/suit/caution/Sign in src)
			if(prob(min((chance*2),100)))
				signs--
				Sign.forceMove(dropspot)
				Sign.tumble(3)
				if(signs < 0)//safety for something that shouldn't happen
					signs = 0
					update_icon()
					return

	if(mybag && prob(min((chance*2),100)))//Bag is flimsy
		mybag.forceMove(dropspot)
		mybag.tumble(1)
		mybag.spill()//trashbag spills its contents too
		mybag = null

	update_icon()

/obj/structure/janitorialcart/proc/cart_break_sounds()
	if(!broken)
		if(prob(1))
			playsound(src, 'sound/misc/fart1.ogg', 100, 1)
		if(prob(1))
			playsound(src, 'sound/misc/sadtrombone.ogg', 100, 1)

		playsound(src, 'sound/effects/bodyfall3.ogg', 100, 1)

//Explosion spills a bit of everything out of the cart
/obj/structure/janitorialcart/ex_act(severity)
	if(broken)
		return
	spill(100 / severity)
	..()

//Drops the carts contents at turf location
/obj/structure/janitorialcart/proc/drop_cart_contents()
	var/turf/epicenter = src.loc
	if(reagents.total_volume > 0)
		epicenter.add_liquid_from_reagents(reagents)
		src.reagents.clear_reagents() //Clears any potential remaining reagents from mop bucket
	if(mybag)
		src.mybag.forceMove(epicenter)
	if(mymop)
		src.mymop.forceMove(epicenter)
	if(mybroom)
		src.mybroom.forceMove(epicenter)
	if(myspray)
		src.myspray.forceMove(epicenter)
	if(myreplacer)
		src.myreplacer.forceMove(epicenter)
	if(signs)
		for(var/obj/item/clothing/suit/caution/Sign in src)
			signs--
			Sign.forceMove(epicenter)
	update_icon()
	return

/obj/structure/janitorialcart/attackby(obj/item/Item, mob/user, params)
	var/fail_msg = span_warning("There is already a [Item] in [src]!")
	if(broken)
		return ..()
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

		if(your_mop.reagents.total_volume >= 20 && mop_insert_double_click == FALSE)
			if(dry_mop(your_mop, user))
				return

		if(your_mop.reagents.total_volume <= your_mop.reagents.maximum_volume)
			if(wet_mop(your_mop, user))
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

	else if(mybag)
		mybag.attackby(Item, user)

	if(Item.is_drainable())
		update_icon()
		return FALSE //so we can fill the cart via our afterattack without bludgeoning it

	return ..()

/obj/structure/janitorialcart/crowbar_act(mob/living/user, obj/item/Crowbar)
	..()
	. = TRUE
	if(user.a_intent == INTENT_HARM)
		return
	if(reagents.total_volume < 1)
		to_chat(user, span_warning("[src]'s mop bucket is empty!"))
		return
	user.visible_message(span_notice("[user] begins to empty the contents of [src]."), span_notice("You begin to empty the contents of [src]..."))
	if(Crowbar.use_tool(src, user, 5 SECONDS))
		to_chat(usr, span_notice("You empty the contents of [src]'s mop bucket onto the floor."))
		log_game("[user] emptied [src]'s mop bucket contents of [reagents.total_volume] units onto [get_turf(src)].")
		var/turf/epicenter = src.loc
		epicenter.add_liquid_from_reagents(reagents)
		src.reagents.clear_reagents() //Clears any potential remaining reagents from mop bucket
	update_icon()

/obj/structure/janitorialcart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(broken)
		return
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




//Cart States for Mapping fun. It just works.
///Loaded Cart
/obj/structure/janitorialcart/loaded
	name = "janitorial cart"
	icon_state = "cart_loaded"
	max_integrity = 400
	anchored = FALSE
	density = TRUE

/obj/structure/janitorialcart/loaded/Initialize(mapload)
	. = ..()
	mybag = new /obj/item/storage/bag/trash
	mymop = new /obj/item/mop
	mybroom = new /obj/item/pushbroom
	myspray = new /obj/item/reagent_containers/spray/cleaner
	myreplacer = new /obj/item/lightreplacer
	signs = new /obj/item/clothing/suit/caution
	signs = new /obj/item/clothing/suit/caution
	signs = new /obj/item/clothing/suit/caution
	signs = new /obj/item/clothing/suit/caution
	icon_state = "cart"
	update_icon()

///Random Load Cart
/obj/structure/janitorialcart/random_load
	name = "janitorial cart"
	icon_state = "cart_loaded"
	max_integrity = 400
	anchored = FALSE
	density = TRUE

/obj/structure/janitorialcart/random_load/Initialize(mapload)
	. = ..()
	if(!mybag && prob(30))
		mybag = new /obj/item/storage/bag/trash

	if(!mymop && prob(50))
		mymop = new /obj/item/mop

	if(!mybroom && prob(50))
		mybroom = new /obj/item/pushbroom

	if(!myspray && prob(40))
		myspray = new /obj/item/reagent_containers/spray/cleaner

	if(!myreplacer && prob(30))
		myreplacer = new /obj/item/lightreplacer

	if(!signs && prob(50))
		signs = new /obj/item/clothing/suit/caution
		if(prob(30))
			signs = new /obj/item/clothing/suit/caution
		if(prob(30))
			signs = new /obj/item/clothing/suit/caution
		if(prob(30))
			signs = new /obj/item/clothing/suit/caution

	if(reagents.total_volume <= 0 && prob(50))
		var/random_amount = roll("10d40") //Could randomize reagents types later
		reagents.add_reagent(/datum/reagent/water, random_amount)

	icon_state = "cart"
	update_icon()


/// Broken Cart
/obj/structure/janitorialcart/broken
	name = "broken janitorial cart"
	desc = "A broken down cart, not much of an alpha and omega of sanitation now."
	icon_state = "cart_destroyed"
	anchored = FALSE
	density = TRUE
	broken = TRUE
	max_integrity = 200
