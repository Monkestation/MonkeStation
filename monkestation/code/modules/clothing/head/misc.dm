#define HAT_CAP 20 //Maximum number of hats stacked upon the base hat.
#define ADD_HAT 0
#define REMOVE_HAT 1

/obj/item/clothing/head/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/head))
		if(contents) 					//Checking for previous hats and preventing towers that are too large
			if(I.contents)
				if(I.contents.len + contents.len + 1 > HAT_CAP)
					to_chat(user,"<span class='warning'>You think that this hat tower is perfect the way it is and decide against adding another.</span>")
					return
				for(var/obj/item/clothing/head/hat_movement in I.contents)
					hat_movement.name = initial(name)
					hat_movement.desc = initial(desc)
					hat_movement.forceMove(src)
			var/hat_count = contents.len
			if(hat_count + 1 > HAT_CAP)
				to_chat(user,"<span class='warning'>You think that this hat tower is perfect the way it is and decide against adding another.</span>")
				return
		var/obj/item/clothing/head/new_hat = I
		if(user.transferItemToLoc(new_hat,src)) //Moving the new hat to the base hat's contents
			to_chat(user, "<span class='notice'>You place the [new_hat] upon the [src].</span>")
			update_hats(ADD_HAT, user)
	else
		. = ..()


/obj/item/clothing/head/verb/detach_stacked_hat()
	set name = "Remove Stacked Hat"
	set category = "Object"
	set src in usr
	if(src.contents)
		update_hats(REMOVE_HAT,usr)

/obj/item/clothing/head/proc/restore_initial() //Why can't initial() be called directly by something?
	name = initial(name)
	desc = initial(desc)

/obj/item/clothing/head/proc/update_hats(var/hat_removal, var/mob/living/user)
	if(hat_removal)
		var/obj/item/clothing/head/hat_to_remove = contents[contents.len] //Get the last item in the hat and hand it to the user.
		hat_to_remove.restore_initial()
		hat_to_remove.verbs -= /obj/item/clothing/head/verb/detach_stacked_hat
		user.put_in_hands(hat_to_remove)

	cut_overlays()
	if(contents)
		var/current_hat = 1
		for(var/obj/item/clothing/head/selected_hat in contents)
			selected_hat.cut_overlays()
			selected_hat.forceMove(src)
			selected_hat.name = initial(name)
			selected_hat.desc = initial(desc)
			var/mutable_appearance/hat_adding = mutable_appearance(selected_hat.icon, "[initial(selected_hat.icon_state)]")
			hat_adding.pixel_y = ((current_hat * 6) - 1)
			current_hat++
			add_overlay(hat_adding)
		verbs += /obj/item/clothing/head/verb/detach_stacked_hat
		switch(contents.len)
			if(0)
				name = initial(name)
				desc = initial(desc)
			if (1,2)
				name = "Pile of Hats"
				desc = "A meagre pile of hats"
			if (3)
				name = "Stack of Hats"
				desc = "A decent stack of hats"
			if(5,6)
				name = "Towering Pillar of Hats"
				desc = "A magnificent display of pride and wealth"
			if(7,8)
				name = "A Dangerous Amount of Hats"
				desc = "A truly grand tower of hats"
			if(9,10)
				name = "A Lesser Hatularity"
				desc = "A tower approaching unstable levels of hats"
			if(11,12,13,14,15)
				name = "A Hatularity"
				desc = "A tower that has grown far too powerful"
			if(16,17,18,19)
				name = "A Greater Hatularity"
				desc = "A monument to the madness of man"
			if(20)
				name = "The True Hat Tower"
				desc = "<span class='narsiesmall'>AFTER NINE YEARS IN DEVELOPMENT, HOPEFULLY IT WILL HAVE BEEN WORTH THE WAIT</span>"
	worn_overlays()
	user.update_inv_head()


#undef HAT_CAP
#undef ADD_HAT
#undef REMOVE_HAT
