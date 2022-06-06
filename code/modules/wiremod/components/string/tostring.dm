/**
 * # To String Component
 *
 * Converts any value into a string
 */
/obj/item/circuit_component/tostring
	display_name = "To String"
	display_desc = "A component that converts its input to text."

	/// The input port
	var/datum/port/input/input_port

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/tostring/Initialize(mapload)
	. = ..()
	input_port = add_input_port("Input", PORT_TYPE_ANY)

	output = add_output_port("Output", PORT_TYPE_STRING)

/obj/item/circuit_component/tostring/Destroy()
	input_port = null
	output = null
	return ..()

/obj/item/circuit_component/tostring/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	var/input_value = input_port.input_value

	output.set_output("[input_value]")

//MONKESTATION EDIT: Removed max range, makes sense on some other components, but not this one
