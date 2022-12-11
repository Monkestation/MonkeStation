/datum/component/organ_gene
	///list of all nodes that is being held by the component aswell as base extraction chance.
	var/list/held_nodes = list()

	///the maximum purity that can be extracted from this component
	var/max_purity
	///the minimum purity that can be extracted from this component
	var/min_purity

	///the max tier that can be extracted from this component
	var/max_tier
	///the minimum tier that can be extracted from this component
	var/min_tier

	///cooldown of scrambling the contained nodes
	var/scramble_cooldown

	///the cooldown tied to scrambling the component
	COOLDOWN_DECLARE(scramble)

	///the base extraction chance everything gets
	var/base_extraction_chance

	///temporary value of gained goop
	var/gained_goop = 0

/datum/component/organ_gene/Initialize(list/held_nodes,
									   max_purity = 60,
									   min_purity = 30,
									   max_tier = 4,
									   min_tier = 1,
									   scramble_cooldown = 60 SECONDS,
									   base_extraction_chance = 20)
	. = ..()

	src.max_purity = max_purity
	src.min_purity = min_purity
	src.max_tier = max_tier
	src.min_tier = min_tier
	src.scramble_cooldown = scramble_cooldown

	for(var/datum/abberant_organs/listed_node as anything in held_nodes)
		var/datum/abberant_organs/created_node = new listed_node
		configure_node(created_node)

/datum/component/organ_gene/proc/configure_node(datum/abberant_organs/node)
	var/node_purity = rand(min_purity, max_purity)
	var/tier = rand(min_tier, max_tier)
	node.set_values(node_purity, tier)

	var/extraction_chance = node.is_special ? 100 : base_extraction_chance + (tier * 10)
	held_nodes[node] += extraction_chance

/datum/component/organ_gene/proc/extract()
	var/list/successfully_extracted = list()
	var/list/unsucessfully_extracted = list()

	for(var/datum/abberant_organs/listed_node as anything in held_nodes)
		if(prob(held_nodes[listed_node]))
			successfully_extracted += listed_node
			held_nodes -= listed_node
		else
			unsucessfully_extracted  += listed_node
			held_nodes -= listed_node

	process_fail(unsucessfully_extracted)
	return successfully_extracted

/datum/component/organ_gene/proc/process_fail(list/given_list)
	var/total_goop
	for(var/datum/abberant_organs/listed_node as anything in given_list)
		total_goop += round(listed_node.node_purity * 0.25)
		total_goop *= listed_node.tier
	gained_goop = total_goop

/datum/component/organ_gene/proc/scramble()
	if(!COOLDOWN_FINISHED(src, scramble))
		return

	var/old_number_of_nodes = held_nodes.len
	var/variance = rand(-2, 2)
	var/number_of_generated_nodes = old_number_of_nodes + variance

	var/purity_variance = rand(-20,20)
	var/tier_variance = rand(-1,1)

	max_purity = min(max(max_purity + purity_variance, 10),100)
	min_purity = min(max(min_purity + purity_variance, 10),100)

	max_tier = max(max_tier + tier_variance, 1)
	min_tier = max(min_tier + tier_variance, 1)

	var/list/new_nodes = list()
	var/total_pulls = 0
	for(var/i = 1 to number_of_generated_nodes)
		if(prob(1))
			new_nodes += pull_special_node()
		else
			total_pulls++
	new_nodes += pull_from_tiers_weighted(total_pulls)

	for(var/datum/abberant_organs/listed_node as anything in new_nodes)
		var/datum/abberant_organs/created_node = new listed_node
		configure_node(created_node)

