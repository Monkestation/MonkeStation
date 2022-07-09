/datum/ranching/mutation
	///The typepath of the chicken
	var/mob/living/simple_animal/chicken/chicken_type

	///Required Happiness
	var/happiness
	///temperature required
	var/needed_temperature
	///How much Variance can be in temperature creates a range around the required temperature
	var/temperature_variance
	///Pressure requirements
	var/needed_pressure
	///Pressure Variance
	var/pressure_variance

	///Special foods needed
	var/list/food_requirements
	///Special reagents needed
	var/list/reagent_requirements
	///Special turf requirements
	var/list/needed_turfs
	///Required nearby items
	var/list/nearby_items
	///Needed Rooster Type
	var/required_rooster


/obj/item/food/egg/proc/cycle_requirements(datum/ranching/mutation/supplier)
	if(check_happiness(supplier) && check_temperature(supplier) && check_pressure(supplier) && check_food(supplier) && check_reagent(supplier) && check_turfs(supplier) && check_items(supplier) && check_rooster(supplier))
		return TRUE
	else
		return FALSE

/obj/item/food/egg/proc/check_happiness(datum/ranching/mutation/supplier)
	if(supplier.happiness)
		if(!(src.happiness > supplier.happiness))
			message_admins("FAILED HAPPINESS")
			return FALSE
	return TRUE
/obj/item/food/egg/proc/check_temperature(datum/ranching/mutation/supplier)
	if(supplier.needed_temperature)
		var/turf/temp_turf = get_turf(src)

		var/temp_min = supplier.needed_temperature
		var/temp_max = supplier.needed_temperature

		if(supplier.pressure_variance)
			temp_min -= supplier.pressure_variance
			temp_max += supplier.pressure_variance
		if(!(temp_turf.return_temperature() <= temp_max) && !(temp_turf.return_temperature() >= temp_min))
			message_admins("FAILED TEMP")
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_pressure(datum/ranching/mutation/supplier)
	if(supplier.needed_pressure)

		var/turf/pressure_turf  = get_turf(src)
		var/datum/gas_mixture/environment = pressure_turf.return_air()

		var/pressure_min = supplier.needed_pressure
		var/pressure_max = supplier.needed_pressure

		if(supplier.pressure_variance)
			pressure_min -= supplier.pressure_variance
			pressure_max += supplier.pressure_variance
		if(!(environment.return_pressure() <=  pressure_max) && !(environment.return_pressure() >= pressure_min))
			message_admins("FAILED PRESSURE")
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_food(datum/ranching/mutation/supplier)
	if(supplier.food_requirements)
		var/list/needed_foods = list()
		var/obj/item/food/eaten_food
		for(var/obj/item/food/food_item in supplier.food_requirements)
			needed_foods += food_item
		for(var/food in src.consumed_food)
			eaten_food = food
			if(food in supplier.food_requirements)
				needed_foods -= eaten_food
		if(needed_foods.len)
			message_admins("FAILED FOOD")
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_reagent(datum/ranching/mutation/supplier)
	if(supplier.reagent_requirements)
		var/list/datum/reagent/needed_reagents = new/list
		var/datum/reagent/eaten_reagent
		for(var/datum/reagent/reagent in supplier.reagent_requirements)
			needed_reagents += reagent
		for(var/reagent in src.consumed_reagents)
			eaten_reagent = reagent
			if(eaten_reagent in supplier.reagent_requirements)
				needed_reagents -= eaten_reagent
		if(needed_reagents.len)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_turfs(datum/ranching/mutation/supplier)
	if(supplier.needed_turfs)
		for(var/turf/in_range_turf in view(2, src))
			if(in_range_turf in supplier.needed_turfs)
				supplier.needed_turfs -= in_range_turf
		if(supplier.needed_turfs)
			message_admins("FAILED TURF")
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_items(datum/ranching/mutation/supplier)
	if(supplier.nearby_items)
		var/list/needed_items = list()
		for(var/list_item in supplier.nearby_items)
			var/obj/item/needed_item = list_item
			needed_items.Add(needed_item)
		for(var/obj/item/in_range_item in view(3, src))
			if(in_range_item.type in supplier.nearby_items)
				needed_items -= in_range_item.type
		if(needed_items.len)
			message_admins("FAILED ITEMS")
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_rooster(datum/ranching/mutation/supplier)
	var/passed_check = FALSE
	if(supplier.required_rooster)
		var/mob/living/simple_animal/chicken/rooster = supplier.required_rooster
		for(var/mob/living/simple_animal/chicken/scanned_chicken in view(1, src.loc))
			if(istype(scanned_chicken, rooster.type) && gender == MALE)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/*
 EXAMPLE MUTATION

Everything in the mutation needs to be true in order for it to have a chance at being born, so be careful when overloading these things.
/datum/ranching/mutation/debug_chicken
	chicken_type = /mob/living/simple_animal/chicken/debug

	happiness = 25
	needed_temperature = 4
	temperature_variance = 40
	needed_pressure = 0
	pressure_variance = 2

	food_requirements = list(/obj/item/food/burger/human, /obj/item/food/donut/jelly)
	reagent_requirements = list(/datum/reagent/drug/methamphetamine)
	needed_turfs = list(/turf/open/floor/iron)
	nearby_items = list(/obj/item/screwdriver)
*/
