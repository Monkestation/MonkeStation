/// The light switch. Can have multiple per area.
/obj/machinery/light_switch
	name = "light switch"
	icon = 'monkestation/icons/obj/machinery/lightswitch.dmi'
	icon_state = "light-nopower"
	base_icon_state = "light"
	desc = "Make dark."
	power_channel = AREA_USAGE_LIGHT
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.02
	/// Set this to a string, path, or area instance to control that area
	/// instead of the switch's location.
	var/area/area = null
	///Range of the light emitted when powered, but off
	var/light_on_range = 1

/obj/machinery/light_switch/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/shell, list(new /obj/item/circuit_component/light_switch()), SHELL_CAPACITY_SMALL)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/light_switch, 26)

/obj/machinery/light_switch/Initialize(mapload)
	. = ..()
	if(istext(area))
		area = text2path(area)
	if(ispath(area))
		area = GLOB.areas_by_type[area]
	if(!area)
		area = get_area(src)

	if(!name)
		name = "light switch ([area.name])"

	update_appearance()

/obj/machinery/light_switch/update_appearance(updates=ALL)
	. = ..()
	luminosity = (machine_stat & NOPOWER) ? 0 : 1

/obj/machinery/light_switch/update_icon_state()
	set_light(area.lightswitch ? 0 : light_on_range)
	icon_state = "[base_icon_state]"
	if(machine_stat & NOPOWER)
		icon_state += "-nopower"
		return ..()
	icon_state += "[area.lightswitch ? "-on" : "-off"]"
	return ..()

/obj/machinery/light_switch/update_overlays()
	. = ..()
	if(machine_stat & NOPOWER)
		return ..()
	. += emissive_appearance(icon, "[base_icon_state]-emissive[area.lightswitch ? "-on" : "-off"]", alpha = src.alpha)

/obj/machinery/light_switch/examine(mob/user)
	. = ..()
	. += "It is [(machine_stat & NOPOWER) ? "unpowered" : (area.lightswitch ? "on" : "off")]."

/obj/machinery/light_switch/interact(mob/user)
	. = ..()
	set_lights(!area.lightswitch)

/obj/machinery/light_switch/proc/set_lights(status)
	if(area.lightswitch == status)
		return
	area.lightswitch = status
	area.update_appearance()

	for(var/obj/machinery/light_switch/light_switch in area)
		light_switch.update_appearance()
		playsound(src, 'sound/machines/click.ogg', 30, 3)
		SEND_SIGNAL(light_switch, COMSIG_LIGHT_SWITCH_SET, status)

	area.power_change()

/obj/machinery/light_switch/power_change()
	SHOULD_CALL_PARENT(FALSE)
	if(area == get_area(src))
		return ..()

/obj/machinery/light_switch/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(!(machine_stat & (BROKEN|NOPOWER)))
		power_change()

/obj/machinery/light_switch/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, "<span class='brass'>You begin manipulating [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		interact(eminence)

//Monkestation Edit - Readds the commented out lightswitch circuit
//Circuit Component
/obj/item/circuit_component/light_switch
	display_name = "Light Switch"
	desc = "Allows to control the lights of an area."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	///If the lights should be turned on or off when the trigger is triggered.
	var/datum/port/input/on_setting
	///Whether the lights are turned on
	var/datum/port/output/is_on
	///Triggers whenever the switch is toggled
	var/datum/port/output/toggled

/obj/item/circuit_component/light_switch/Initialize(mapload)
	. = ..()
	on_setting = add_input_port("On", PORT_TYPE_NUMBER)
	is_on = add_output_port("Is On", PORT_TYPE_NUMBER)
	toggled = add_output_port("Toggled", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/light_switch/register_shell(atom/movable/shell)
	RegisterSignal(shell, COMSIG_LIGHT_SWITCH_SET, .proc/on_light_switch_set)

/obj/item/circuit_component/light_switch/unregister_shell(atom/movable/shell)
	UnregisterSignal(shell, COMSIG_LIGHT_SWITCH_SET)

/obj/item/circuit_component/light_switch/proc/on_light_switch_set(datum/source, status)
	SIGNAL_HANDLER
	is_on.set_output(status)
	toggled.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/light_switch/Destroy()
	on_setting = null
	is_on = null
	toggled = null
	return ..()

/obj/item/circuit_component/light_switch/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return


	var/obj/machinery/light_switch/shell = parent.shell
	if(!istype(shell))
		return
	shell.set_lights(on_setting.input_value ? TRUE : FALSE)

