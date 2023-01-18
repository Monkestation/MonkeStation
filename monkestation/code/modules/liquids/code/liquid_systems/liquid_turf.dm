/turf
	var/obj/effect/abstract/liquid_turf/liquids
	var/liquid_height = 0
	var/turf_height = 0

/turf/proc/reasses_liquids()
	if(!liquids)
		return
	if(!liquids.liquid_group)
		liquids.liquid_group = new(1, liquids)
	SSliquids.add_active_turf(src)

/*
/turf/proc/liquid_fraction_delete(fraction)
	for(var/r_type in liquids.reagent_list)
		var/volume_change = liquids.reagent_list[r_type] * fraction
		liquids.reagent_list[r_type] -= volume_change
		liquids.total_reagents -= volume_change
*/

/turf/proc/liquid_update_turf()
	if(liquids && liquids.immutable)
		SSliquids.active_immutables[src] = TRUE
		return
	if(!liquids)
		return
	//Check atmos adjacency to cut off any disconnected groups
	if(liquids.liquid_group)
		var/assoc_atmos_turfs = list()
		for(var/tur in GetAtmosAdjacentTurfs())
			assoc_atmos_turfs[tur] = TRUE
		//Check any cardinals that may have a matching group
		for(var/direction in GLOB.cardinals)
			var/turf/T = get_step(src, direction)
			if(!T.liquids)
				return

	SSliquids.add_active_turf(src)

/turf/proc/add_liquid_from_reagents(datum/reagents/giver, no_react = FALSE)
	var/list/compiled_list = list()
	for(var/r in giver.reagent_list)
		var/datum/reagent/R = r
		if(!(R.type in GLOB.liquid_blacklist))
			compiled_list[R.type] = R.volume
	if(!compiled_list.len) //No reagents to add, don't bother going further
		return
	if(!liquids)
		liquids = new(src)
	liquids.liquid_group.add_reagents(liquids, compiled_list)

//More efficient than add_liquid for multiples
/turf/proc/add_liquid_list(reagent_list, no_react = FALSE, chem_temp)
	if(!liquids)
		liquids = new(src)
	liquids.liquid_group.add_reagents(liquids, reagent_list)
	//Expose turf
	liquids.liquid_group.expose_members_turf(liquids)

/turf/proc/add_liquid(reagent, amount, no_react = FALSE, chem_temp = 300)
	if(reagent in GLOB.liquid_blacklist)
		return
	if(!liquids)
		liquids = new(src)

	liquids.liquid_group.add_reagent(liquids, reagent, amount)
	//Expose turf
	liquids.liquid_group.expose_members_turf()

/turf/proc/can_share_liquids_with(turf/T)
	if(T.z != z) //No Z here handling currently
		return FALSE

	if(T.liquids && T.liquids.immutable)
		return FALSE

	if(istype(T, /turf/open/space)) //No space liquids - Maybe add an ice system later
		return FALSE

	var/my_liquid_height = liquids ? liquids.liquid_group.expected_turf_height : 0
	if(my_liquid_height < 1)
		return FALSE
	var/target_height = T.liquids ? T.liquids.liquid_group.expected_turf_height : 0

	//Varied heights handling:
	if(liquid_height != T.liquid_height)
		if(my_liquid_height+liquid_height < target_height + T.liquid_height + 1)
			return FALSE
		else
			return TRUE

	var/difference = abs(target_height - my_liquid_height)
	//The: sand effect or "piling" Very good for performance
	if(difference >= 1) //SHOULD BE >= 1 or > 1? '>= 1' can lead into a lot of unnessecary processes, while ' > 1' will lead to a "piling" phenomena
		return TRUE
	return FALSE

/turf/proc/process_liquid_cell()

	if(liquids)
		var/turf/open/temp_turf = get_turf(src)
		var/datum/gas_mixture/gas = temp_turf.air
		if(gas)
			if(gas.return_temperature() > liquids.liquid_group.group_temperature)
				var/increaser =((gas.return_temperature() * gas.total_moles()) + (liquids.liquid_group.group_temperature * liquids.liquid_group.total_reagent_volume)) / (2 + liquids.liquid_group.total_reagent_volume + gas.total_moles())
				if(increaser > liquids.liquid_group.group_temperature + 3)
					gas.set_temperature(increaser)
					liquids.liquid_group.group_temperature = increaser
					gas.react()
			else if(liquids.liquid_group.group_temperature > gas.return_temperature())
				var/increaser =((gas.return_temperature() * gas.total_moles()) + (liquids.liquid_group.group_temperature * liquids.liquid_group.total_reagent_volume)) / (2 + liquids.liquid_group.total_reagent_volume + gas.total_moles())
				if(increaser > gas.return_temperature() + 3)
					liquids.liquid_group.group_temperature = increaser
					gas.set_temperature(increaser)
					gas.react()

	if(!liquids)
		/*
		if(!lgroup)
			for(var/tur in GetAtmosAdjacentTurfs())
				var/turf/T2 = tur
				if(T2.liquids)
					if(T2.liquids.immutable)
						SSliquids.active_immutables[T2] = TRUE
					else if (T2.can_share_liquids_with(src))
						if(T2.lgroup)
							lgroup = new(liquid_height)
							lgroup.add_to_group(src)
						SSliquids.add_active_turf(T2)
						SSliquids.remove_active_turf(src)
						break*/
		SSliquids.remove_active_turf(src)
		return
	if(QDELETED(liquids)) //Liquids may be deleted in process cell
		SSliquids.remove_active_turf(src)
		return

/turf/proc/process_immutable_liquid()
	var/any_share = FALSE
	for(var/tur in GetAtmosAdjacentTurfs())
		var/turf/T = tur
		if(can_share_liquids_with(T))
			//Move this elsewhere sometime later?
			if(T.liquids && T.liquids.liquid_group.expected_turf_height > liquids.liquid_group.expected_turf_height)
				continue

			any_share = TRUE
			T.add_liquid_list(liquids.liquid_group.reagents.reagent_list, TRUE, liquids.liquid_group.group_temperature)
	if(!any_share)
		SSliquids.active_immutables -= src
