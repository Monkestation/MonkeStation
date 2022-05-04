/datum/crafting_recipe/lockermech
	name = "Locker Mech"
	result = /obj/mecha/makeshift
	reqs = list(/obj/item/stack/cable_coil = 20,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/storage/toolbox = 2, // For feet
				/obj/item/tank/internals/oxygen = 1, // For air
				/obj/item/electronics/airlock = 1, //You are stealing the motors from airlocks
				/obj/item/extinguisher = 1, //For bastard pnumatics
				/obj/item/paper = 5, //Cause paper is the best for making a mech airtight obviously
				/obj/item/flashlight = 1, //For the mech light
				/obj/item/stack/rods = 4, //to mount the equipment
				/obj/item/chair = 2) //For legs
	tools = list(/obj/item/weldingtool, /obj/item/screwdriver, /obj/item/wirecutters)
	time = 20 SECONDS
	category = CAT_ROBOT
