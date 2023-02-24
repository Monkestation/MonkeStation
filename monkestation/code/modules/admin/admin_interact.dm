//there has to be a better way to do this, but alas my brain is smooth
GLOBAL_LIST_INIT(object_list_pruned, (subtypesof(/obj) - (subtypesof(/obj/item/gun) + subtypesof(/obj/item/melee) + subtypesof(/obj/item/food) + subtypesof(/obj/item/organ) + subtypesof(/obj/item/bodypart) + subtypesof(/obj/item/clothing) + subtypesof(/obj/effect) + subtypesof(/obj/machinery) + subtypesof(/obj/item/projectile) + subtypesof(/obj/item/paper) + subtypesof(/obj/structure))))
GLOBAL_LIST_INIT(mob_type_list, subtypesof(/mob))




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
	var/static/list/admin_interact_verbs_universal = list(\
	"View Variables" = 1000,\
	"Edit Filters" = 599,\
	"Edit Particles" = 600,\
	"Modify Transform" = 598,\
	"Add Reagent" = 200,\
	"Explosion" = 100,)

	var/mob/targeted_mob
	var/turf/targeted_turf
	var/obj/targeted_obj

	if(!admin_interact_verbs.len)
		///all turf verbs go here ie drop pod, spawn mob, etc
		admin_interact_verbs["turf"] = list(\
		"Create Object" = 999,\
		"Create Mob" = 998,\
		"Spawn Liquid" = 997,)
		///all verbs that affect mobs go here ie smite, heal, etc
		admin_interact_verbs["mob"] = list(\
		"Heal" = 950,\
		"Smite" = 949,\
		"Hallucinate" = 701,\
		)
		///all verbs that affect objects go here
		//admin_interact_verbs["obj"] = list()

	var/choice
	if(ismob(interacted_atom))
		targeted_mob = interacted_atom
		var/list/extras = list()
		if(targeted_mob.client)
			extras += list(\
			"Player Panel" = 2000,)
		if(ishuman(targeted_mob))
			extras += list(\
			"Set Species" = 948,\
			"Give Martial Arts" = 698,\
			"Make Mob" = 947,\
			"Add / Remove Quirk" = 702,)
		if(iscarbon(targeted_mob))
			extras += list(\
			"Modify Bodyparts" = 947,\
			"Modify Organs" = 946,\
			"Cure Brain Trauma" = 700,\
			"Give Brain Trauma" = 699,)
		choice = tgui_input_list(usr, "Choose an action.", "Admin Interaction", sortTim((admin_interact_verbs["mob"] + admin_interact_verbs_universal + extras), cmp = /proc/cmp_numeric_dsc, associative = TRUE))
	else if(isturf(interacted_atom))
		targeted_turf = interacted_atom
		choice = tgui_input_list(usr, "Choose an action.", "Admin Interaction", sortTim((admin_interact_verbs["turf"] + admin_interact_verbs_universal), cmp = /proc/cmp_numeric_dsc, associative = TRUE))
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

		if("Add Reagent")
			if(!check_rights(R_VAREDIT))
				return
			var/chosen_id
			switch(tgui_alert(usr, "Choose a method.", "Add Reagents", list("Search", "Choose from a list", "I'm feeling lucky")))
				if("Search")
					var/valid_id
					while(!valid_id)
						chosen_id = tgui_input_text(usr, "Enter the ID of the reagent you want to add.", "Search reagents")
						if(isnull(chosen_id)) //Get me out of here!
							break
						if (!ispath(text2path(chosen_id)))
							chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
							if (ispath(chosen_id))
								valid_id = TRUE
						else
							valid_id = TRUE
						if(!valid_id)
							to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
				if("Choose from a list")
					chosen_id = tgui_input_list(usr, "Choose a reagent to add.", "Choose a reagent.", subtypesof(/datum/reagent))
				if("I'm feeling lucky")
					chosen_id = pick(subtypesof(/datum/reagent))
			if(chosen_id)
				var/amount = tgui_input_number(usr, "Choose the amount to add.", "Choose the amount.", max_value = interacted_atom.reagents.maximum_volume)
				if(amount)
					interacted_atom.reagents.add_reagent(chosen_id, amount)
					log_admin("[key_name(usr)] has added [amount] units of [chosen_id] to [interacted_atom]")
					message_admins("<span class='notice'>[key_name(usr)] has added [amount] units of [chosen_id] to [interacted_atom]</span>")

		if("Hallucinate")
			if(!check_rights(NONE))
				return
			var/list/hallucinations = subtypesof(/datum/hallucination)
			var/result = tgui_input_list(usr, "Choose the hallucination to apply","Send Hallucination", hallucinations)
			if(!usr)
				return
			if(QDELETED(targeted_mob))
				to_chat(usr, "Mob doesn't exist anymore")
				return
			if(result)
				new result(targeted_mob, TRUE)
			log_admin("[key_name(usr)] has caused [key_name(targeted_mob)] to hallucinate [result].")

		if("Cure Brain Trauma")
			if(!iscarbon(targeted_mob))
				return
			if(!check_rights(NONE))
				return
			var/mob/living/carbon/targeted_carbon = targeted_mob
			targeted_carbon.cure_all_traumas(TRAUMA_RESILIENCE_ABSOLUTE)
			log_admin("[key_name(usr)] has cured all traumas from [key_name(targeted_mob)].")
			message_admins("<span class='notice'>[key_name_admin(usr)] has cured all traumas from [key_name_admin(targeted_mob)].</span>")

		if("Give Brain Trauma")
			if(!iscarbon(targeted_mob))
				return
			if(!check_rights(NONE))
				return
			var/mob/living/carbon/targeted_carbon = targeted_mob
			var/list/traumas = subtypesof(/datum/brain_trauma)
			var/result = tgui_input_list(usr, "Choose the brain trauma to apply","Traumatize", traumas)
			if(!usr)
				return
			if(QDELETED(targeted_mob))
				to_chat(usr, "Mob doesn't exist anymore")
				return
			if(!result)
				return
			var/datum/brain_trauma/BT = targeted_carbon.gain_trauma(result)
			if(BT)
				log_admin("[key_name(usr)] has traumatized [key_name(targeted_carbon)] with [BT.name]")
				message_admins("<span class='notice'>[key_name_admin(usr)] has traumatized [key_name_admin(targeted_carbon)] with [BT.name].</span>")

		if("Modify Organs")
			if(!check_rights(NONE))
				return
			manipulate_organs(targeted_mob)

		if("Modify Bodyparts")
			if(!iscarbon(targeted_mob))
				return
			if(!check_rights(R_SPAWN))
				return
			var/mob/living/carbon/targeted_carbon = targeted_mob
			var/edit_action = tgui_input_list(usr, "What would you like to do?","Modify Body Part", list("add","remove", "augment"))
			if(!edit_action)
				return
			var/list/limb_list = list()
			if(edit_action == "remove" || edit_action == "augment")
				for(var/obj/item/bodypart/B in targeted_carbon.bodyparts)
					limb_list += B.body_zone
				if(edit_action == "remove")
					limb_list -= BODY_ZONE_CHEST
			else
				limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				for(var/obj/item/bodypart/B in targeted_carbon.bodyparts)
					limb_list -= B.body_zone
			var/result = tgui_input_list(usr, "Please choose which body part to [edit_action]","[capitalize(edit_action)] Body Part", limb_list)
			if(result)
				var/obj/item/bodypart/BP = targeted_carbon.get_bodypart(result)
				switch(edit_action)
					if("remove")
						if(BP)
							BP.drop_limb()
						else
							to_chat(usr, "[targeted_mob] doesn't have such bodypart.")
					if("add")
						if(BP)
							to_chat(usr, "[targeted_mob] already has such bodypart.")
						else
							if(!targeted_carbon.regenerate_limb(result))
								to_chat(usr, "[targeted_mob] cannot have such bodypart.")
					if("augment")
						if(ishuman(targeted_mob))
							if(BP)
								BP.change_bodypart_status(BODYTYPE_ROBOTIC, TRUE, TRUE)
							else
								to_chat(usr, "[targeted_mob] doesn't have such bodypart.")
						else
							to_chat(usr, "Only humans can be augmented.")
			admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [targeted_mob]")

		if("Set Species")
			if(!ishuman(targeted_mob))
				return
			if(!check_rights(R_SPAWN))
				return
			var/mob/living/carbon/human/targeted_human = targeted_mob
			var/result = tgui_input_list(usr, "Please choose a new species","Species", GLOB.species_list)
			if(result)
				var/newtype = GLOB.species_list[result]
				admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [src] to [result]")
				targeted_human.set_species(newtype)

		if("Make Mob")
			if(!check_rights(R_SPAWN))
				return
			var/mob_choice = tgui_input_list(usr, "Please choose a mob to transform target into", "Make Mob", list("Monkey", "Slime", "Cyborg", "Alien", "Animal"))
			switch(mob_choice)
				if("Monkey")
					if(!iscarbon(interacted_atom))
						return
					var/mob/living/carbon/interacted_carbon = interacted_atom
					interacted_carbon.monkeyize()
				if("Cyborg")
					cmd_admin_robotize(interacted_atom)
				if("Slime")
					cmd_admin_slimeize(interacted_atom)
				if("Alien")
					cmd_admin_alienize(interacted_atom)
				if("Animal")
					cmd_admin_animalize(interacted_atom)
				else
					return

		if("Create Object")
			if(!check_rights(R_SPAWN))
				return
			var/object_choice_type = tgui_input_list(usr, "Choose an object group to look for", "Create Object", list("Weapons", "Foods", "Structures", "Machinery", "Organs/Bodyparts", "Effects", "Clothing", "Paper", "Unsorted"))
			if(!object_choice_type)
				return
			var/obj/chosen_object
			switch(object_choice_type)
				if("Unsorted")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", GLOB.object_list_pruned)
				if("Weapons")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", (subtypesof(/obj/item/gun) + subtypesof(/obj/item/melee)))
				if("Foods")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/item/food))
				if("Structures")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/structure))
				if("Machinery")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/machinery))
				if("Organs/Bodyparts")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", (subtypesof(/obj/item/organ) + subtypesof(/obj/item/bodypart)))
				if("Effects")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/effect))
				if("Clothing")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/item/clothing))
				if("Papers")
					chosen_object = tgui_input_list(usr, "Choose an Object to spawn", "Create Object", subtypesof(/obj/item/paper))
			if(!chosen_object)
				return
			var/spawn_amount = tgui_input_number(usr, "How many [initial(chosen_object.name)]s would you like to spawn?", "Create_Object", 1, 100, 1)
			for(var/increment = 0, increment < spawn_amount, increment++)
				new chosen_object(targeted_turf)
			admin_ticket_log("[key_name_admin(usr)] created [spawn_amount] of [chosen_object.name] at [targeted_turf]")

		if("Create Mob")
			if(!check_rights(R_SPAWN))
				return
			var/mob/chosen_mob = tgui_input_list(usr, "Choose a mob to spawn", "Create Mob", GLOB.mob_type_list)
			if(!chosen_mob)
				return
			var/spawn_amount = tgui_input_number(usr, "How many [initial(chosen_mob.name)]s would you like to spawn?", "Create_Object", 1, 100, 1)

			for(var/increment = 0, increment < spawn_amount, increment++)
				new chosen_mob(targeted_turf)
				admin_ticket_log("[key_name_admin(usr)] created a [chosen_mob.name] at [targeted_turf]")

		if("Spawn Liquid")
			if(!check_rights(!R_FUN))
				return
			var/chosen_id = tgui_input_list(usr, "Choose a reagent to add.", "Choose a reagent.", subtypesof(/datum/reagent))
			if(!chosen_id)
				return
			var/liquid_amount = tgui_input_number(usr, "How much liquid should we spawn", "Choose a reagent", 10, 10000000, 1)
			targeted_turf.add_liquid(chosen_id, liquid_amount)
			message_admins("[ADMIN_LOOKUPFLW(usr)] spawned liquid at [targeted_turf.loc] ([chosen_id] - [liquid_amount]).")
			log_admin("[key_name(usr)] spawned liquid at [targeted_turf.loc] ([chosen_id] - [liquid_amount]).")

		if("View Variables")
			debug_variables(interacted_atom)

		if("Modify Transform")
			if(!check_rights(R_VAREDIT))
				return
			var/result = tgui_input_list(usr, "Choose the transformation to apply","Transform Mod", list("Scale","Translate","Rotate"))
			var/matrix/M = interacted_atom.transform
			switch(result)
				if("Scale")
					var/x = tgui_input_number(usr, "Choose x mod","Transform Mod", 1, 100)
					var/y = tgui_input_number(usr, "Choose y mod","Transform Mod", 1, 100)
					if(!isnull(x) && !isnull(y))
						interacted_atom.transform = M.Scale(x,y)
				if("Translate")
					var/x = tgui_input_number(usr, "Choose x mod","Transform Mod", 1, 100)
					var/y = tgui_input_number(usr, "Choose y mod","Transform Mod", 1, 100)
					if(!isnull(x) && !isnull(y))
						interacted_atom.transform = M.Translate(x,y)
				if("Rotate")
					var/angle = tgui_input_number(usr, "Choose angle to rotate","Transform Mod", 0, 360, -360)
					if(!isnull(angle))
						interacted_atom.transform = M.Turn(angle)

		if("Explosion")
			if(!check_rights(R_FUN))
				return
			var/explode_choice = tgui_input_list(usr, "Choose Explosion Type", "Explosion Menu", list("EMP", "Bomb"))
			switch(explode_choice)
				if("EMP")
					cmd_admin_emp(interacted_atom)
				if("Bomb")
					cmd_admin_explosion(interacted_atom)
				else
					return

		if("Edit Filters")
			if(!check_rights(R_VAREDIT))
				return
			open_filter_editor(interacted_atom)

		if("Edit Particles")
			if(!check_rights(R_VAREDIT) || isturf(interacted_atom))
				return
			open_particle_editor(interacted_atom)

		if("Add / Remove Quirk")
			if(!check_rights(R_SPAWN))
				return
			if(!isliving(interacted_atom))
				return

			var/mob/living/interacted_living = interacted_atom

			var/list/options = list("Clear"="Clear")
			for(var/x in subtypesof(/datum/quirk))
				var/datum/quirk/T = x
				var/qname = initial(T.name)
				options[interacted_living.has_quirk(T) ? "[qname] (Remove)" : "[qname] (Add)"] = T

			var/result = tgui_input_list(usr, "Choose quirk to add/remove","Quirk Mod", options)
			if(result)
				if(result == "Clear")
					for(var/datum/quirk/q in interacted_living.roundstart_quirks)
						interacted_living.remove_quirk(q.type)
				else
					var/T = options[result]
					if(interacted_living.has_quirk(T))
						interacted_living.remove_quirk(T)
					else
						interacted_living.add_quirk(T,TRUE)

		if("Give Martial Arts")
			if(!check_rights(NONE))
				return
			var/list/artpaths = subtypesof(/datum/martial_art)
			var/list/artnames = list()
			for(var/i in artpaths)
				var/datum/martial_art/M = i
				artnames[initial(M.name)] = M
			var/result = tgui_input_list(usr, "Choose the martial art to teach","JUDO CHOP", artnames)
			if(!usr)
				return
			if(QDELETED(src))
				to_chat(usr, "Mob doesn't exist anymore")
				return
			if(result)
				var/chosenart = artnames[result]
				var/datum/martial_art/MA = new chosenart
				MA.teach(interacted_atom)
				log_admin("[key_name(usr)] has taught [MA] to [key_name(interacted_atom)].")
				message_admins("<span class='notice'>[key_name_admin(usr)] has taught [MA] to [key_name_admin(interacted_atom)].</span>")

		if("Player Panel")
			if(!check_rights(NONE))
				return
			holder.open_player_panel()
			holder.player_panel.selected_ckey = targeted_mob.client.ckey
		else
			return
