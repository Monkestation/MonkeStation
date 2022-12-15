/obj/item/seeds/proc/return_all_data()
	var/obj/grown_food = product
	var/base64 = icon2base64(icon(initial(grown_food.icon), initial(grown_food.icon_state)))
	return list(
		"image" = base64,
		"name" = name,
		"desc" = desc,
		"potency" = potency,
		"weed_rate" = weed_rate,
		"weed_chance" = weed_chance,
		"yield" = yield,
		"ref" = REF(src),
		"production_speed" = production,
		"maturation_speed" = maturation,
		"endurance" = endurance,
		"lifespan" = lifespan,
	)

/obj/item/seeds/spliced
	name = "Spliced Seeds"
	desc = "A hybrid seed consisting of multiple plants."

	icon_state = "seed-x"

	///list of all produce types, when harvest will randomly cycle these
	var/list/produce_list = list()
	///list of all viable special mutations
	var/list/special_mutations = list()

/obj/item/seeds/spliced/on_planted()
	special_mutations = return_viable_mutations()

/obj/item/seeds/spliced/harvest(mob/user)
	var/obj/machinery/hydroponics/parent = loc //for ease of access
	var/t_amount = 0
	var/list/result = list()
	var/output_loc = parent.Adjacent(user) ? user.loc : parent.loc //needed for TK
	var/product_name
	var/yield_amount = getYield()
	if(yield_amount >= 10)
		yield_amount = 10 + log(1.4) * (getYield() - 1)
	var/obj/item/seeds/generated_seed new Copy_drop(output_loc) /// we want atleast 1 seed
	while(t_amount < yield_amount)
		var/picked_object = pick(produce_list)
		if(prob(30))
			var/obj/item/seeds/seed_prod
			if(prob(10) && special_mutations.len)
				var/datum/hydroponics/plant_mutation/spliced_mutation/picked_mutation =  pick(special_mutations)
				var/obj/item/seeds/created_seed = picked_mutation.created_seed
				seed_prod = new created_seed(output_loc)
			else
				seed_prod = src.Copy_drop(output_loc)
			result.Add(seed_prod) // User gets a consumable
			t_amount++
		else
			var/obj/item/food/grown/t_prod
			if(prob(10) && special_mutations.len)
				var/datum/hydroponics/plant_mutation/spliced_mutation/picked_mutation =  pick(special_mutations)
				var/obj/item/produced_item = picked_mutation.created_product
				t_prod = new produced_item(output_loc)
			else
				t_prod = new picked_object(output_loc, src)
			result.Add(t_prod) // User gets a consumable
			if(!t_prod)
				return
			t_amount++
			product_name = t_prod.seed.plantname
	if(getYield() >= 1)
		SSblackbox.record_feedback("tally", "food_harvested", getYield(), product_name)
	parent.update_tray(user)

	return result

/obj/item/seeds/proc/Copy_drop(output_loc)
	var/obj/item/seeds/S = new type(output_loc, 1)
	// Copy all the stats
	S.lifespan = lifespan
	S.endurance = endurance
	S.maturation = maturation
	S.production = production
	S.yield = yield
	S.potency = potency
	S.weed_rate = weed_rate
	S.weed_chance = weed_chance
	S.name = name
	S.plantname = plantname
	S.desc = desc
	S.plantdesc = plantdesc
	S.genes = list()
	for(var/g in genes)
		var/datum/plant_gene/G = g
		S.genes += G.Copy()
	S.reagents_add = reagents_add.Copy() // Faster than grabbing the list from genes.

	S.harvest_age = harvest_age
	S.species = species
	S.icon_grow = icon_grow
	S.icon_harvest = icon_harvest
	S.icon_dead = icon_dead
	S.growthstages = growthstages
	S.growing_icon = growing_icon

	if(istype(src, /obj/item/seeds/spliced))
		var/obj/item/seeds/spliced/spliced_seed = src
		var/obj/item/seeds/spliced/new_spliced_seed = S
		new_spliced_seed.produce_list = spliced_seed.produce_list

/obj/item/seeds/proc/on_planted()
	return
