/obj/item/seeds/proc/has_viable_mutations()
	for(var/datum/hydroponics/plant_mutation/listed_mutation in possible_mutations)
		if(listed_mutation.check_viable(src))
			return TRUE

/obj/item/seeds/proc/create_valid_mutation(output_loc, is_seed = FALSE)
	var/list/passed_vibe_check = list()
	for(var/datum/hydroponics/plant_mutation/listed_mutation in possible_mutations)
		if(listed_mutation.check_viable(src))
			passed_vibe_check += listed_mutation

	var/datum/hydroponics/plant_mutation/picked_mutation = pick(passed_vibe_check)
	var/obj/item/created_item
	if(!is_seed && picked_mutation.created_product)
		created_item = new picked_mutation.created_product(output_loc)
	else
		created_item = new picked_mutation.created_seed(output_loc)
	return created_item

/datum/hydroponics/plant_mutation
	///items that are created if chosen
	var/obj/item/created_product
	var/obj/item/seeds/created_seed

	///stats required to actually pass the vibe check
	var/list/required_potency = list()
	var/list/required_yield = list()
	var/list/required_production = list()
	var/list/required_endurance = list()
	var/list/required_lifespan = list()

/datum/hydroponics/plant_mutation/proc/check_viable(obj/item/seeds/checked_seed)
	if(required_potency.len)
		var/low_end = required_potency[1]
		var/high_end = required_potency[2]
		if(!(low_end <= checked_seed.potency &&  checked_seed.potency <= high_end))
			return FALSE
	if(required_yield.len)
		var/low_end = required_yield[1]
		var/high_end = required_yield[2]
		if(!(low_end <= checked_seed.yield && checked_seed.yield <= high_end))
			return FALSE
	if(required_production.len)
		var/low_end = required_production[1]
		var/high_end = required_production[2]
		if(!(low_end <= checked_seed.production && checked_seed.production <= high_end))
			return FALSE
	if(required_endurance.len)
		var/low_end = required_endurance[1]
		var/high_end = required_endurance[2]
		if(!(low_end <= checked_seed.endurance && checked_seed.endurance <= high_end))
			return FALSE
	if(required_lifespan.len)
		var/low_end = required_lifespan[1]
		var/high_end = required_lifespan[2]
		if(!(low_end <= checked_seed.lifespan && checked_seed.lifespan <= high_end))
			return FALSE
	return TRUE


/datum/hydroponics/plant_mutation/spliced_mutation
	var/list/required_types = list()

/obj/item/seeds/spliced/proc/return_viable_mutations()
	var/list/returned_list = list()
	for(var/datum/hydroponics/plant_mutation/spliced_mutation/listed_mutation as anything in (typesof(/datum/hydroponics/plant_mutation/spliced_mutation) - /datum/hydroponics/plant_mutation/spliced_mutation))
		listed_mutation = new listed_mutation.type
		if(listed_mutation.check_viable())
			for(var/item in listed_mutation.required_types)
				if(item in produce_list)
					listed_mutation.required_types -= item
			if(!listed_mutation.required_types.len)
				returned_list += listed_mutation
	return returned_list

