//NEVER USE THIS IT SUX	-PETETHEGOAT
//IT SUCKS A BIT LESS -GIACOM

/obj/item/paint
	gender= PLURAL
	name = "paint"
	desc = "Used to recolor floors and walls. Can be removed by the janitor."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_neutral"
	var/paint_color = "FFFFFF"
	item_state = "paintcan"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	max_integrity = 100
	var/paintleft = 10

/obj/item/paint/examine(mob/user)
	. = ..()
	. += span_notice("Paint wall stripes by right clicking a walls.")

/obj/item/paint/red
	name = "red paint"
	paint_color = "C73232" //"FF0000"
	icon_state = "paint_red"

/obj/item/paint/anycolor/examine(mob/user)
	. = ..()
	. += span_notice("Choose a basic color by using the paint.")
	. += span_notice("Choose any color by alt-clicking the paint.")

/obj/item/paint/anycolor/AltClick(mob/living/user)
	var/new_paint_color = input(user, "Choose new paint color", "Paint Color", paint_color) as color|null
	if(new_paint_color)
		paint_color = new_paint_color
		icon_state = "paint_neutral"

/obj/item/paint/green
	name = "green paint"
	paint_color = "2A9C3B" //"00FF00"
	icon_state = "paint_green"

/obj/item/paint/blue
	name = "blue paint"
	paint_color = "5998FF" //"0000FF"
	icon_state = "paint_blue"

/obj/item/paint/yellow
	name = "yellow paint"
	paint_color = "CFB52B" //"FFFF00"
	icon_state = "paint_yellow"

/obj/item/paint/violet
	name = "violet paint"
	paint_color = "AE4CCD" //"FF00FF"
	icon_state = "paint_violet"

/obj/item/paint/black
	name = "black paint"
	paint_color = "333333"
	icon_state = "paint_black"

/obj/item/paint/white
	name = "white paint"
	paint_color = "FFFFFF"
	icon_state = "paint_white"


/obj/item/paint/anycolor
	gender = PLURAL
	name = "adaptive paint"
	icon_state = "paint_neutral"

/obj/item/paint/anycolor/attack_self(mob/user)
	var/t1 = input(user, "Please select a color:", "[src]", null) in sortList(list( "red", "blue", "green", "yellow", "violet", "black", "white"))
	if ((user.get_active_held_item() != src || user.stat || user.restrained()))
		return
	switch(t1)
		if("red")
			paint_color = "C73232"
		if("blue")
			paint_color = "5998FF"
		if("green")
			paint_color = "2A9C3B"
		if("yellow")
			paint_color = "CFB52B"
		if("violet")
			paint_color = "AE4CCD"
		if("white")
			paint_color = "FFFFFF"
		if("black")
			paint_color = "333333"
	icon_state = "paint_[t1]"
	add_fingerprint(user)


/obj/item/paint/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	var/list/modifiers = params2list(params)
	if(paintleft <= 0)
		icon_state = "paint_empty"
		return
	if(istype(target, /obj/structure/low_wall))
		var/obj/structure/low_wall/target_low_wall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			target_low_wall.set_stripe_paint(paint_color)
		else
			target_low_wall.set_wall_paint(paint_color)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] paints \the [target_low_wall]."), \
			span_notice("You paint \the [target_low_wall]."))
		return TRUE
	if(iswall(target))
		var/turf/closed/wall/target_wall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			target_wall.paint_stripe(paint_color)
		else
			target_wall.paint_wall(paint_color)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] paints \the [target_wall]."), \
			span_notice("You paint \the [target_wall]."))
		return TRUE
	if(isfalsewall(target))
		var/obj/structure/falsewall/target_falsewall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			target_falsewall.paint_stripe(paint_color)
		else
			target_falsewall.paint_wall(paint_color)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] paints \the [target_falsewall]."), \
			span_notice("You paint \the [target_falsewall]."))
		return TRUE
	if(!isturf(target) || isspaceturf(target))
		return TRUE
	var/newcolor = "#" + paint_color
	target.add_atom_colour(newcolor, WASHABLE_COLOUR_PRIORITY)

/obj/item/paint_remover
	gender =  PLURAL
	name = "paint remover"
	desc = "Used to remove color and stickers from surfaces and objects." //MonkeStation Edit: Sticker Removal
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_neutral"
	inhand_icon_state = "paintcan"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	max_integrity = 100

/obj/item/paint_remover/examine(mob/user)
	. = ..()
	. += span_notice("Remove wall stripe paint by right-clicking a wall.")

/obj/item/paint_remover/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	var/list/modifiers = params2list(params)
	if(istype(target, /obj/structure/low_wall))
		var/obj/structure/low_wall/target_low_wall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(!target_low_wall.stripe_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_low_wall.set_stripe_paint(null)
		else
			if(!target_low_wall.wall_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_low_wall.set_wall_paint(null)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] strips the paint from \the [target_low_wall]."), \
			span_notice("You strip the paint from \the [target_low_wall]."))
		return TRUE
	if(iswall(target))
		var/turf/closed/wall/target_wall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(!target_wall.stripe_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_wall.paint_stripe(null)
		else
			if(!target_wall.wall_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_wall.paint_wall(null)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] strips the paint from \the [target_wall]."), \
			span_notice("You strip the paint from \the [target_wall]."))
		return TRUE
	if(isfalsewall(target))
		var/obj/structure/falsewall/target_falsewall = target
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(!target_falsewall.stripe_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_falsewall.paint_stripe(null)
		else
			if(!target_falsewall.wall_paint)
				to_chat(user, span_warning("There is no paint to strip!"))
				return TRUE
			target_falsewall.paint_wall(null)
		user.changeNext_move(CLICK_CD_MELEE)
		user.visible_message(span_notice("[user] strips the paint from \the [target_falsewall]."), \
			span_notice("You strip the paint from \the [target_falsewall]."))
		return TRUE
	if(!isturf(target) && !isobj(target))
		return
	if(ismob(target) || isarea(target))
		return
	if(target.color != initial(target.color))
		target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	//MonkeStation Edit: Sticker Removal
	var/atom/movable/selected = target
	if(locate(/obj/item/stickable/dummy_holder) in selected.vis_contents)
		var/obj/item/stickable/dummy_holder/dummy = locate(/obj/item/stickable/dummy_holder) in selected.vis_contents
		var/turf/location = get_turf(user)
		user.visible_message("<span class='notice'>[user] scrapes off the stickers on [selected]!</span>")
		for(var/obj/item/stickable/dropping in dummy.contents)
			dropping.forceMove(location)
		selected.vis_contents -= dummy
	//MonkeStation Edit End
