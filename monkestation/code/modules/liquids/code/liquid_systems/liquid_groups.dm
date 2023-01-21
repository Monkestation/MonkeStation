/***************************************************/
/********************PROPER GROUPING**************/

//Whenever you add a liquid cell add its contents to the group, have the group hold the reference to total reagents for processing sake
//Have the liquid turfs point to a partial liquids reference in the group for any interactions
//Have the liquid group handle the total reagents datum, and reactions too (apply fraction?)

GLOBAL_VAR_INIT(liquid_debug_colors, FALSE)

/datum/liquid_group
	var/color
	var/list/members = list()
	var/list/burning_members = list()
	var/datum/reagents/reagents
	var/expected_turf_height = 1
	var/total_reagent_volume = 0
	var/reagents_per_turf = 0
	var/group_overlay_state = LIQUID_STATE_PUDDLE
	var/group_alpha = 0
	var/group_temperature = 300
	var/group_color
	var/updated_total = FALSE
	var/failed_death_check = FALSE
	var/group_burn_power = 0
	var/group_fire_state = LIQUID_FIRE_STATE_NONE
	var/group_burn_rate = 0
	var/group_viscosity = 1

/datum/liquid_group/proc/add_to_group(turf/T)
	if(!T.liquids)
		T.liquids = new(null, src)
	members[T] = TRUE
	T.liquids.liquid_group = src
	reagents.maximum_volume += 1000 /// each turf will hold 1000 units plus the base amount spread across the group
	updated_total = TRUE
	if(group_color)
		T.liquids.color = group_color
	SSliquids.currentrun_active_turfs |= T
	process_group()

/datum/liquid_group/proc/remove_from_group(turf/T, splitting = FALSE)
	members -= T
	T.liquids.liquid_group = null
	if(SSliquids.currentrun_active_turfs[T])
		SSliquids.currentrun_active_turfs -= T
	SSliquids.remove_active_turf(T)

	if(burning_members[T])
		burning_members -= T
	if(SSliquids.burning_turfs[T])
		SSliquids.burning_turfs -= T

	if(!splitting)
		for(var/turf/open/nearby_turf in get_adjacent_open_turfs(T))
			if(nearby_turf.liquids && nearby_turf.liquids.liquid_group && nearby_turf.liquids.liquid_group.total_reagent_volume)
				SSliquids.active_edge_turfs |= nearby_turf

	if(!members.len)
		qdel(src)
		return
	updated_total = TRUE
	process_group()

/datum/liquid_group/proc/remove_all()
	for(var/turf/member in members)
		qdel(member.liquids)

/datum/liquid_group/New(height, obj/effect/abstract/liquid_turf/created_liquid)
	SSliquids.active_groups |= src
	color = "#[random_short_color()]"
	expected_turf_height = height
	reagents = new(100000)
	if(created_liquid)
		add_to_group(created_liquid.my_turf)
		SSliquids.active_edge_turfs |= created_liquid.my_turf

/datum/liquid_group/proc/can_merge_group(datum/liquid_group/otherg)
	return TRUE

/datum/liquid_group/proc/merge_group(datum/liquid_group/otherg)
	for(var/t in otherg.members)
		var/turf/T = t
		if(T.liquids)
			T.liquids.liquid_group = src
			members[T] = TRUE
	otherg.trans_to_seperate_group(src, otherg.total_reagent_volume, merge = TRUE)
	otherg.members = list()
	qdel(otherg)
	process_group()

/datum/liquid_group/proc/break_group()
	qdel(src)

/datum/liquid_group/Destroy()
	SSliquids.active_groups -= src
	for(var/t in members)
		var/turf/T = t
		T.liquids.liquid_group = null
	members = null
	burning_members = null
	return ..()

/datum/liquid_group/proc/check_adjacency(turf/member)
	var/adjacent_liquid = 0
	for(var/tur in member.GetAtmosAdjacentTurfs())
		var/turf/adjacent_turf = tur
		if(adjacent_turf.liquids)
			if(adjacent_turf.liquids.liquid_group == member.liquids.liquid_group)
				adjacent_liquid++
	if(adjacent_liquid < 2)
		return FALSE
	return TRUE

/datum/liquid_group/proc/process_group()
	if(!members || !members.len)
		check_dead()
		return
	var/old_color = group_color

	if(group_temperature != reagents.chem_temp)
		reagents.chem_temp = group_temperature

	if(GLOB.liquid_debug_colors)
		group_color = color
	else
		group_color = mix_color_from_reagent_list(reagents.reagent_list)

	if(group_color != old_color)
		for(var/turf/member in members)
			member.liquids.color = group_color

	if(total_reagent_volume != reagents.total_volume || updated_total)
		updated_total = FALSE
		total_reagent_volume = reagents.total_volume

		if(!total_reagent_volume || !members)
			return

		reagents_per_turf = total_reagent_volume / length(members)
		//alpha stuff
		var/alpha_setting = 1
		var/alpha_divisor = 1

		for(var/r in reagents.reagent_list)
			var/datum/reagent/R = r
			alpha_setting += max((R.opacity * R.volume), 1)
			alpha_divisor += max((1 * R.volume), 1)

		if(round(group_alpha, 1) != clamp(round(alpha_setting / alpha_divisor, 1), 1, 255))
			group_alpha = clamp(round(alpha_setting / alpha_divisor, 1), 120, 255)
			for(var/turf/member in members)
				member.liquids.alpha = group_alpha

	expected_turf_height = CEILING(reagents_per_turf, 1) / LIQUID_HEIGHT_DIVISOR
	var/old_overlay = group_overlay_state
	switch(expected_turf_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			group_overlay_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			group_overlay_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			group_overlay_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			group_overlay_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			group_overlay_state = LIQUID_STATE_FULLTILE
	if(old_overlay != group_overlay_state)
		for(var/turf/member in members)
			member.liquids.set_new_liquid_state(group_overlay_state)

/datum/liquid_group/proc/check_dead()
	if(!members && !total_reagent_volume)
		if(failed_death_check)
			qdel(src)
			return
		failed_death_check = TRUE

/datum/liquid_group/proc/process_member(turf/member)
	if(member.liquids.liquid_state != group_overlay_state)
		member.liquids.set_new_liquid_state(group_overlay_state)
	if(member.liquids.color != group_color)
		member.liquids.color = group_color
	SSliquids.evaporation_queue |= member
	var/list/adjacent_turfs = member.GetAtmosAdjacentTurfs()
	shuffle(adjacent_turfs)
	for(var/tur in adjacent_turfs)
		var/turf/adjacent_turf = tur
		if(!adjacent_turf.liquids)
			if(reagents_per_turf >= 3 && adjacent_turf.turf_height + group_viscosity <= expected_turf_height)
				spread_liquid(adjacent_turf, member)
		else if(adjacent_turf.liquids.liquid_group != member.liquids.liquid_group && member.liquids.liquid_group.can_merge_group(adjacent_turf.liquids.liquid_group))
			member.liquids.liquid_group.merge_group(adjacent_turf.liquids.liquid_group)
		//Immutable check thing
		if(adjacent_turf.liquids && adjacent_turf.liquids.immutable)
			if(member.z != adjacent_turf.z)
				var/turf/Z_turf_below = SSmapping.get_turf_below(member)
				if(adjacent_turf == Z_turf_below)
					qdel(member.liquids, TRUE)
					return
				else
					continue
		if(member.z != adjacent_turf.z)
			var/turf/Z_turf_below = SSmapping.get_turf_below(member)
			if(adjacent_turf == Z_turf_below)
				if(!(adjacent_turf.liquids && adjacent_turf.liquids.liquid_group != member.liquids.liquid_group && adjacent_turf.liquids.liquid_group.expected_turf_height >= LIQUID_HEIGHT_CONSIDER_FULL_TILE))
					member.liquids.liquid_group.transfer_reagents_to_secondary_group(member.liquids, adjacent_turf.liquids)
					. = TRUE
			continue
		. = TRUE

		if(!SSliquids.active_turfs[adjacent_turf] && adjacent_turf.liquids)
			SSliquids.add_active_turf(adjacent_turf)

/datum/liquid_group/proc/process_edge(turf/member)
	var/list/adjacent_turfs = get_adjacent_open_turfs(member)
	shuffle(adjacent_turfs)
	for(var/tur in adjacent_turfs)
		var/turf/adjacent_turf = tur
		if(!adjacent_turf.liquids)
			if(reagents_per_turf >= 3 && adjacent_turf.turf_height <= expected_turf_height)
				spread_liquid(adjacent_turf, member)
		else if(adjacent_turf.liquids.liquid_group != member.liquids.liquid_group && member.liquids.liquid_group.can_merge_group(adjacent_turf.liquids.liquid_group))
			member.liquids.liquid_group.merge_group(adjacent_turf.liquids.liquid_group)

/datum/liquid_group/proc/process_turf_disperse()
	if(reagents_per_turf < 1 || !total_reagent_volume)
		if(members && members.len)
			var/turf/picked_turf = pick(members)
			if(picked_turf.liquids)
				remove_from_group(picked_turf)
				qdel(picked_turf.liquids)
				if(!total_reagent_volume)
					reagents_per_turf = 0
				else
					reagents_per_turf = total_reagent_volume / length(members)
			else
				members -= picked_turf

/datum/liquid_group/proc/spread_liquid(turf/new_turf, turf/source_turf)
	if(new_turf.liquids)
		if(can_merge_group(new_turf.liquids.liquid_group))
			merge_group(new_turf.liquids.liquid_group)
		return

	SSliquids.active_edge_turfs -= source_turf
	var/adjacent = 0
	var/number_opens = 0
	for(var/turf/open/nearby_turf in get_adjacent_open_turfs(source_turf))
		number_opens++
		if(!nearby_turf.liquids && source_turf.liquids)
			adjacent++

	if(adjacent >= number_opens)
		SSliquids.active_edge_turfs |= source_turf

	reagents_per_turf = total_reagent_volume / members.len
	expected_turf_height = CEILING(reagents_per_turf, 1) / LIQUID_HEIGHT_DIVISOR

	new_turf.liquids = new(new_turf, src)
	water_rush(new_turf, source_turf)

/datum/liquid_group/proc/water_rush(turf/new_turf, turf/source_turf)
	var/direction = get_dir(source_turf, new_turf)
	for(var/atom/movable/target_atom in new_turf)
		if(!target_atom.anchored && !target_atom.pulledby && !isobserver(target_atom) && (target_atom.move_resist < INFINITY))
			reagents.reaction(target_atom, TOUCH, (reagents_per_turf * 0.5))
			if(expected_turf_height < LIQUID_ANKLES_LEVEL_HEIGHT)
				return
			step(target_atom, direction)
			if(isliving(target_atom) && prob(60))
				var/mob/living/target_living = target_atom
				target_living.Paralyze(6 SECONDS)
				to_chat(target_living, span_danger("You are knocked down by the currents!"))

/datum/liquid_group/proc/check_liquid_removal(obj/effect/abstract/liquid_turf/remover, amount)
	if(amount >= reagents_per_turf)
		remove_from_group(remover.my_turf)
		var/turf/remover_turf = remover.my_turf
		qdel(remover)
		check_split(remover_turf)
	process_group()

/datum/liquid_group/proc/remove_any(obj/effect/abstract/liquid_turf/remover, amount)
	reagents.remove_any(amount)
	if(remover)
		check_liquid_removal(remover, amount)
	updated_total = TRUE
	total_reagent_volume = reagents.total_volume
	reagents_per_turf = total_reagent_volume / members.len
	expected_turf_height = CEILING(reagents_per_turf, 1) / LIQUID_HEIGHT_DIVISOR
	if(!total_reagent_volume && !reagents.total_volume)
		remove_all()
		qdel(src)

/datum/liquid_group/proc/remove_specific(obj/effect/abstract/liquid_turf/remover, amount, datum/reagent/reagent_type)
	reagents.remove_reagent(reagent_type.type, amount)
	if(remover)
		check_liquid_removal(remover, amount)
	updated_total = TRUE
	total_reagent_volume = reagents.total_volume

/datum/liquid_group/proc/transfer_to_atom(obj/effect/abstract/liquid_turf/remover, amount, atom/transfer_target, transfer_method = INGEST)
	reagents.trans_to(transfer_target, amount, method = transfer_method)
	if(remover)
		check_liquid_removal(remover, amount)
	updated_total = TRUE
	total_reagent_volume = reagents.total_volume

/datum/liquid_group/proc/move_liquid_group(obj/effect/abstract/liquid_turf/member)
	remove_from_group(member.my_turf)
	member.liquid_group = new(1, member)
	var/remove_amount = reagents_per_turf / length(reagents.reagent_list)
	for(var/datum/reagent/reagent_type in reagents.reagent_list)
		member.liquid_group.reagents.add_reagent(reagent_type, remove_amount)
		remove_specific(amount = remove_amount, reagent_type = reagent_type)

/datum/liquid_group/proc/add_reagents(obj/effect/abstract/liquid_turf/member, reagent_list, chem_temp)
	reagents.add_reagent_list(reagent_list)
	handle_temperature(total_reagent_volume, chem_temp)
	process_group()

/datum/liquid_group/proc/add_reagent(obj/effect/abstract/liquid_turf/member, datum/reagent/reagent, amount, temperature)
	reagents.add_reagent(reagent, amount, temperature)
	handle_temperature(total_reagent_volume, temperature)
	process_group()

/datum/liquid_group/proc/transfer_reagents_to_secondary_group(obj/effect/abstract/liquid_turf/member, obj/effect/abstract/liquid_turf/transfer)
	var/remove_amount = reagents_per_turf / length(reagents.reagent_list)
	for(var/datum/reagent/reagent_type in reagents.reagent_list)
		transfer.liquid_group.reagents.add_reagent(reagent_type, remove_amount)
		remove_specific(amount = remove_amount, reagent_type = reagent_type)
	remove_from_group(member.my_turf)
	process_group()

/datum/liquid_group/proc/check_split(turf/checked_turf)
	if(!members || !members.len)
		return

	var/adjacent = 0
	var/turf/first_turf
	for(var/dir in GLOB.cardinals)
		var/turf/dir_turf = get_step(checked_turf, dir)
		if(dir_turf.liquids)
			first_turf = dir_turf
			break
	for(var/dir in GLOB.cardinals)
		var/turf/dir_turf = get_step(checked_turf, dir)
		if(dir_turf.liquids)
			if(dir_turf.liquids.liquid_group == first_turf.liquids.liquid_group)
				adjacent++

	if(adjacent == 0 && first_turf)
		split(list(first_turf))
		return

	var/list/current_adjacent = list()
	current_adjacent |= first_turf

	var/list/final_adjacent = list()

	var/getting_new_turfs = TRUE
	var/indef_loop_safety = 0
	while(getting_new_turfs && indef_loop_safety < LIQUID_RECURSIVE_LOOP_SAFETY)
		indef_loop_safety++
		getting_new_turfs = FALSE
		var/list/new_adjacent = list()
		var/list/old_final = list()
		for(var/turf/listed_turf in current_adjacent)
			for(var/dir in GLOB.cardinals)
				var/turf/dir_turf = get_step(listed_turf, dir)
				if(dir_turf.liquids)
					if(members[dir_turf])
						new_adjacent |= dir_turf
						final_adjacent |= dir_turf
						if(old_final != final_adjacent)
							getting_new_turfs = TRUE
		old_final = final_adjacent
		current_adjacent = new_adjacent

	if(final_adjacent.len == members.len)
		return
	split(final_adjacent)

/datum/liquid_group/proc/split(list/turfs_to_split)
	if(!turfs_to_split.len)
		return
	var/reagents_to_remove = length(turfs_to_split) * reagents_per_turf
	var/turf/chosen_starting_turf = pick(turfs_to_split)
	turfs_to_split -= chosen_starting_turf
	var/datum/liquid_group/new_group = new(1, chosen_starting_turf.liquids)

	for(var/turf/listed_turf in turfs_to_split)
		remove_from_group(listed_turf, TRUE)
		new_group.add_to_group(listed_turf)

	trans_to_seperate_group(new_group.reagents, reagents_to_remove, merge = TRUE)
	process_group()

/datum/liquid_group/proc/trans_to_seperate_group(datum/reagents/secondary_reagent, amount, obj/effect/abstract/liquid_turf/remover, merge = FALSE)
	reagents.trans_to(secondary_reagent, amount)
	if(remover)
		check_liquid_removal(remover, amount)
	else if(!merge)
		process_removal(amount)

/datum/liquid_group/proc/process_removal(amount)

	total_reagent_volume = reagents.total_volume
	process_group()
	if(total_reagent_volume)
		reagents_per_turf = total_reagent_volume / length(members)

	if(amount >= reagents_per_turf)
		if(!members.len)
			break_group()
		var/turf/remover_turf = pick(members)
		var/obj/effect/abstract/liquid_turf/remover = remover_turf.liquids
		remove_from_group(remover_turf)
		qdel(remover)
		check_split(remover_turf)

/datum/liquid_group/proc/handle_temperature(previous_reagents, temp)
	var/old_thermal = previous_reagents * group_temperature
	var/recieved_thermal = (total_reagent_volume - previous_reagents) * temp

	group_temperature = (recieved_thermal + old_thermal) / total_reagent_volume
	reagents.chem_temp = group_temperature



///Fire Related Procs / Handling

/datum/liquid_group/proc/get_group_burn()
	var/total_burn_power = 0
	var/total_burn_rate = 0
	for(var/datum/reagent/reagent_type in reagents.reagent_list)
		var/burn_power = initial(reagent_type.liquid_fire_power)
		if(burn_power)
			total_burn_power += burn_power * reagent_type.volume
			total_burn_rate += burn_power
	group_burn_rate = total_burn_rate
	if(!total_burn_power)
		if(burning_members.len)
			extinguish_all()
		group_burn_power = 0
		return

	total_burn_power /= reagents.total_volume //We get burn power per unit.
	if(total_burn_power <= REQUIRED_FIRE_POWER_PER_UNIT)
		return FALSE
	//Finally, we burn
	var/old_burn = group_burn_power

	group_burn_power = total_burn_power

	if(old_burn == group_burn_power)
		return
	switch(group_burn_power)
		if(0 to 7)
			group_fire_state = LIQUID_FIRE_STATE_SMALL
		if(7 to 8)
			group_fire_state = LIQUID_FIRE_STATE_MILD
		if(8 to 9)
			group_fire_state = LIQUID_FIRE_STATE_MEDIUM
		if(9 to 10)
			group_fire_state = LIQUID_FIRE_STATE_HUGE
		if(10 to INFINITY)
			group_fire_state = LIQUID_FIRE_STATE_INFERNO

/datum/liquid_group/proc/process_fire()
	get_group_burn()

	var/reagents_to_remove = group_burn_rate * (burning_members.len)

	if(!group_burn_power)
		extinguish_all()
		return

	remove_any(amount = reagents_to_remove)

	if(group_burn_rate >= reagents_per_turf * 0.2)
		for(var/num = 1, num < (burning_members.len), num++)
			var/turf/picked_turf = burning_members[1]
			extinguish(picked_turf)
			remove_from_group(picked_turf)
			qdel(picked_turf.liquids)

/datum/liquid_group/proc/ignite_turf(turf/member)
	get_group_burn()
	if(!group_burn_power)
		return

	member.liquids.fire_state = group_fire_state
	member.liquids.set_fire_effect()
	burning_members |= member
	SSliquids.burning_turfs |= member

/datum/liquid_group/proc/process_spread(turf/member)
	if(member.liquids.fire_state <= LIQUID_FIRE_STATE_MEDIUM) // fires to small to worth spreading
		return
	for(var/turf/adjacent_turf in get_adjacent_open_turfs(member))
		if(adjacent_turf.liquids && adjacent_turf.liquids.liquid_group == src && adjacent_turf.liquids.fire_state < member.liquids.fire_state)
			adjacent_turf.liquids.fire_state = group_fire_state
			member.liquids.set_fire_effect()
			burning_members |= adjacent_turf
			SSliquids.burning_turfs |= adjacent_turf

/datum/liquid_group/proc/extinguish_all()
	group_burn_power = 0
	group_fire_state = LIQUID_FIRE_STATE_NONE
	for(var/turf/member in burning_members)
		member.liquids.fire_state = LIQUID_FIRE_STATE_NONE
		member.liquids.set_fire_effect()
		if(burning_members[member])
			burning_members -= member
		if(SSliquids.burning_turfs[member])
			SSliquids.burning_turfs -= member

/datum/liquid_group/proc/extinguish(turf/member)
	member.liquids.fire_state = LIQUID_FIRE_STATE_NONE
	member.liquids.set_fire_effect()
	burning_members -= member
	if(SSliquids.burning_turfs[member])
		SSliquids.burning_turfs -= member

/datum/liquid_group/proc/expose_members_turf(obj/effect/abstract/liquid_turf/member)
	var/turf/members_turf = member.my_turf
	var/datum/reagents/exposed_reagents = new(1000)
	var/list/passed_list = list()
	for(var/reagent_type in reagents.reagent_list)
		var/amount = reagents.reagent_list[reagent_type] / members
		if(amount)
			continue
		remove_specific(src, amount * 0.2, reagent_type)
		passed_list[reagent_type] = amount

	exposed_reagents.add_reagent_list(passed_list, no_react = TRUE)
	exposed_reagents.chem_temp = group_temperature

	for(var/atom/movable/target_atom in members_turf)
		exposed_reagents.reaction(target_atom, TOUCH, liquid = TRUE)
	qdel(exposed_reagents)
