/obj/machinery/biomatter_tank
	name = "Biomatter Tank"
	desc = "A tank that holds all that sweet sweet organ juice."
	density = TRUE
	icon = 'monkestation/icons/obj/abberant_organ.dmi'
	icon_state = "bio_matter_tank"
	var/icon_prefix = "bio_matter_tank"

	idle_power_usage = 0
	active_power_usage = 0

	var/max_goop = 10000
	var/goop  = 0


/obj/machinery/biomatter_tank/update_overlays()
	. = ..()
	if(!goop == 0)
		var/filled_precent = round(goop/max_goop,0.01)
		switch(filled_precent)
			if(0.25 to 0.49)
				. += mutable_appearance(icon, "[icon_prefix]_quarter")
			if(0.50 to 0.74)
				. += mutable_appearance(icon, "[icon_prefix]_half")
			if(0.75 to 1)
				. += mutable_appearance(icon, "[icon_prefix]_full")

	. += mutable_appearance(icon, "[icon_prefix]_glass")

/obj/machinery/biomatter_tank/examine(mob/user)
	. = ..()
	. += span_notice("The [src.name] has [goop] / [max_goop] Bio-Matter stored")
	. += span_notice("You notice a connection port for a multitool, it seems you can link this up to other machines.")


/obj/machinery/biomatter_tank/proc/update_goop(amount)
	if(goop + amount < 0)
		visible_message("<span class='notice'>The [src.name] flashes for a brief moment, there isn't enough biomatter to complete the current operation.</span>", )
		return FALSE
	if(goop + amount > max_goop)
		visible_message("<span class='notice'>The [src.name] activates its dumping mode and dumps the excess biomatter!</span>", )
		goop = max_goop
		return TRUE
	goop += amount
	return TRUE

/obj/machinery/biomatter_tank/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, I))
			return
		var/obj/item/multitool/M = I
		M.buffer = src
		to_chat(user, "<span class='notice'>You save the data in [I]'s buffer. It can now be used to link bio-matter capable machines.</span>")
