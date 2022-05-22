/datum/crafting_recipe/iron_butt
	name = "Prosthetic Butt"
	result = /obj/item/organ/butt/iron
	reqs = list(	/obj/item/stack/sheet/iron = 6,
					/obj/item/stack/cable_coil = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 15
	category = CAT_MISC

/datum/crafting_recipe/yes_slip
	name = "Yes-Slip Shoes"
	result = /obj/item/clothing/shoes/yes_slip
	time = 20
	reqs = list(	/obj/item/reagent_containers/food/snacks/grown/banana = 2,
					/datum/reagent/lube = 100,
					/obj/item/stack/cable_coil = 1)
	tools = list(/obj/item/reagent_containers/food/snacks/grown/banana)
	category = CAT_CLOTHING

/datum/crafting_recipe/paper_mask
	name = "Monkey Mask"
	result = /obj/item/clothing/mask/ookmask
	time = 10
	reqs = list(/obj/item/paper = 5)
	category = CAT_CLOTHING
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/lockermech
	name = "Locker Mech"
	result = /obj/mecha/makeshift
	reqs = list(/obj/item/stack/cable_coil = 20,
				/obj/item/stack/sheet/iron = 10,
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

/datum/crafting_recipe/lockermechdrill
	name = "Makeshift exosuit drill"
	result = /obj/item/mecha_parts/mecha_equipment/drill/makeshift
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/iron = 2,
				/obj/item/surgicaldrill = 1)
	tools = list(/obj/item/screwdriver)
	time = 5 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/lockermechclamp
	name = "Makeshift exosuit clamp"
	result = /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/iron = 2,
				/obj/item/wirecutters = 1) //Don't ask, its just for the grabby grabby thing
	tools = list(/obj/item/screwdriver)
	time = 5 SECONDS
	category = CAT_ROBOT

//SMITHING RECIPES
/datum/crafting_recipe/furnace
	name = "Sandstone Furnace"
	result = /obj/structure/furnace
	time = 300
	reqs = list(/obj/item/stack/sheet/mineral/sandstone = 15,
	/obj/item/stack/sheet/iron = 4,
	/obj/item/stack/rods = 2)
	tools = list(TOOL_CROWBAR)
	category = CAT_SMITH

/datum/crafting_recipe/clock_furnace
	name = "Clockwork Furnace"
	result = /obj/structure/furnace/infinite/ratvar
	reqs = list(/obj/item/stack/tile/bronze = 10)
	tools = list(TOOL_CROWBAR)
	category = CAT_SMITH

/datum/crafting_recipe/basaltblock
	name = "Sintered Basalt Block"
	result = /obj/item/basaltblock
	time = 200
	reqs = list(/obj/item/stack/ore/glass/basalt = 50)
	tools = list(TOOL_WELDER)
	category = CAT_SMITH

/datum/crafting_recipe/twinsheath
	name = "Twin Sword Sheath"
	result = /obj/item/storage/belt/sabre/twin
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3,
				/obj/item/stack/sheet/leather = 8)
	tools = list(TOOL_WIRECUTTER)
	time = 70
	category = CAT_CLOTHING

//anvils
/datum/crafting_recipe/tableanvil
	name = "Table Anvil"
	result = /obj/structure/anvil/obtainable/table
	time = 300
	reqs = list(/obj/item/stack/sheet/iron = 4,
		        /obj/item/stack/rods = 2)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_SMITH

/datum/crafting_recipe/sandvil
	name = "Sandstone Anvil"
	result = /obj/structure/anvil/obtainable/sandstone
	time = 300
	reqs = list(/obj/item/stack/sheet/mineral/sandstone = 24)
	tools = list(TOOL_CROWBAR)
	category = CAT_SMITH

/datum/crafting_recipe/basaltanvil
	name = "Basalt Anvil"
	result = /obj/structure/anvil/obtainable/basalt
	time = 200
	reqs = list(/obj/item/basaltblock = 5)
	tools = list(TOOL_CROWBAR)
	category = CAT_SMITH

/datum/crafting_recipe/clockanvil
	name = "Clockwork Anvil"
	result = /obj/structure/anvil/obtainable/ratvar
	time = 200
	reqs = list(/obj/item/stack/tile/bronze = 10)
	tools = list(TOOL_CROWBAR)
	category = CAT_SMITH

//misc
/datum/crafting_recipe/clockhammer
	name = "Brass Smith's Hammer"
	result = /obj/item/melee/smith/hammer/ratvar
	time = 30
	reqs = list(/obj/item/stack/tile/bronze = 6,
				/obj/item/stick = 1)
	category = CAT_SMITH

/datum/crafting_recipe/swordhandle
	name = "Sword Handle"
	result = /obj/item/swordhandle
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	category = CAT_SMITH

/datum/crafting_recipe/stick
	name = "Wooden Rod"
	result = /obj/item/stick
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_SMITH

//ingots
/datum/crafting_recipe/ingot_iron
	name  = "Iron Ingot"
	result = /obj/item/ingot/iron
	time = 15
	reqs = list(/obj/item/stack/sheet/iron = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_diamond
	name  = "Diamond Ingot"
	result = /obj/item/ingot/diamond
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/diamond = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_uranium
	name  = "Uranium Ingot"
	result = /obj/item/ingot/uranium
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/uranium = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_plasma
	name  = "Plasma Ingot"
	result = /obj/item/ingot/plasma
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/plasma = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_copper
	name  = "Copper Ingot"
	result = /obj/item/ingot/copper
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/copper = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_gold
	name  = "Gold Ingot"
	result = /obj/item/ingot/gold
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/gold = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_silver
	name  = "Silver Ingot"
	result = /obj/item/ingot/silver
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/silver = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_bananium
	name  = "Hilarious Ingot"
	result = /obj/item/ingot/bananium
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_titanium
	name  = "Titanium Ingot"
	result = /obj/item/ingot/titanium
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/titanium = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_adamantine
	name  = "Adamant Ingot"
	result = /obj/item/ingot/adamantine
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/adamantine = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_cult
	name  = "Runed-Metal Ingot"
	result = /obj/item/ingot/cult
	time = 15
	reqs = list(/obj/item/stack/sheet/runed_metal = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_bronze
	name  = "Brass Ingot"
	result = /obj/item/ingot/bronze
	time = 15
	reqs = list(/obj/item/stack/tile/brass = 1)
	category = CAT_SMITH

/datum/crafting_recipe/ingot_ratvar
	name  = "Bronze Ingot"
	result = /obj/item/ingot/bronze/ratvar
	time = 15
	reqs = list(/obj/item/stack/tile/bronze = 1)
	category = CAT_SMITH
