/obj/structure/nestbox
	name = "Nesting Box"
	desc = "A warm box perfect for a chicken"
	density = FALSE
	icon = 'icons/obj/structures.dmi'
	icon_state = "nestbox"
	anchored = FALSE


/obj/item/chicken_scanner
	name = "Chicken Scanner"
	desc = "Scans chickens to give you information about possible mutations that chicken can have"
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	item_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON

	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY


/obj/item/chicken_scanner/attack(mob/living/M, mob/living/carbon/human/user)
	if(!istype(M, /mob/living/simple_animal/chicken))
		return
	var/mob/living/simple_animal/chicken/scanned_chicken = M
	user.visible_message("<span class='notice'>[user] analyzes [scanned_chicken]'s possible mutations.</span>")

	chicken_scan(user, scanned_chicken)

/obj/item/chicken_scanner/proc/chicken_scan(mob/living/carbon/human/user, mob/living/simple_animal/chicken/scanned_chicken)
	for(var/mutation in scanned_chicken.mutation_list)
		var/datum/mutation/ranching/chicken/held_mutation = new mutation
		var/list/combined_msg = list()
		combined_msg += "\t<span class='notice'>[initial(held_mutation.egg_type.name)]</span>"
		if(held_mutation.happiness)
			combined_msg += "\t<span class='info'>Required Happiness: [held_mutation.happiness]</span>"
		if(held_mutation.needed_temperature)
			combined_msg += "\t<span class='info'>Required Temperature: Within [held_mutation.temperature_variance] K of [held_mutation.needed_temperature] K</span>"
		if(held_mutation.needed_pressure)
			combined_msg += "\t<span class='info'>Required Pressure: Within [held_mutation.pressure_variance] Kpa of [held_mutation.needed_pressure] Kpa </span>"
		if(held_mutation.food_requirements.len)
			var/list/foods = list()
			for(var/food in held_mutation.food_requirements)
				var/obj/item/food/listed_food = food
				foods += "[initial(listed_food.name)]"
			var/food_string = foods.Join(" , ")
			combined_msg += "\t<span class='info'>Required Foods: [food_string]</span>"
		if(held_mutation.reagent_requirements.len)
			var/list/reagents = list()
			for(var/reagent in held_mutation.reagent_requirements)
				var/datum/reagent/listed_reagent = reagent
				reagents += "[initial(listed_reagent.name)]"
			var/reagent_string = reagents.Join(" , ")
			combined_msg += "\t<span class='info'>Required Reagents: [reagent_string]</span>"
		if(held_mutation.needed_turfs.len)
			var/list/turfs = list()
			for(var/tile in held_mutation.needed_turfs)
				var/turf/listed_turf = tile
				turfs += "[initial(listed_turf.name)]"
			var/turf_string = turfs.Join(" , ")
			combined_msg += "\t<span class='info'>Required Environmental Turfs: [turf_string]</span>"
		if(held_mutation.required_atmos.len)
			var/list/gases = list()
			for(var/gas in held_mutation.required_atmos)
				gases += "[held_mutation.required_atmos[gas]] Moles of [gas]"
			var/gas_string = gases.Join(" , ")
			combined_msg += "\t<span class='info'>Required Environmental Gases: [gas_string]</span>"
		if(held_mutation.required_rooster)
			var/mob/living/simple_animal/chicken/rooster_type = held_mutation.required_rooster
			var/rooster_name = ""
			if(rooster_type.breed_name_male)
				rooster_name = initial(rooster_type.breed_name_male)
			else
				rooster_name = initial(rooster_type.name)
			combined_msg += "\t<span class='info'>Required Rooster:[rooster_name]</span>"
		if(held_mutation.player_job)
			combined_msg += "\t<span class='info'>Required Present Worker:[held_mutation.player_job]</span>"
		if(held_mutation.player_health)
			combined_msg += "\t<span class='info'>Requires Injured Personnel with atleast [held_mutation.player_health] damage taken </span>"
		if(held_mutation.needed_species)
			var/datum/species/species_type = held_mutation.needed_species
			combined_msg += "\t<span class='info'>Requires Present Worker that is a [initial(species_type.name)]</span>"
		if(held_mutation.liquid_depth)
			var/depth_name = ""
			switch(held_mutation.liquid_depth)
				if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
					depth_name = "A puddle"
				if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
					depth_name = "ankle deep"
				if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
					depth_name = "waist deep"
				if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
					depth_name = "shoulder deep"
				if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
					depth_name = "above head height"
			combined_msg += "\t<span class='info'>Requires liquid that is atleast [depth_name]</span>"

		to_chat(user, examine_block(combined_msg.Join("\n")))
