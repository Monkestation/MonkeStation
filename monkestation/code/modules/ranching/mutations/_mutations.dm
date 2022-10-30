/datum/mutation/ranching/chicken
	///The typepath of the chicken
	var/mob/living/simple_animal/chicken/chicken_type
	///Egg type for egg so me don't gotta create new chicken
	var/obj/item/food/egg/egg_type

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
	var/list/food_requirements = list()
	///Special reagents needed
	var/list/reagent_requirements = list()
	///Special turf requirements
	var/list/needed_turfs = list()
	///Required nearby items
	var/list/nearby_items = list()
	///Needed Rooster Type
	var/required_rooster
	///Needed Breathable Air
	var/list/required_atmos = list()
	///Needed job from nearby players
	var/player_job
	///required liquid depth
	var/liquid_depth
	///Needed species
	var/needed_species
	///How hurt someone is, invert is so how damaaged is the number you put so for crit you would put 100
	var/player_health

/obj/item/food/egg/proc/cycle_requirements(datum/mutation/ranching/chicken/supplier)
	if(check_happiness(supplier) && check_temperature(supplier) && check_pressure(supplier) && check_food(supplier) && check_reagent(supplier) && check_turfs(supplier) && check_items(supplier) && check_rooster(supplier) && check_breathable_atmos(supplier) && check_players_job(supplier) && check_liquid_depth(supplier) && check_species(supplier) && check_players_health(supplier))
		return TRUE
	else
		return FALSE

/obj/item/food/egg/proc/check_happiness(datum/mutation/ranching/chicken/supplier)
	if(supplier.happiness)
		if(supplier.happiness > 0)
			if(!(src.happiness > supplier.happiness))
				return FALSE
		else
			if(!(src.happiness < supplier.happiness))
				return FALSE
	return TRUE

/obj/item/food/egg/proc/check_temperature(datum/mutation/ranching/chicken/supplier)
	if(supplier.needed_temperature)
		var/turf/temp_turf = get_turf(src)

		var/temp_min = supplier.needed_temperature
		var/temp_max = supplier.needed_temperature

		if(supplier.pressure_variance)
			temp_min -= max(supplier.pressure_variance, 1)
			temp_max += supplier.pressure_variance
		if(!(temp_turf.return_temperature() <= temp_max) && !(temp_turf.return_temperature() >= temp_min))
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_pressure(datum/mutation/ranching/chicken/supplier)
	if(supplier.needed_pressure)

		var/turf/pressure_turf  = get_turf(src)
		var/datum/gas_mixture/environment = pressure_turf.return_air()

		var/pressure_min = supplier.needed_pressure
		var/pressure_max = supplier.needed_pressure

		if(supplier.pressure_variance)
			pressure_min -= max(supplier.pressure_variance, 0)
			pressure_max += supplier.pressure_variance
		if(!(environment.return_pressure() <=  pressure_max) && !(environment.return_pressure() >= pressure_min))
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_food(datum/mutation/ranching/chicken/supplier)
	if(supplier.food_requirements.len)
		var/obj/item/food/eaten_food
		for(var/food in src.consumed_food)
			eaten_food = food
			if(eaten_food.type in supplier.food_requirements)
				supplier.food_requirements -= eaten_food.type
		if(supplier.food_requirements.len)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_reagent(datum/mutation/ranching/chicken/supplier)
	if(supplier.reagent_requirements.len)
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

/obj/item/food/egg/proc/check_turfs(datum/mutation/ranching/chicken/supplier)
	if(supplier.needed_turfs.len)
		for(var/turf/in_range_turf in view(2, src))
			if(in_range_turf in supplier.needed_turfs)
				supplier.needed_turfs -= in_range_turf
		if(supplier.needed_turfs)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_items(datum/mutation/ranching/chicken/supplier)
	if(supplier.nearby_items.len)
		var/list/needed_items = list()
		for(var/list_item in supplier.nearby_items)
			var/obj/item/needed_item = list_item
			needed_items.Add(needed_item)
		for(var/obj/item/in_range_item in view(3, src))
			if(in_range_item.type in supplier.nearby_items)
				needed_items -= in_range_item.type
		if(needed_items.len)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_rooster(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.required_rooster)
		var/mob/living/simple_animal/chicken/rooster = supplier.required_rooster
		for(var/mob/living/simple_animal/chicken/scanned_chicken in view(1, src.loc))
			if(istype(scanned_chicken, rooster.type) && gender == MALE)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_breathable_atmos(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.required_atmos)
		var/turf/open/egg_source_turf  = get_turf(src)
		for(var/gas in supplier.required_atmos)
			if(egg_source_turf.air.get_moles(gas) >= supplier.required_atmos[gas])
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_players_job(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.player_job)
		for(var/mob/living/carbon/human/in_range_player in view(3, src))
			if(in_range_player.mind.assigned_role == supplier.player_job)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_liquid_depth(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.liquid_depth)
		var/turf/open/egg_location = get_turf(src.loc)
		if(egg_location.liquids)
			if(egg_location.liquids.height >= supplier.liquid_depth)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_species(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.needed_species)
		for(var/mob/living/carbon/human/in_range_player in view(3, src))
			if(in_range_player.dna.species == supplier.needed_species)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE

/obj/item/food/egg/proc/check_players_health(datum/mutation/ranching/chicken/supplier)
	var/passed_check = FALSE
	if(supplier.player_health)
		for(var/mob/living/carbon/human/in_range_player in view(3, src))
			if(in_range_player.maxHealth - in_range_player.health >= supplier.player_health)
				passed_check = TRUE
		if(passed_check == FALSE)
			return FALSE
	return TRUE
