// zap needs to be over this amount to get power
#define TESLA_COIL_THRESHOLD 80
// each zap power unit produces 400 joules
#define ZAP_TO_ENERGY(p) (joules_to_energy((p) * 400))

/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "For the union!"
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil0"
	anchored = FALSE
	density = TRUE

	// Executing a traitor caught releasing tesla was never this fun!
	can_buckle = TRUE
	buckle_lying = 0
	buckle_requires_restraints = TRUE

	circuit = /obj/item/circuitboard/machine/tesla_coil

	///Flags of the zap that the coil releases when the wire is pulsed
	var/zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_LOW_POWER_GEN
	var/power_loss = 2
	var/input_power_multiplier = 1
	var/zap_cooldown = 100
	var/last_zap = 0
	///The amount of energy that is currently inside the machine before being converted to electricity
	var/stored_energy = 0
	var/datum/techweb/linked_techweb

/obj/machinery/power/tesla_coil/power
	circuit = /obj/item/circuitboard/machine/tesla_coil/power

/obj/machinery/power/tesla_coil/Initialize(mapload)
	. = ..()
	wires = new /datum/wires/tesla_coil(src)
	linked_techweb = SSresearch.science_tech

/obj/machinery/power/tesla_coil/RefreshParts()
	var/power_multiplier = 0
	zap_cooldown = 100
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		power_multiplier += C.rating
		zap_cooldown -= (C.rating * 20)
	input_power_multiplier = (0.85 * (power_multiplier / 4)) //Max out at 85% efficency.

/obj/machinery/power/tesla_coil/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Power generation at <b>[input_power_multiplier*100]%</b>.<br>Shock interval at <b>[zap_cooldown*0.1]</b> seconds.</span>"

/obj/machinery/power/tesla_coil/on_construction()
	if(anchored)
		connect_to_network()

/obj/machinery/power/tesla_coil/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(panel_open)
			icon_state = "coil_open[anchored]"
		else
			icon_state = "coil[anchored]"
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()

/obj/machinery/power/tesla_coil/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "coil_open[anchored]", "coil[anchored]", W))
		return

	if(default_unfasten_wrench(user, W))
		return

	if(default_deconstruction_crowbar(W))
		return

	if(is_wire_tool(W) && panel_open)
		wires.interact(user)
		return

	return ..()

/obj/machinery/power/tesla_coil/zap_act(power, zap_flags)
	if(!anchored || panel_open)
		return ..()
	obj_flags |= BEING_SHOCKED
	addtimer(CALLBACK(src, .proc/reset_shocked), 1 SECONDS)
	flick("coilhit", src)
	if(!(zap_flags & ZAP_GENERATES_POWER)) //Prevent infinite recursive power
		return 0
	if(zap_flags & ZAP_LOW_POWER_GEN)
		power /= 10
	zap_buckle_check(power)
	var/power_removed = powernet ? power * input_power_multiplier : power
	stored_energy += max(ZAP_TO_ENERGY(power_removed - TESLA_COIL_THRESHOLD), 0)
	return max(power - power_removed, 0) //You get back the amount we didn't use

/obj/machinery/power/tesla_coil/proc/zap()
	if((last_zap + zap_cooldown) > world.time || !powernet)
		return FALSE
	last_zap = world.time
	var/coeff = (20 - ((input_power_multiplier - 1) * 3))
	coeff = max(coeff, 10)
	var/power = (powernet.avail/2)
	add_load(power)
	playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 10, power/(coeff/2), zap_flags)
	zap_buckle_check(power/(coeff/2))

// Tesla R&D researcher
/obj/machinery/power/tesla_coil/research
	name = "Tesla Corona Analyzer"
	desc = "A modified Tesla Coil used to study the effects of Edison's Bane for research."
	icon_state = "rpcoil0"
	circuit = /obj/item/circuitboard/machine/tesla_coil/research
	power_loss = 20 // something something, high voltage + resistance

/obj/machinery/power/tesla_coil/research/zap_act(power, zap_flags, shocked_targets)
	if(anchored && !panel_open)
		obj_flags |= BEING_SHOCKED
		var/power_produced = powernet ? power / power_loss : power
		add_avail(power_produced*input_power_multiplier)
		flick("rpcoilhit", src)
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_ENG)
		if(D)
			D.adjust_money(min(power_produced, 3))
		if(istype(linked_techweb))
			linked_techweb.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, min(power_produced, 3)) // x4 coils with a pulse per second or so = ~720/m point bonus for R&D
		addtimer(CALLBACK(src, .proc/reset_shocked), 10)
		zap_buckle_check(power)
		playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
		if(!(zap_flags))
			return power_produced
		tesla_zap(src, 5, power_produced, zap_flags, shocked_targets)
	else
		..()

/obj/machinery/power/tesla_coil/research/default_unfasten_wrench(mob/user, obj/item/wrench/W, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(panel_open)
			icon_state = "rpcoil_open[anchored]"
		else
			icon_state = "rpcoil[anchored]"

/obj/machinery/power/tesla_coil/research/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "rpcoil_open[anchored]", "rpcoil[anchored]", W))
		return
	return ..()

/obj/machinery/power/tesla_coil/research/on_construction()
	if(anchored)
		connect_to_network()

/obj/machinery/power/grounding_rod
	name = "grounding rod"
	desc = "Keep an area from being fried from Edison's Bane."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod0"
	anchored = FALSE
	density = TRUE

	can_buckle = TRUE
	buckle_lying = FALSE
	buckle_requires_restraints = TRUE

/obj/machinery/power/grounding_rod/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(panel_open)
			icon_state = "grounding_rod_open[anchored]"
		else
			icon_state = "grounding_rod[anchored]"

/obj/machinery/power/grounding_rod/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grounding_rod_open[anchored]", "grounding_rod[anchored]", W))
		return

	if(default_unfasten_wrench(user, W))
		return

	if(default_deconstruction_crowbar(W))
		return

	return ..()

/obj/machinery/power/grounding_rod/zap_act(var/power)
	if(anchored && !panel_open)
		flick("grounding_rodhit", src)
		zap_buckle_check(power)
		return 0
	else
		. = ..()

#undef TESLA_COIL_THRESHOLD
#undef ZAP_TO_ENERGY
