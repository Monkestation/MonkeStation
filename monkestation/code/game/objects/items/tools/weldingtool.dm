/obj/item/weldingtool/makeshift
	name = "makeshift welding tool"
	desc = "A MacGyver-style welder."
	icon = 'monkestation/icons/obj/improvised.dmi'
	icon_state = "welder_makeshift"
	toolspeed = 2
	max_fuel = 10
	materials = list(MAT_METAL=140)

/obj/item/weldingtool/makeshift/switched_on(mob/user)
	..()
	if(welding && get_fuel() >= 1 && prob(2))
		var/datum/effect_system/reagents_explosion/boom = new()
		to_chat(user, span_userdanger("Shoddy construction causes [src] to violently explode!"))
		boom.set_up(round(get_fuel() / 10, 1), get_turf(src), 0, 0)
		boom.start()
		qdel(src)
		return
