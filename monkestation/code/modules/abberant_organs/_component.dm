/datum/component/abberant_organ
	///list of attached nodes to the organ split into their node types
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/special_nodes = list()


	var/list/partnerless_inputs = list()
	var/list/partnerless_outputs = list()

	///the carbon this organ is owned and inside of
	var/mob/living/carbon/organ_owner

	///the stability of an organ in percentage form, affects adding more nodes to the organ
	var/stability = 100
	///stability modifers given by special nodes
	var/stability_modifer = 1
	///the maximum tier difference between inputs and outputs
	var/maximum_tier_difference = 1
	///how many tiers should it increase when a new node is added
	var/tier_modifer = 0
	///how much purity should be modified when a new node is added
	var/purity_modifer = 0

/datum/component/abberant_organ/Initialize(stability = 100, stability_modifer = 1, maximum_tier_difference = 1, list/inputs, list/outputs, list/special_nodes)
	. = ..()

	src.stability = stability
	src.stability_modifer = stability_modifer
	src.maximum_tier_difference = maximum_tier_difference

	if(inputs.len)
		for(var/datum/abberant_organs/input/held_input as anything in inputs)
			var/datum/abberant_organs/input/new_input = new held_input
			handle_input_injection(new_input)
	if(outputs.len)
		for(var/datum/abberant_organs/output/held_output as anything in outputs)
			var/datum/abberant_organs/output/new_output = new held_output
			handle_output_injection(new_output)

	RegisterSignal(parent, COMSIG_ORGAN_SPLICE, .proc/handle_node_injection)
	RegisterSignal(parent, COMSIG_ORGAN_INSERTED, .proc/on_inserted)


/datum/component/abberant_organ/proc/on_inserted(datum/source, mob/living/carbon/organ_reciever)
	SIGNAL_HANDLER

	organ_owner = organ_reciever
	for(var/datum/abberant_organs/output/listed_output as anything in outputs)
		listed_output.hosted_carbon = organ_owner

	for(var/datum/abberant_organs/input/listed_input as anything in inputs)
		listed_input.hosted_carbon = organ_owner

		switch(listed_input.input_type)
			if(INPUT_TYPE_REAGENT)
				RegisterSignal(organ_owner, COMSIG_CARBON_REAGENT_ADD, .proc/input_reagent_trigger)
			if(INPUT_TYPE_DAMAGE)
				RegisterSignal(organ_owner, COMSIG_LIVING_ADJUSTED, .proc/input_damage_trigger)
			else

//INPUT HANDLING

/datum/component/abberant_organ/proc/input_reagent_trigger(datum/source, datum/reagent/consumed_reagent, consumed_amount)
	SIGNAL_HANDLER

	for(var/datum/abberant_organs/input/listed_input as anything in inputs)
		listed_input.check_trigger_reagent(consumed_reagent, consumed_amount)

/datum/component/abberant_organ/proc/input_damage_trigger(datum/source, damage_type, damage_amount)
	SIGNAL_HANDLER

	for(var/datum/abberant_organs/input/listed_input as anything in inputs)
		listed_input.check_trigger_damage(damage_type, damage_amount)

/datum/component/abberant_organ/proc/handle_node_injection(datum/source, tier, purity, slot, datum/abberant_organs/injected_node)
	SIGNAL_HANDLER

	switch(slot)
		if(INPUT_NODE)
			var/datum/abberant_organs/input/injected_input = new injected_node
			if(injected_input.is_special)
				if((injected_input in inputs) || (injected_input in partnerless_inputs))
					trigger_failure(failed_type = injected_input, special_failure = TRUE)
					return
			injected_input.node_purity = min(purity + purity_modifer, 100)
			injected_input.tier = tier + tier_modifer
			injected_input.attached_organ = parent
			injected_input.setup()
			handle_input_injection(injected_input)

		if(OUTPUT_NODE)
			var/datum/abberant_organs/output/injected_output = new injected_node
			if(injected_output.is_special)
				if((injected_output in outputs) || (injected_output in partnerless_outputs))
					trigger_failure(failed_type = injected_output, special_failure = TRUE)
					return
			injected_output.node_purity = min(purity + purity_modifer, 100)
			injected_output.tier = tier + tier_modifer
			injected_output.attached_organ = parent
			injected_output.setup()
			handle_output_injection(injected_output)

/datum/component/abberant_organ/proc/trigger_failure(failed_type, special_failure = TRUE)
	return

/datum/component/abberant_organ/proc/handle_input_injection(datum/abberant_organs/input/injected_input)
	if(!partnerless_outputs.len)
		partnerless_inputs += injected_input
	else
		var/list/viable_outputs = list()
		for(var/datum/abberant_organs/output/listed_output as anything in partnerless_outputs)
			if((injected_input.tier - maximum_tier_difference) <= listed_output.tier <= (injected_input.tier + maximum_tier_difference))
				viable_outputs += listed_output

		if(!viable_outputs.len)
			return
		var/datum/abberant_organs/output/picked_output = pick(viable_outputs)

		//attaching the inputs and outputs
		injected_input.attached_output = picked_output
		picked_output.attached_input = injected_input

		//adding the input and output to the checked lists
		inputs += injected_input
		partnerless_outputs -= picked_output
		outputs += picked_output

/datum/component/abberant_organ/proc/handle_output_injection(datum/abberant_organs/output/injected_output)
	if(!partnerless_inputs.len)
		partnerless_outputs += injected_output
	else
		var/list/viable_inputs = list()
		for(var/datum/abberant_organs/output/listed_input as anything in partnerless_inputs)
			if((injected_output.tier - maximum_tier_difference) <= listed_input.tier <= (injected_output.tier + maximum_tier_difference))
				viable_inputs += listed_input

		if(!viable_inputs.len)
			return
		var/datum/abberant_organs/input/picked_inputs = pick(viable_inputs)

		//attaching the inputs and outputs
		injected_output.attached_input = picked_inputs
		picked_inputs.attached_output = injected_output

		//adding the input and output to the checked lists
		outputs += injected_output
		partnerless_inputs -= picked_inputs
		inputs += picked_inputs
