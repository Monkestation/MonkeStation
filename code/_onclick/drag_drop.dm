/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!usr || !over)
		return
	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, usr) & COMPONENT_NO_MOUSEDROP)	//Whatever is receiving will verify themselves for adjacency.
		return
	if(over == src)
		return usr.client.Click(src, src_location, src_control, params)
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows

	over.MouseDrop_T(src,usr)
	return

// receive a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user)
	return

/client
	var/obj/item/active_mousedown_item = null
	var/middragtime = 0
	var/atom/middragatom

/client/MouseDown(object, location, control, params)
	if (mouse_down_icon)
		mouse_pointer_icon = mouse_down_icon
	active_mousedown_item = mob.canMobMousedown(object, location, params)
	if(active_mousedown_item)
		active_mousedown_item.onMouseDown(object, location, params, mob)

/client/MouseUp(object, location, control, params)
	if (mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	if(active_mousedown_item)
		active_mousedown_item.onMouseUp(object, location, params, mob)
		active_mousedown_item = null

/mob/proc/CanMobAutoclick(object, location, params)

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_held_item()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/mob/proc/canMobMousedown(atom/object, location, params)

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	var/obj/item/H = get_active_held_item()
	if(H)
		. = H.canItemMouseDown(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)

/obj/item/proc/canItemMouseDown(object, location, params)
	if(canMouseDown)
		return src

/obj/item/proc/onMouseDown(object, location, params, mob)
	return

/obj/item/proc/onMouseUp(object, location, params, mob)
	return

/obj/item
	var/canMouseDown = FALSE

/obj/item/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_CLICK_CTRL_SHIFT, .proc/show_radial_recipes)
/obj/item/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_CLICK_CTRL_SHIFT)
/obj/item/proc/can_see_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/proc/show_radial_recipes(atom/parent_atom, mob/user)
	SIGNAL_HANDLER
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/chef = user
	var/datum/component/personal_crafting/crafting_menu = user.GetComponent(/datum/component/personal_crafting) // we turned crafting into a component so now I have to do this shit to avoid copypaste
	if(!crafting_menu)
		CRASH("HUMAN WITHOUT PERSONAL CRAFTING COMPONENT")
	var/list/available_recipes = list()
	var/list/surroundings = crafting_menu.get_surroundings(chef)
	var/list/recipes_radial = list()
	var/list/recipes_craft = list()
	for(var/recipe in GLOB.crafting_recipes)
		var/datum/crafting_recipe/potential_recipe = recipe
		if((src.type in potential_recipe.reqs) || (potential_recipe.type in GLOB.generic_recipes)) // dont show recipes that don't involve this item
			if(crafting_menu.check_contents(chef, potential_recipe, surroundings)) // don't show recipes we can't actually make
				available_recipes.Add(potential_recipe)
	for(var/available_recipe in available_recipes)
		var/datum/crafting_recipe/available_recipe_datum = available_recipe
		var/atom/craftable_atom = available_recipe_datum.result
		recipes_radial.Add(list(initial(craftable_atom.name) = image(icon = initial(craftable_atom.icon), icon_state = initial(craftable_atom.icon_state))))
		recipes_craft.Add(list(initial(craftable_atom.name) = available_recipe_datum))
	INVOKE_ASYNC(src, .proc/hate_signals_holy_shit, recipes_radial, recipes_craft, chef, crafting_menu)
	return

/obj/item/proc/hate_signals_holy_shit(list/recipes_radial, list/recipes_craft, mob/chef, datum/component/personal_crafting/crafting_menu)
	var/recipe_chosen = show_radial_menu(chef, chef, recipes_radial, custom_check = CALLBACK(src, .proc/can_see_menu, chef), require_near = TRUE, tooltips = TRUE)
	if(!recipe_chosen)
		return
	var/datum/crafting_recipe/chosen_recipe = recipes_craft[recipe_chosen]
	chef.balloon_alert_to_viewers("crafting [chosen_recipe.name]")
	crafting_menu.craft_until_cant(chosen_recipe, chef, get_turf(src))


/obj/item/gun
	var/automatic = 0 //can gun use it, 0 is no, anything above 0 is the delay between clicks in ds

/obj/item/gun/CanItemAutoclick(object, location, params)
	. = automatic

/atom/proc/IsAutoclickable()
	. = 1

/atom/movable/screen/IsAutoclickable()
	. = 0

/atom/movable/screen/click_catcher/IsAutoclickable()
	. = 1

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	var/list/L = params2list(params)
	if (L["middle"])
		if (src_object && src_location != over_location)
			middragtime = world.time
			middragatom = src_object
		else
			middragtime = 0
			middragatom = null
	if(active_mousedown_item)
		active_mousedown_item.onMouseDrag(src_object, over_object, src_location, over_location, params, mob)

/obj/item/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return

/client/MouseDrop(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if (middragatom == src_object)
		middragtime = 0
		middragatom = null
	..()
