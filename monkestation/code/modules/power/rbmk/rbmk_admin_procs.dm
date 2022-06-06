//Admin procs to mess with the reaction environment.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/debug_startup()
	slagged = FALSE
	for(var/I=0;I<5;I++)
		fuel_rods += new /obj/item/fuel_rod(src)
	message_admins("Reactor started up by admins in [ADMIN_VERBOSEJMP(src)]")
	start_up()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/deplete()
	for(var/obj/item/fuel_rod/FR in fuel_rods)
		FR.depletion = 100

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/debug_meltdown(var/new_power)
	power = new_power
	message_admins("Reactor meltdown triggered by admins in [ADMIN_VERBOSEJMP(src)] with power of [power]")
	start_up()
	meltdown()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/debug_blowout(var/new_power)
	start_up()
	power = new_power
	message_admins("Reactor blowout triggered by admins in [ADMIN_VERBOSEJMP(src)] with power of [power]")
	meltdown()
	blowout()
