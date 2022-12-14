/obj/machinery/splicer
	name = "Splicer"
	desc = "Splices two seeds together."

	icon_state = "splicer"
	icon = 'monkestation/icons/obj/machinery/hydroponics.dmi'
	var/obj/item/seeds/seed_1
	var/obj/item/seeds/seed_2

	var/working = FALSE

	var/work_timer = null


/obj/machinery/splicer/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/seeds))
		if(!seed_1)
			if(!user.transferItemToLoc(I, src))
				return
			seed_1 = I
			return
		if(!seed_2)
			if(!user.transferItemToLoc(I, src))
				return
			seed_2 = I

/obj/machinery/splicer/ui_data(mob/user)
	. = ..()
	var/has_seed_one = FALSE
	var/has_seed_two = FALSE
	var/list/data = list()
	if(seed_1)
		data["seed_1"] = list(seed_1.return_all_data())
		has_seed_one = TRUE
	if(seed_2)
		data["seed_2"] = list(seed_2.return_all_data())
		has_seed_two = TRUE


	data["seedone"] = has_seed_one
	data["seedtwo"] = has_seed_two

	data["working"] = working

	data["timeleft"] = work_timer ? timeleft(work_timer) : null

	return data

/obj/machinery/splicer/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanySplicer", name)
		ui.set_autoupdate(TRUE)
		ui.open()
