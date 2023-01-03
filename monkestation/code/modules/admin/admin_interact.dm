

/mob
	///used for the admin_interact verb used to open the tgui menu
	var/admin_interact_held = FALSE
/datum/keybinding/admin/admin_interact
	key = "`"
	name = "admin_interact"
	full_name = "Admin interact"
	description = "Click on an atom to open up an admin interaction menu."
	keybind_signal = COMSIG_KB_ADMIN_ASAY_DOWN

/datum/keybinding/admin/admin_interact/down(client/user)
	. = ..()
	if(.)
		return
	if(!user.mob) return
	user.mob.admin_interact_held = TRUE

/datum/keybinding/admin/admin_interact/up(client/user)
	. = ..()
	if(.)
		return
	if(!user.mob) return
	user.mob.admin_interact_held = FALSE

/client/proc/admin_interact(atom/interacted_atom, list/params)
	set name = "Admin Interact"
	set category = "Adminbus"
	set hidden = 1
	if(!check_rights(0))
		return

	if(!interacted_atom)
		to_chat(span_warning("Oops! You need to interact with an atom for this to work! Please use the keybind and click on an atom!"))
		return

	var/static/list/admin_interact_verbs = list()

	var/mob/targeted_mob
	var/turf/targeted_turf
	var/obj/targeted_obj

	if(!admin_interact_verbs.len)
		///all turf verbs go here ie drop pod, spawn mob, etc
		//admin_interact_verbs["turf"] = list()
		///all verbs that affect mobs go here ie smite, heal, etc
		admin_interact_verbs["mob"] = list(\
		"Heal",\
		"Smite",)
		///all verbs that affect objects go here
		//admin_interact_verbs["obj"] = list()

	var/choice
	if(ismob(interacted_atom))
		targeted_mob = interacted_atom
		choice = tgui_input_list(usr, "Choose an action.", "Admin Interaction", admin_interact_verbs["mob"])
	else if(isturf(interacted_atom))
		targeted_turf = interacted_atom
	else
		targeted_obj = interacted_atom
	if(!choice)
		return
	switch(choice)
		if("Heal")
			if(!isliving(targeted_mob))
				return
			cmd_admin_rejuvenate(targeted_mob)

		if("Smite")
			if(!isliving(targeted_mob))
				return
			smite(targeted_mob)
		else
			return
