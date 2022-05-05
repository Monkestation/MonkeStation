/obj/machinery/door/crush()
	.=..()
	for(var/obj/item/toy/plush/goatplushie/target in get_turf(src))
		target.flatten()
