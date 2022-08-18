#define EXTRACTION_ORE_AMOUNT 1

/obj/machinery/drill
	name = "drilling apparatus"
	icon = 'monkestation/icons/obj/mining/drill.dmi'
	icon_state = "mining_drill"
	use_power = NO_POWER_USE
	density = TRUE
	anchored = TRUE
	var/ore_extraction_rate = 0.1
	var/extraction_amount
	var/obj/item/stack/ore/ore_to_spawn
	var/operating = FALSE
	var/is_powered = FALSE
	var/seismic_activity = null

	var/obj/machinery/ore_exit_port/port
	var/obj/machinery/computer/drills_controller/controller

	var/connected = FALSE

	var/datum/golem_controller/GC
	var/obj/item/radio/radio

/obj/machinery/drill/Initialize()
	. = ..()
	var/turf/open/floor/plating/asteroid/source_location = get_turf(src.loc)
	seismic_activity = source_location.seismic_activity
	if(!seismic_activity)
		repack()
		return

/obj/machinery/drill/AltClick(mob/user)
	. = ..()
	to_chat("You flip the switch on the drill ceasing its operation")
	operating = !operating


/obj/machinery/drill/Destroy()
	radio.talk_into(src, "WARNING DRILL INTEGRITY HAS REACHED CRITIAL FAILURE: PERSONNEL DEPLOYED TO THE DRILL MAY BE IN DANGER! DRILL LOCATION IS:[x], [y], [z]", RADIO_CHANNEL_SUPPLY)
	if(controller)
		controller.drills -= src
	if(seismic_activity)
		ore_to_spawn = null
	if(port)
		port = null
	if(GC)
		GC.stop()
	return ..()

/obj/machinery/drill/process(delta_time)
	if(!seismic_activity || !operating || !is_powered || !connected)
		if(GC)
			GC.stop()
			GC = null
		return
	if(!ore_to_spawn)
		pick_ore()
	if(!port)
		return
	if(!GC)
		var/turf/open/floor/plating/asteroid/T = get_turf(loc)
		GC = new /datum/golem_controller(location=T, seismic=T.seismic_activity, drill=src)
	extract_ores(delta_time)
	if(operating && is_powered)
		if(icon_state == "mining_drill_active")
			return
		icon_state = "mining_drill_active"
	else
		icon_state = "mining_drill_error"

/obj/machinery/drill/proc/pick_ore()
	switch(seismic_activity)
		if(1 to 2)
			ore_to_spawn = pickweight(list(
			/obj/item/stack/ore/iron = 25,
			/obj/item/stack/ore/copper = 25,
			/obj/item/stack/ore/glass = 25,
			/obj/item/stack/ore/plasma = 10,
			/obj/item/stack/ore/silver = 5,
			/obj/item/stack/ore/gold = 3,
			/obj/item/stack/ore/bananium = 3,
			/obj/item/stack/ore/diamond = 1,
			/obj/item/stack/ore/bluespace_crystal = 1,
			/obj/item/stack/ore/titanium = 2))
		if(3 to 4)
			ore_to_spawn = pickweight(list(
			/obj/item/stack/ore/iron = 20,
			/obj/item/stack/ore/copper = 20,
			/obj/item/stack/ore/glass = 20,
			/obj/item/stack/ore/plasma = 25,
			/obj/item/stack/ore/silver =10,
			/obj/item/stack/ore/gold = 5,
			/obj/item/stack/ore/bananium = 4,
			/obj/item/stack/ore/diamond = 2,
			/obj/item/stack/ore/bluespace_crystal = 2,
			/obj/item/stack/ore/titanium = 2))
		if(5 to 6)
			ore_to_spawn = pickweight(list(
			/obj/item/stack/ore/iron = 15,
			/obj/item/stack/ore/copper = 15,
			/obj/item/stack/ore/glass = 15,
			/obj/item/stack/ore/plasma = 30,
			/obj/item/stack/ore/silver = 10,
			/obj/item/stack/ore/gold = 10,
			/obj/item/stack/ore/bananium = 5,
			/obj/item/stack/ore/diamond = 5,
			/obj/item/stack/ore/bluespace_crystal = 5,
			/obj/item/stack/ore/titanium = 5))
		if(7)
			ore_to_spawn = pickweight(list(
			/obj/item/stack/ore/plasma = 10,
			/obj/item/stack/ore/silver = 5,
			/obj/item/stack/ore/gold = 5,
			/obj/item/stack/ore/bananium = 20,
			/obj/item/stack/ore/diamond = 20,
			/obj/item/stack/ore/bluespace_crystal = 20,
			/obj/item/stack/ore/titanium = 20))

/obj/machinery/drill/proc/extract_ores(delta_time)
	extraction_amount += ore_extraction_rate * EXTRACTION_ORE_AMOUNT * delta_time * (seismic_activity * 0.5)
	if(extraction_amount >= 1)
		var/ore_amount = round(extraction_amount, 1)
		extraction_amount -= ore_amount
		if(port)
			new ore_to_spawn(port.loc, ore_amount)
			ore_to_spawn = null

/obj/machinery/drill/proc/repack()
	if(seismic_activity)
		seismic_activity = null
	new/obj/item/drill_package(loc)
	qdel(src)

/obj/machinery/drill/proc/connect_port()
	if(connected)
		return
	for(var/obj/machinery/ore_exit_port/port_to_find in GLOB.machines)
		if(port_to_find)
			connected = TRUE
			port = port_to_find
			RegisterSignal(port, COMSIG_PARENT_QDELETING, .proc/disconnect_port)
			break

/obj/machinery/drill/proc/disconnect_port()
	UnregisterSignal(port, COMSIG_PARENT_QDELETING)
	connected = FALSE
	port = null

/obj/item/drill_package
	name = "drill pack"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverypackage3"

/obj/item/drill_package/Initialize()
	. = ..()
	AddComponent(/datum/component/gps, name)

/obj/item/drill_package/attack_self(mob/user, modifiers)
	var/turf/open/floor/plating/asteroid/user_location = get_turf(user.loc)
	if(locate(/obj/machinery/drill) in user_location)
		to_chat(user, "<span class='warning'>A drill is already present!</span>")
		return
	if(user_location.seismic_activity)
		new/obj/machinery/drill(user_location)
		qdel(src)

/obj/machinery/computer/drills_controller
	name = "mining drills controller"
	density = TRUE
	anchored = TRUE

	circuit = /obj/item/circuitboard/computer/drill_controller
	var/list/obj/machinery/drill/drills = list()
	var/connecting = FALSE

/obj/machinery/computer/drills_controller/process()
	if(!drills.len)
		return

	if(!is_operational)
		remove_drills()

	var/power_drill = 0
	for(var/obj/machinery/drill/considered_drill in drills)
		if(considered_drill.operating && considered_drill.is_powered && considered_drill.ore_extraction_rate > 0 && considered_drill.connected)
			power_drill += considered_drill.ore_extraction_rate * 200000

	if(power_drill > 0)
		use_power(power_drill, AREA_USAGE_EQUIP)

/obj/machinery/computer/drills_controller/proc/get_drills()
	for(var/obj/machinery/drill/drill_to_check in GLOB.machines)
		drills |= drill_to_check
		drill_to_check.controller = src
		drill_to_check.connect_port()

/obj/machinery/computer/drills_controller/proc/remove_drills()
	for(var/obj/machinery/drill/considered_drill in drills)
		considered_drill.is_powered = FALSE
		considered_drill.operating = FALSE
		considered_drill.controller = null
		if(considered_drill.GC)
			considered_drill.GC.stop()
			considered_drill.GC = null
		drills -= considered_drill

/obj/machinery/computer/drills_controller/proc/connected()
	get_drills()
	connecting = FALSE
	if(drills.len)
		visible_message("<span class='notice'>Drills reconnected successfully.</span>")
	else
		visible_message("<span class='notice'>No drills found.</span>")

/obj/machinery/computer/drills_controller/ui_interact(mob/user, datum/tgui/ui)
	if(panel_open)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DrillsController", name)
		ui.open()

/obj/machinery/computer/drills_controller/ui_data()
	var/data = list()
	for(var/obj/machinery/drill/considered_drill in drills)
		data["online_drills"] += list(list(
			"name" = considered_drill.name,
			"coord" = "[considered_drill.x], [considered_drill.y], [considered_drill.z]",
			"operating" = considered_drill.operating,
			"powered" = considered_drill.is_powered,
			"connected" = considered_drill.connected,
			"extraction_rate" = considered_drill.ore_extraction_rate * 10,
			"seismic_level" = considered_drill.seismic_activity,
			"power_consumption" = considered_drill.ore_extraction_rate * 200000,
			"drill_id" = considered_drill.id_tag
			))
	return data

/obj/machinery/computer/drills_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("operating")
			var/drill_id = params["drill_id"]
			for(var/obj/machinery/drill/considered_drill in drills)
				if(drill_id == considered_drill.id_tag)
					considered_drill.operating = !considered_drill.operating
					break
			. = TRUE
		if("power")
			var/drill_id = params["drill_id"]
			for(var/obj/machinery/drill/considered_drill in drills)
				if(drill_id == considered_drill.id_tag)
					considered_drill.is_powered = !considered_drill.is_powered
					break
			. = TRUE
		if("rate")
			var/amount = params["amount"]
			var/drill_id = params["drill_id"]
			if(text2num(amount) != null)
				amount = text2num(amount)
				. = TRUE
			if(.)
				for(var/obj/machinery/drill/considered_drill in drills)
					if(drill_id == considered_drill.id_tag)
						considered_drill.ore_extraction_rate = clamp(amount * 0.1, 0, 2)
		if("reconnect")
			if(!connecting)
				connecting = TRUE
				visible_message("<span class='notice'>Searching for available drills.</span>")
				addtimer(CALLBACK(src, .proc/connected), 2.5 SECONDS)
				. = TRUE
			else
				visible_message("<span class='warning'>Operation not available.</span>")

/obj/item/circuitboard/computer/drill_controller
	name = "drill controller (Computer Board)"
	icon_state = "supply"
	build_path = /obj/machinery/computer/drills_controller
