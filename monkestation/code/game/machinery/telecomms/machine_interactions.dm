/obj/machinery/telecomms/receiver/add_option()
	var/list/data = list()
	data["type"] = "receiver"

	//text-to-radio circuit stuff
	var/list/circuits = list()
	var/n = 0
	data["circuits"] = list()
	for(var/c in GLOB.ic_speakers)
		var/obj/item/integrated_circuit/I = c
		var/obj/item/O = I.get_object()
		var/list/circuit = list()
		if(get_area(O)) //if it isn't in nullspace, can happen due to printer newing all possible circuits to fetch list data
			n++
			circuit["index"] = n
			circuit["name"] = O.name
			circuit["coords"] = "[O.x], [O.y], [O.z]"
			circuits += list(circuit)
	data["circuits"] = circuits
	return data

