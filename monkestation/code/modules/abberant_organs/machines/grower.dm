#define BODYPART_COST_DEFAULT 1000
#define ORGAN_COST_DEFAULT 500

/obj/machinery/growth_vat
	name = "Organic Constructor"
	desc = "A machine that constructs organic objects out of Bio-Matter, requires a connected tank to function."

	icon = 'monkestation/icons/obj/abberant_organ.dmi'
	icon_state = "grower_idle"

	density = TRUE

	var/obj/machinery/biomatter_tank/linked_tank

	var/obj/item/organ/stored_organ
	var/obj/item/bodypart/stored_bodypart

	var/organ_growing_time = 30 SECONDS
	var/limb_growing_time = 1 MINUTES

	var/working = FALSE

	var/static/list/viable_organs = list() /// save this across all growth vats no point in regenerating it saves time
	var/static/list/viable_bodyparts = list()

/obj/machinery/growth_vat/Initialize(mapload)
	. = ..()
	if(!viable_organs.len)
		for(var/obj/item/organ/listed_organ as anything in typesof(/obj/item/organ))
			if(initial(listed_organ.status) == ORGAN_ORGANIC)
				if(initial(listed_organ.can_synth))
					viable_organs[listed_organ] = initial(listed_organ.tier) * ORGAN_COST_DEFAULT

	if(!viable_bodyparts.len)
		for(var/obj/item/bodypart/listed_bodypart as anything in typesof(/obj/item/bodypart))
			if(initial(listed_bodypart.bodytype) & BODYTYPE_ORGANIC)
				if(initial(listed_bodypart.can_synth))
					viable_bodyparts[listed_bodypart] = initial(listed_bodypart.tier) * BODYPART_COST_DEFAULT

/obj/machinery/growth_vat/update_icon(updates)
	. = ..()
	if(working)
		icon_state = "grower_working"
	else
		icon_state = "grower_idle"

/obj/machinery/growth_vat/attackby(obj/item/I, mob/living/user)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, I))
			return
		var/obj/item/multitool/M = I
		if(istype(M.buffer, /obj/machinery/biomatter_tank))
			linked_tank = M.buffer
			to_chat(user, "<span class='notice'>You link the [src.name] to the [M.buffer].</span>")
			return TRUE
	return ..()

/obj/machinery/growth_vat/attack_hand(mob/living/user)
	. = ..()
	if(working)
		return
	if(!eject_finished_product())
		if(!linked_tank)
			to_chat(user, span_notice("No linked Bio-Matter Tank detected, please link a tank and try again!"))
			return
		var/choice = input(user, "Would you like to grow an organ or a bodypart?", "Organic Constructor")  as null|anything in list("Organ", "Bodypart")
		if(!choice)
			return
		handle_selection(user, choice)

/obj/machinery/growth_vat/proc/eject_finished_product()
	if (stored_organ)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(stored_organ))
				stored_organ.forceMove(drop_location())
		else
			stored_organ.forceMove(drop_location())
		stored_organ = null
		return TRUE
	else if (stored_bodypart)
		if(Adjacent(usr) && !issiliconoradminghost(usr))
			if (!usr.put_in_hands(stored_bodypart))
				stored_bodypart.forceMove(drop_location())
		else
			stored_bodypart.forceMove(drop_location())
		stored_bodypart = null
		return TRUE

/obj/machinery/growth_vat/proc/handle_selection(mob/living/user, choice)
	switch(choice)
		if("Organ")
			var/obj/item/organ/organ_choice = input(user, "Choose an organ to grow", "Organic Constructor")  as null|anything in viable_organs
			if(!organ_choice)
				return
			start_growing_organ(organ_choice)
		if("Bodypart")
			var/obj/item/bodypart/limb_choice = input(user, "Choose a bodypart to grow", "Organic Constructor")  as null|anything in viable_bodyparts
			if(!limb_choice)
				return
			start_growing_limb(limb_choice)


/obj/machinery/growth_vat/proc/start_growing_organ(obj/item/organ/growing_organ)
	var/growth_cost = viable_organs[growing_organ]
	if(!linked_tank.update_goop(-growth_cost))
		visible_message(span_notice("The [src] makes a whirring sound, seems it lacks bio-matter"))
		return
	var/image/used_image = image('monkestation/icons/obj/abberant_organ.dmi', icon_state = "growth")

	working = TRUE
	if(machine_do_after_visable(src, organ_growing_time, add_image = used_image))
		flick("grower_grow", src)
		stored_organ = new growing_organ
		working = FALSE

/obj/machinery/growth_vat/proc/start_growing_limb(obj/item/bodypart/growing_bodypart)
	var/growth_cost = viable_bodyparts[growing_bodypart]
	if(!linked_tank.update_goop(-growth_cost))
		visible_message(span_notice("The [src] makes a whirring sound, seems it lacks bio-matter"))
		return
	var/image/used_image = image('monkestation/icons/obj/abberant_organ.dmi', icon_state = "growth")

	working = TRUE
	update_appearance()
	if(machine_do_after_visable(src, limb_growing_time, add_image = used_image))
		flick("grower_grow", src)
		stored_bodypart = new growing_bodypart
		working = FALSE
		update_appearance()

#undef BODYPART_COST_DEFAULT
#undef ORGAN_COST_DEFAULT
