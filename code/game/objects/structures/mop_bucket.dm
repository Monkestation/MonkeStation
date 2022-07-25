/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'monkestation/icons/obj/janitor/janitor.dmi'
	icon_state = "mopbucket"
	max_integrity = 200
	anchored = FALSE
	density = TRUE
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/structure/mopbucket/Initialize(mapload)
	. = ..()
	create_reagents(400, OPENCONTAINER) //Same as janitorial cart bucket, may add removable bucket to janitorial cart later

/obj/structure/mopbucket/examine(mob/user)
	. = ..()
	if(broken)
		return
	. += span_info("<b>Click</b> with a wet mop to wring out the fluids into the mop bucket.")
	if(reagents.total_volume > 1)
		. += span_info("<b>Click</b> with a mop to wet it.")
		. += span_info("There is currently [reagents.total_volume] units in [src].")
		. += span_info("<b>Crowbar</b> it to empty it onto [get_turf(src)].")

/obj/structure/mopbucket/Destroy()
	spill_bucket() //Spill out some contents
	if(reagents.total_volume > 0)
		src.reagents.clear_reagents() //Clears any potential remaining reagents from mop bucket
	return ..()

/obj/structure/mopbucket/update_overlays()
	. = ..()
	if(reagents.total_volume > 0)
		. += "mopbucket_water"

/obj/structure/mopbucket/attackby(obj/item/Item, mob/user, params)
	if(broken)
		return
	if(istype(Item, /obj/item/mop))
		if(Item.reagents.total_volume == 0)
			if(reagents.total_volume < 1)
				to_chat(user, "<span class='warning'>[src] is out of water!</span>")
				update_icon()
				return
			else
				reagents.trans_to(Item, 5, transfered_by = user)
				to_chat(user, "<span class='notice'>You wet [Item] in [src].</span>")
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
				update_icon()
				return
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		Item.reagents.remove_any(Item.reagents.total_volume*0.5)
		Item.reagents.trans_to(src, reagents.total_volume, transfered_by = user)
		to_chat(user, "<span class='notice'>You squeeze the liquids from [Item] to [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		update_icon()
		return
	else
		..()

/obj/structure/mopbucket/crowbar_act(mob/living/user, obj/item/Item)
	..()
	. = TRUE
	if(user.a_intent == INTENT_HARM)
		return
	if(reagents.total_volume < 1)
		to_chat(user, span_warning("[src]'s mop bucket is empty!"))
		return
	user.visible_message(span_notice("[user] begins to empty the contents of [src]."), span_notice("You begin to empty the contents of [src]..."))
	if(Item.use_tool(src, user, 5 SECONDS))
		to_chat(usr, span_notice("You empty the contents of [src] onto the floor."))
		log_game("[user] emptied [src]'s mop bucket contents of [reagents.total_volume] units onto [get_turf(src)].")
		spill_bucket()
	update_icon()

//Explosion spills liquids
/obj/structure/mopbucket/ex_act(severity)
	if(broken)
		return
	if(prob(30 + severity)) //50/50 chance of it spilling from explosions
		spill_bucket()
	..()

/obj/structure/mopbucket/proc/spill_bucket()
	var/turf/epicenter = src.loc
	if(reagents.total_volume > 0)
		epicenter.add_liquid_from_reagents(reagents)
		src.reagents.clear_reagents() //Clears any potential remaining reagents from mop bucket


