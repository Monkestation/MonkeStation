/**
 * # Man-Machine Interface Component
 *
 * Allows an MMI to be inserted into a shell, allowing it to be linked up. Requires a shell.
 */
/obj/item/circuit_component/mmi
	display_name = "Man-Machine Interface"
	display_desc = "A component that allows MMI to enter shells to send output signals."

	/// The message to send to the MMI in the shell.
	var/datum/port/input/message
	/// Sends the current MMI a message
	var/datum/port/input/send
	/// Ejects the current MMI
	var/datum/port/input/eject

	/// Called when the MMI tries moving north
	var/datum/port/output/north
	/// Called when the MMI tries moving east
	var/datum/port/output/east
	/// Called when the MMI tries moving south
	var/datum/port/output/south
	/// Called when the MMI tries moving west
	var/datum/port/output/west

	/// Returns what the MMI last clicked on.
	var/datum/port/output/clicked_atom

	//MONKESTATION EDIT: replaces secondary attack with the the trigger action

	/// Called when the MMI presses their trigger.
	var/datum/port/output/trigger_button

	//The trigger action to grant/remove from mmis
	var/datum/action/innate/mmi_component_trigger/trigger_action = new

	//MONKESTATION EDIT END

	/// Called when the MMI clicks.
	var/datum/port/output/attack

	/// The current MMI card
	var/obj/item/mmi/brain


	/// Maximum length of the message that can be sent to the MMI
	var/max_length = 300

/obj/item/circuit_component/mmi/Initialize(mapload)
	. = ..()
	message = add_input_port("Message", PORT_TYPE_STRING)
	send = add_input_port("Send Message", PORT_TYPE_SIGNAL)
	eject = add_input_port("Eject", PORT_TYPE_SIGNAL)

	north = add_output_port("North", PORT_TYPE_SIGNAL)
	east = add_output_port("East", PORT_TYPE_SIGNAL)
	south = add_output_port("South", PORT_TYPE_SIGNAL)
	west = add_output_port("West", PORT_TYPE_SIGNAL)

	trigger_button = add_output_port("Triggered", PORT_TYPE_SIGNAL)

	attack = add_output_port("Attack", PORT_TYPE_SIGNAL)
	clicked_atom = add_output_port("Target Entity", PORT_TYPE_ATOM)

/obj/item/circuit_component/mmi/Destroy()
	remove_current_brain()
	message = null
	send = null
	eject = null
	north = null
	east = null
	south = null
	west = null
	attack = null
	trigger_button = null
	clicked_atom = null
	trigger_action = null
	return ..()

/obj/item/circuit_component/mmi/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	if(!brain)
		return

	if(COMPONENT_TRIGGERED_BY(eject, port))
		remove_current_brain()
	if(COMPONENT_TRIGGERED_BY(send, port))
		if(!message.input_value)
			return

		var/msg_str = copytext(html_encode(message.input_value), 1, max_length)

		var/mob/living/target = brain.brainmob
		if(!target)
			return

		to_chat(target, "<span class='bold'>A message echoes through your mind: </span>[msg_str]")


/obj/item/circuit_component/mmi/register_shell(atom/movable/shell)
	. = ..()
	RegisterSignal(shell, COMSIG_PARENT_ATTACKBY, .proc/handle_attack_by)

/obj/item/circuit_component/mmi/unregister_shell(atom/movable/shell)
	UnregisterSignal(shell, COMSIG_PARENT_ATTACKBY)
	remove_current_brain()
	return ..()

/obj/item/circuit_component/mmi/proc/handle_attack_by(atom/movable/shell, obj/item/item, mob/living/attacker)
	SIGNAL_HANDLER
	if(istype(item, /obj/item/mmi))
		var/obj/item/mmi/target_mmi = item
		if(!target_mmi.brainmob)
			return
		add_mmi(item)
		return COMPONENT_NO_AFTERATTACK

/obj/item/circuit_component/mmi/proc/add_mmi(obj/item/mmi/to_add)
	remove_current_brain()

	to_add.forceMove(src)
	if(to_add.brainmob)
		update_mmi_mob(to_add, null, to_add.brainmob)
	brain = to_add
	trigger_action.Grant(to_add.brainmob, src)
	RegisterSignal(to_add, COMSIG_PARENT_QDELETING, .proc/remove_current_brain)
	RegisterSignal(to_add, COMSIG_MOVABLE_MOVED, .proc/mmi_moved)

/obj/item/circuit_component/mmi/proc/mmi_moved(atom/movable/mmi)
	if(mmi.loc != src)
		remove_current_brain()

/obj/item/circuit_component/mmi/proc/remove_current_brain()
	SIGNAL_HANDLER

	if(!brain)
		return

	if(brain.brainmob)
		update_mmi_mob(brain, brain.brainmob)
	UnregisterSignal(brain, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED
	))
	if(brain.loc == src)
		brain.forceMove(drop_location())
	trigger_action.Remove(brain.brainmob)
	brain = null

/obj/item/circuit_component/mmi/proc/update_mmi_mob(datum/source, mob/living/old_mmi, mob/living/new_mmi)
	SIGNAL_HANDLER
	if(old_mmi)
		old_mmi.remote_control = null
		UnregisterSignal(old_mmi, COMSIG_MOB_CLICKON)
	if(new_mmi)
		new_mmi.remote_control = src
		RegisterSignal(new_mmi, COMSIG_MOB_CLICKON, .proc/handle_mmi_attack)

/obj/item/circuit_component/mmi/relaymove(mob/living/user, direct)
	if(user != brain.brainmob)
		return ..()

	if(direct & NORTH)
		north.set_output(COMPONENT_SIGNAL)
	if(direct & WEST)
		west.set_output(COMPONENT_SIGNAL)
	if(direct & EAST)
		east.set_output(COMPONENT_SIGNAL)
	if(direct & SOUTH)
		south.set_output(COMPONENT_SIGNAL)

	return TRUE

/obj/item/circuit_component/mmi/proc/handle_mmi_attack(mob/living/source, atom/target)
	SIGNAL_HANDLER

	clicked_atom.set_output(target)
	attack.set_output(COMPONENT_SIGNAL)
	. = COMSIG_MOB_CANCEL_CLICKON

/obj/item/circuit_component/mmi/add_to(obj/item/integrated_circuit/add_to)
	. = ..()
	if(HAS_TRAIT(add_to, TRAIT_COMPONENT_MMI))
		return FALSE
	ADD_TRAIT(add_to, TRAIT_COMPONENT_MMI, src)

/obj/item/circuit_component/mmi/removed_from(obj/item/integrated_circuit/removed_from)
	REMOVE_TRAIT(removed_from, TRAIT_COMPONENT_MMI, src)
	remove_current_brain()
	return ..()

/obj/item/circuit_component/mmi/proc/activate_trigger()
	trigger_button.set_output(COMPONENT_SIGNAL)

/datum/action/innate/mmi_component_trigger
	name = "Trigger"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "power_green"
	var/obj/item/circuit_component/mmi/component

/datum/action/innate/mmi_component_trigger/Grant(mob/living/grantee, obj/item/circuit_component/mmi/new_component)
	if(new_component)
		component = new_component
	..()

/datum/action/innate/mmi_component_trigger/Destroy()
	component = null
	return ..()

/datum/action/innate/mmi_component_trigger/Activate()
	component.activate_trigger()
