/obj/machinery/ore_exit_port
	name = "ore exit port"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "bs_miner"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/conveyor/auto/no_deconstruct/base_conv

/obj/machinery/ore_exit_port/Initialize()
	. = ..()
	base_conv = new/obj/machinery/conveyor/auto/no_deconstruct(loc, SOUTH)

/obj/machinery/ore_exit_port/Destroy()
	if(base_conv)
		qdel(base_conv)
	return ..()

/obj/machinery/ore_exit_port/attackby(obj/item/item, mob/user, params)
	if(item.tool_behaviour == TOOL_WRENCH && anchored)
		item.play_tool_sound(src, 50)
		to_chat(user, "<span class='notice'>You rotate the conveyor system.</span>")
		base_conv.setDir(turn(base_conv.dir,-90))
		base_conv.update_move_direction()


/obj/machinery/conveyor/auto/no_deconstruct/attackby(obj/item/I, mob/living/user, params)
	return

/obj/item/beacon/ore_exit_beacon
	name = "Ore Exit Beacon"
	desc = "Deploys your ore exit point, needed for your drill."

/obj/item/beacon/ore_exit_beacon/attack_self(mob/user)
	for(var/obj/machinery/ore_exit_port/port_to_find in GLOB.machines)
		if(port_to_find)
			to_chat(user, span_notice("Bluespace Interference: Please make sure there are no exit ports and please try again!"))
			return

	new /obj/machinery/ore_exit_port(get_turf(src.loc))
	qdel(src)
