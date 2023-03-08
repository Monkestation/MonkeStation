//////////
// GUNS //
//////////

/datum/crafting_recipe/makeshift_lasrifle
	name = "Makeshift Laser Rifle"
	result = /obj/item/gun/energy/laser/makeshift_lasrifle
	reqs = list(/obj/item/stack/cable_coil = 15,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/pipe = 1,
				/obj/item/light/bulb = 1,
				/obj/item/stock_parts/cell = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_WIRECUTTER)
	time = 12 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/makeshift_pistol
	name = "Makeshift Pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/makeshift
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/rods = 2,
           		/obj/item/stack/tape = 3)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	time = 12 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/makeshiftmagazine
	name = "Makeshift Pistol Magazine (10mm)"
	result = /obj/item/ammo_box/magazine/m10mm/makeshift
	reqs = list(/obj/item/stack/sheet/iron = 2,
        		/obj/item/stack/tape = 2)
	time = 12 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/makeshift_suppressor
	name = "Makeshift Suppressor"
	result = /obj/item/suppressor/makeshift
	reqs = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/cotton/cloth = 2,
           		/obj/item/stack/tape = 1)
	time = 12 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON


///////////
// TOOLS //
///////////

/datum/crafting_recipe/makeshift_crowbar
	name = "Makeshift Crowbar"
	reqs = list(/obj/item/stack/rods = 3) //just bang them together
	result = /obj/item/crowbar/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_wrench
	name = "Makeshift Wrench"
	reqs = list(/obj/item/stack/sheet/iron = 2)
	result = /obj/item/wrench/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_wirecutters
	name = "Makeshift Wirecutters"
	reqs = list(/obj/item/stack/sheet/iron = 2,
				/obj/item/stack/rods = 2)
	result = /obj/item/wirecutters/makeshift
	time = 15 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_weldingtool
	name = "Makeshift Welding Tool"
	reqs = list(/obj/item/tank/internals/emergency_oxygen = 1,
				/obj/item/assembly/igniter = 1)
	tools = list(TOOL_SCREWDRIVER)
	result = /obj/item/weldingtool/makeshift
	time = 16 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_multitool
	name = "Makeshift Multitool"
	reqs = list(/obj/item/assembly/igniter = 1,
				/obj/item/assembly/signaler = 1,
				/obj/item/stack/sheet/iron = 2,
				/obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/multitool/makeshift
	time = 16 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_screwdriver
	name = "Makeshift Screwdriver"
	reqs = list(/obj/item/stack/rods = 3)
	result = /obj/item/screwdriver/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_knife
	name = "Makeshift Knife"
	reqs = list(/obj/item/stack/rods = 3,
				/obj/item/stack/sheet/iron = 1,
        		/obj/item/stack/tape = 2)
	result = /obj/item/kitchen/knife/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_pickaxe
	name = "Makeshift Pickaxe"
	reqs = list(
           /obj/item/crowbar = 1,
           /obj/item/kitchen/knife = 1,
           /obj/item/stack/tape = 1)
	result = /obj/item/pickaxe/makeshift
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_radio
	name = "Makeshift Radio"
	reqs = list(/obj/item/assembly/signaler = 1,
        		/obj/item/radio/headset = 1,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_SCREWDRIVER)
	result = /obj/item/radio/off/makeshift
	time = 12 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/makeshift_emag
	name = "Improvised Emag"
	reqs = list(/obj/item/stock_parts/subspace/amplifier = 1,
        			/obj/item/card/id = 1,
					/obj/item/electronics/firelock = 1,
				/obj/item/stack/cable_coil = 10)
	tools = list(TOOL_MULTITOOL, TOOL_WIRECUTTER)
	result = /obj/item/card/emag/improvised
	time = 12 SECONDS
	category = CAT_TOOLS
