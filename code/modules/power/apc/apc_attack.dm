/obj/machinery/power/apc/attackby(obj/item/attacking_object, mob/living/user, params)

	if(issilicon(user) && get_dist(src,user)>1)
		return attack_hand(user)

	if(istype(attacking_object, /obj/item/stock_parts/cell) && opened)
		if(cell)
			balloon_alert(user, "cell already installed!")
			return
		if(machine_stat & MAINT)
			balloon_alert(user, "no connector for a cell!")
			return
		if(!user.transferItemToLoc(attacking_object, src))
			return
		cell = attacking_object
		user.visible_message(span_notice("[user.name] inserts the power cell to [src.name]!"))
		balloon_alert(user, "cell inserted")
		chargecount = 0
		update_appearance()
		return

	if(attacking_object.GetID())
		togglelock(user)
		return

	if(istype(attacking_object, /obj/item/stack/cable_coil) && opened)
		var/turf/host_turf = get_turf(src)
		if(!host_turf)
			CRASH("attackby on APC when it's not on a turf")
		if (host_turf.intact)
			balloon_alert(user, "remove the floor plating!")
			return
		if(terminal)
			balloon_alert(user, "APC is already wired!")
			return
		if(!has_electronics)
			balloon_alert(user, "no board to wire!")
			return

		var/obj/item/stack/cable_coil/installing_cable = attacking_object
		if(installing_cable.get_amount() < 10)
			balloon_alert(user, "need ten lengths of cable!")
			return

		user.visible_message(span_notice("[user.name] adds cables to the APC frame."))
		balloon_alert(user, "adding cables to the frame...")
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		if(!do_after(user, 20, target = src))
			return
		if(installing_cable.get_amount() < 10 || !installing_cable)
			return
		if(terminal || !opened || !has_electronics)
			return
		var/turf/our_turf = get_turf(src)
		var/obj/structure/cable/cable_node = our_turf.get_cable_node()
		if(prob(50) && electrocute_mob(usr, cable_node, cable_node, 1, TRUE))
			do_sparks(5, TRUE, src)
			return
		installing_cable.use(10)
		balloon_alert(user, "cables added to the frame")
		make_terminal()
		terminal.connect_to_network()
		return

	if(istype(attacking_object, /obj/item/electronics/apc) && opened)
		if(has_electronics)
			balloon_alert(user, "there is already a board!")
			return

		if(machine_stat & BROKEN)
			balloon_alert(user, "the frame is damaged!")
			return

		user.visible_message(span_notice("[user.name] inserts the power control board into [src]."))
		balloon_alert(user, "you start to insert the board...")
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)

		if(!do_after(user, 10, target = src) || has_electronics)
			return

		has_electronics = APC_ELECTRONICS_INSTALLED
		locked = FALSE
		balloon_alert(user, "board installed")
		qdel(attacking_object)
		return

	if(istype(attacking_object, /obj/item/electroadaptive_pseudocircuit) && opened)
		var/obj/item/electroadaptive_pseudocircuit/pseudocircuit = attacking_object
		if(!has_electronics)
			if(machine_stat & BROKEN)
				balloon_alert(user, "frame is too damaged!")
				return
			if(!pseudocircuit.adapt_circuit(user, 50))
				return
			user.visible_message(span_notice("[user] fabricates a circuit and places it into [src]."), \
			span_notice("You adapt a power control board and click it into place in [src]'s guts."))
			has_electronics = APC_ELECTRONICS_INSTALLED
			locked = FALSE
			return

		if(!cell)
			if(machine_stat & MAINT)
				balloon_alert(user, "no board for a cell!")
				return
			if(!pseudocircuit.adapt_circuit(user, 500))
				return
			var/obj/item/stock_parts/cell/crap/empty/bad_cell = new(src)
			bad_cell.forceMove(src)
			cell = bad_cell
			chargecount = 0
			user.visible_message(span_notice("[user] fabricates a weak power cell and places it into [src]."), \
			span_warning("Your [pseudocircuit.name] whirrs with strain as you create a weak power cell and place it into [src]!"))
			update_appearance()
			return

		balloon_alert(user, "has both board and cell!")
		return

	if(istype(attacking_object, /obj/item/wallframe/apc) && opened)
		if(!(machine_stat & BROKEN || opened==APC_COVER_REMOVED || obj_integrity < max_integrity)) // There is nothing to repair
			balloon_alert(user, "no reason for repairs!")
			return
		if(!(machine_stat & BROKEN) && opened==APC_COVER_REMOVED) // Cover is the only thing broken, we do not need to remove elctronicks to replace cover
			user.visible_message(span_notice("[user.name] replaces missing APC's cover."))
			balloon_alert(user, "replacing APC's cover...")
			if(do_after(user, 20, target = src)) // replacing cover is quicker than replacing whole frame
				balloon_alert(user, "cover replaced")
				qdel(attacking_object)
				opened = APC_COVER_OPENED
				update_appearance()
			return
		if(has_electronics)
			balloon_alert(user, "remove the board inside!")
			return
		user.visible_message(span_notice("[user.name] replaces the damaged APC frame with a new one."))
		balloon_alert(user, "replacing damaged frame...")
		if(do_after(user, 50, target = src))
			balloon_alert(user, "APC frame replaced")
			qdel(attacking_object)
			set_machine_stat(machine_stat & ~BROKEN)
			obj_integrity = max_integrity
			if(opened==APC_COVER_REMOVED)
				opened = APC_COVER_OPENED
			update_appearance()
		return

	else if(istype(attacking_object, /obj/item/apc_powercord))
		return //because we put our fancy code in the right places, and this is all in the powercord's afterattack()

	else if(panel_open && !opened && is_wire_tool(attacking_object))
		wires.interact(user)
		return

	return ..()

// attack with hand - remove cell (if cover open) or interact with the APC
/obj/machinery/power/apc/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(isethereal(user))
		var/mob/living/carbon/human/ethereal = user
		var/datum/species/ethereal/E = ethereal.dna.species
		if(E.drain_time > world.time)
			return

		var/obj/item/organ/stomach/battery/stomach = ethereal.getorganslot(ORGAN_SLOT_STOMACH)
		if(ethereal.a_intent == INTENT_HARM)
			if(!istype(stomach))
				balloon_alert(ethereal, "can't receive charge!")
				return
			if(ethereal.nutrition >= NUTRITION_LEVEL_ALMOST_FULL)
				balloon_alert(ethereal, "already fully charged!")
				return
			if(cell.charge <= cell.maxcharge/4) // if charge is under 25% you shouldn't drain it
				balloon_alert(ethereal, "not enough power to drain")
				return

			E.drain_time = world.time + ETH_APC_DRAIN_TIME
			balloon_alert(ethereal, "draining power")
			while(do_after(user, ETH_APC_DRAIN_TIME, target = src))
				if(!istype(stomach))
					balloon_alert(ethereal, "can't receive charge!")
					return
				if(cell.charge <= cell.maxcharge/4)
					balloon_alert(ethereal, "not enough power to drain")
					E.drain_time = 0
					return
				E.drain_time = world.time + ETH_APC_DRAIN_TIME
				if(cell.charge > cell.maxcharge/4 + ETH_APC_POWER_TRANSFER)
					stomach.adjust_charge(ETH_APC_POWER_TRANSFER)
					cell.charge -= ETH_APC_POWER_TRANSFER
					balloon_alert(ethereal, "received charge")
				else
					stomach.adjust_charge(cell.charge - cell.maxcharge/4)
					cell.charge = cell.maxcharge/4
					sleep(5) // A delay so balloon_alert doesn't overlay text on finish
					balloon_alert(ethereal, "not enough power to drain")
					E.drain_time = 0
					return
				if(stomach.charge >= stomach.max_charge)
					sleep(5) // A delay so balloon_alert doesn't overlay text on finish
					balloon_alert(ethereal, "charge is full")
					E.drain_time = 0
					return
			balloon_alert(ethereal, "failed to recieve charge")
			E.drain_time = 0
			return

		else if(ethereal.a_intent == INTENT_GRAB)
			if(!istype(stomach))
				balloon_alert(ethereal, "can't transfer power!")
				return
			E.drain_time = world.time + ETH_APC_DRAIN_TIME
			balloon_alert(ethereal, "transfering power to APC")
			while(do_after(user, 75, target = src))
				if(!istype(stomach))
					balloon_alert(ethereal, "can't transfer power!")
					return
				E.drain_time = world.time + ETH_APC_DRAIN_TIME
				if(stomach.charge > ETH_APC_POWER_TRANSFER)
					balloon_alert(ethereal, "transfering power to APC")
					stomach.adjust_charge(-ETH_APC_POWER_TRANSFER)
					cell.charge = min(cell.charge + ETH_APC_POWER_TRANSFER, cell.maxcharge)
				else
					balloon_alert(ethereal, "transfering remaining power to APC")
					cell.charge = min(cell.charge + stomach.charge, cell.maxcharge)
					stomach.set_charge(0)
					E.drain_time = 0
					return
				if(cell.charge >= cell.maxcharge)
					sleep(5) // A delay so balloon_alert doesn't overlay text on finish
					balloon_alert(ethereal, "APC fully charged")
					E.drain_time = 0
					return
			balloon_alert(ethereal, "can't transfer power!")
			E.drain_time = 0
			return

	if(opened && (!issilicon(user)))
		if(cell)
			user.visible_message(span_notice("[user] removes \the [cell] from [src]!"))
			balloon_alert(user, "cell removed")
			user.put_in_hands(cell)
			cell.update_appearance()
			src.cell = null
			charging = APC_NOT_CHARGING
			update_appearance()
		return
	if((machine_stat & MAINT) && !opened) //no board; no interface
		return


// Damage Acts
/obj/machinery/power/apc/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	ui_interact(eminence)

/obj/machinery/power/apc/blob_act(obj/structure/blob/B)
	set_broken()

/obj/machinery/power/apc/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE)
	// APC being at 0 integrity doesnt delete it outright. Combined with take_damage this might cause runtimes.
	if(machine_stat & BROKEN && obj_integrity <= 0)
		if(sound_effect)
			play_attack_sound(damage_amount, damage_type, damage_flag)
		if(cell)
			cell.forceMove(loc)
			cell.update_appearance()
			cell = null
		new /obj/item/stack/sheet/iron(loc)
		qdel(src)
		return
	return ..()

/obj/machinery/power/apc/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(machine_stat & BROKEN)
		return damage_amount
	. = ..()

/obj/machinery/power/apc/obj_break(damage_flag)
	. = ..()
	if(.)
		set_broken()

/obj/machinery/power/apc/proc/can_use(mob/user, loud = 0) //used by attack_hand() and Topic()
	if(IsAdminGhost(user))
		return TRUE
	if(!user.has_unlimited_silicon_privilege)
		return TRUE
	var/mob/living/silicon/ai/AI = user
	var/mob/living/silicon/robot/robot = user
	if(aidisabled || malfhack && istype(malfai) && ((istype(AI) && (malfai!=AI && malfai != AI.parent)) || (istype(robot) && (robot in malfai.connected_robots))))
		if(!loud)
			balloon_alert(user, "APC has been disabled!")
		return FALSE
	return TRUE

/obj/machinery/power/apc/can_interact(mob/user)
	. = ..()
	if (!. && !QDELETED(remote_control))
		. = remote_control.can_interact(user)

/obj/machinery/power/apc/proc/set_broken()
	if(malfai && operating)
		malfai.malf_picker.processing_time = clamp(malfai.malf_picker.processing_time - 10,0,1000)
	operating = FALSE
	obj_break()
	if(occupier)
		malfvacate(TRUE)
	update()
	do_sparks(5, TRUE, src)

/obj/machinery/power/apc/proc/shock(mob/user, prb)
	if(!prob(prb))
		return FALSE
	do_sparks(5, TRUE, src)
	if(isalien(user))
		return FALSE
	if(electrocute_mob(user, src, src, 1, TRUE))
		return TRUE
	else
		return FALSE
