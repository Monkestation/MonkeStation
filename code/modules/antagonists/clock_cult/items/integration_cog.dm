/obj/item/clockwork/integration_cog
	name = "integration cog"
	desc = "A small cog that seems to spin by its own acord when left alone."
	icon_state = "integration_cog"
	clockwork_desc = "A sharp cog that can cut through and be inserted into APCs to extract power for the gateway."

/obj/item/clockwork/integration_cog/attack_obj(obj/target_obj, mob/living/user)
	if(!is_servant_of_ratvar(user))
		return ..()
	if(!istype(target_obj, /obj/machinery/power/apc))
		return ..()
	var/obj/machinery/power/apc/target_apc = target_obj
	if(target_apc.integration_cog)
		to_chat(user, "<span class='brass'>There is already \an [src] in \the [target_apc].</span>")
		return
	if(!target_apc.panel_open)
		//Cut open the panel
		to_chat(user, "<span class='notice'>You begin cutting open \the [target_apc].</span>")
		if(do_after(user, 50, target=target_apc))
			to_chat(user, "<span class='brass'>You cut open \the [target_apc] with \the [src].</span>")
			target_apc.panel_open = TRUE
			target_apc.update_appearance()
			return
		return
	//Insert the cog
	to_chat(user, "<span class='notice'>You begin inserting \the [src] into \the [target_apc].</span>")
	if(do_after(user, 40, target = target_apc))
		target_apc.integration_cog = src
		forceMove(target_apc)
		target_apc.panel_open = FALSE
		target_apc.update_appearance()
		to_chat(user, "<span class='notice'>You insert \the [src] into \the [target_apc].</span>")
		playsound(get_turf(user), 'sound/machines/clockcult/integration_cog_install.ogg', 20)
		if(!target_apc.clock_cog_rewarded)
			GLOB.installed_integration_cogs ++
			target_apc.clock_cog_rewarded = TRUE
			hierophant_message("<b>[user]</b> has installed an integration cog into \an [target_apc]", span="<span class='nzcrentr'>", use_sanitisation=FALSE)
			//Update the cog counts
			for(var/obj/item/clockwork/clockwork_slab/S in GLOB.clockwork_slabs)
				S.update_integration_cogs()
			if(GLOB.clockcult_eminence)
				var/mob/living/simple_animal/eminence/eminence = GLOB.clockcult_eminence
				eminence.cog_change()
