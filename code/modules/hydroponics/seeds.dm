// ********************************************************
// Here's all the seeds (plants) that can be used in hydro
// ********************************************************

/obj/item/seeds
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed"				// Unknown plant seed - these shouldn't exist in-game.
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/plantname = "Plants"		// Name of plant when planted.
	var/plantdesc
	var/product						// A type path. The thing that is created when the plant is harvested.
	var/species = ""				// Used to update icons. Should match the name in the sprites unless all icon_* are overridden.

	var/growing_icon = 'icons/obj/hydroponics/growing.dmi' //the file that stores the sprites of the growing plant from this seed.
	var/icon_grow					// Used to override grow icon (default is "[species]-grow"). You can use one grow icon for multiple closely related plants with it.
	var/icon_dead					// Used to override dead icon (default is "[species]-dead"). You can use one dead icon for multiple closely related plants with it.
	var/icon_harvest				// Used to override harvest icon (default is "[species]-harvest"). If null, plant will use [icon_grow][growthstages].

	var/lifespan = 25				// How long before the plant begins to take damage from age.
	var/endurance = 15				// Amount of health the plant has.
	var/maturation = 6				// Used to determine which sprite to switch to when growing.
	var/production = 6				// Changes the amount of time needed for a plant to become harvestable.
	var/yield = 3					// Amount of growns created per harvest. If is -1, the plant/shroom/weed is never meant to be harvested.
	var/max_yield = INFINITY		// The absolute maximum yield a plant can have.
	var/potency = 10				// The 'power' of a plant. Generally effects the amount of reagent in a plant, also used in other ways.
	var/growthstages = 6			// Amount of growth sprites the plant has.
	var/rarity = 0					// How rare the plant is. Used for giving points to cargo when shipping off to CentCom.
	// The type of plants that this plant can mutate into. LEGACY CONTENT - NEW OBJECTS SHOULD USE POSSIBLE_MUTATIONS see modular hydroponics folder mutations file for examples.
	var/list/mutatelist = list()
	// Plant genes are stored here, see plant_genes.dm for more info.
	var/list/genes = list()
	/// A list of reagents to add to product.
	var/list/reagents_add = list()
	// Format: "reagent_id" = potency multiplier
	// Stronger reagents must always come first to avoid being displaced by weaker ones.
	// Total amount of any reagent in plant is calculated by formula: 1 + round(potency * multiplier)

	var/weed_rate = 1 //If the chance below passes, then this many weeds sprout during growth
	var/weed_chance = 5 //Percentage chance per tray update to grow weeds
	var/blooming_stage = 0
	///the age at which the plant should be harvested at
	var/harvest_age = 120
	///list of all mutations that are generated via stats
	var/list/possible_mutations = list()
	///list of all traits currently being trained
	var/list/traits_in_progress = list()
	///list of infusion_mutations checked on infusion for requirements and moved to possible_mutations
	var/list/infusion_mutations = list()
	///infusion damage
	var/infusion_damage = 0

/obj/item/seeds/Initialize(mapload, nogenes = 0)
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

	if(!icon_grow)
		icon_grow = "[species]-grow"

	if(!icon_dead)
		icon_dead = "[species]-dead"

	if(!icon_harvest && !get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism) && yield != -1)
		icon_harvest = "[species]-harvest"

	var/list/generated_mutations = list()
	for(var/datum/hydroponics/plant_mutation/listed_item as anything in possible_mutations)
		var/datum/hydroponics/plant_mutation/created_list_item = new listed_item
		generated_mutations += created_list_item
	possible_mutations = generated_mutations

	var/list/generated_infusions = list()
	for(var/datum/hydroponics/plant_mutation/infusion/listed_item as anything in infusion_mutations)
		var/datum/hydroponics/plant_mutation/infusion/created_list_item = new listed_item
		generated_mutations += created_list_item
	infusion_mutations = generated_infusions

	if(!nogenes) // not used on Copy()
		genes += new /datum/plant_gene/core/lifespan(lifespan)
		genes += new /datum/plant_gene/core/endurance(endurance)
		genes += new /datum/plant_gene/core/weed_rate(weed_rate)
		genes += new /datum/plant_gene/core/weed_chance(weed_chance)
		if(yield != -1)
			genes += new /datum/plant_gene/core/yield(yield)
			genes += new /datum/plant_gene/core/production(production)
			genes += new /datum/plant_gene/core/maturation(maturation)
		if(potency != -1)
			genes += new /datum/plant_gene/core/potency(potency)

		for(var/p in genes)
			if(ispath(p))
				genes -= p
				genes += new p

		for(var/datum/plant_gene/held_gene in genes)
			held_gene.on_add(src)

		for(var/reag_id in reagents_add)
			genes += new /datum/plant_gene/reagent(reag_id, reagents_add[reag_id])
		reagents_from_genes() //quality coding

/obj/item/seeds/proc/Copy()
	var/obj/item/seeds/S = new type(null, 1)
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

	return S

/obj/item/seeds/proc/get_gene(typepath)
	return (locate(typepath) in genes)

/obj/item/seeds/proc/reagents_from_genes()
	reagents_add = list()
	for(var/datum/plant_gene/reagent/R in genes)
		reagents_add[R.reagent_id] = R.rate

///This proc adds a mutability_flag to a gene
/obj/item/seeds/proc/set_mutability(typepath, mutability)
	var/datum/plant_gene/g = get_gene(typepath)
	if(g)
		g.mutability_flags |=  mutability

///This proc removes a mutability_flag from a gene
/obj/item/seeds/proc/unset_mutability(typepath, mutability)
	var/datum/plant_gene/g = get_gene(typepath)
	if(g)
		g.mutability_flags &=  ~mutability

/obj/item/seeds/proc/mutate(lifemut = 2, endmut = 5, productmut = 1, yieldmut = 2, potmut = 25, wrmut = 2, wcmut = 5, traitmut = 0)
	adjust_lifespan(rand(-lifemut,lifemut))
	adjust_endurance(rand(-endmut,endmut))
	adjust_production(rand(-productmut,productmut))
	adjust_yield(rand(-yieldmut,yieldmut))
	adjust_potency(rand(-potmut,potmut))
	adjust_weed_rate(rand(-wrmut, wrmut))
	adjust_weed_chance(rand(-wcmut, wcmut))
	if(prob(traitmut))
		add_random_traits(1, 1)



/obj/item/seeds/bullet_act(obj/item/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(istype(Proj, /obj/item/projectile/energy/florayield))
		var/rating = 1
		if(istype(loc, /obj/machinery/hydroponics))
			var/obj/machinery/hydroponics/H = loc
			rating = H.rating

		if(yield == 0)//Oh god don't divide by zero you'll doom us all.
			adjust_yield(1 * rating)
		else if(prob(1/(yield * yield) * 100))//This formula gives you diminishing returns based on yield. 100% with 1 yield, decreasing to 25%, 11%, 6, 4, 2...
			adjust_yield(1 * rating)
	else
		return ..()


// Harvest procs
/obj/item/seeds/proc/getYield()
	var/return_yield = min(yield, max_yield)

	var/obj/machinery/hydroponics/parent = loc
	if(istype(loc, /obj/machinery/hydroponics))
		if(parent.yieldmod == 0)
			return_yield = min(return_yield, 1)//1 if above zero, 0 otherwise
		else
			return_yield *= (parent.yieldmod)

	return return_yield


/obj/item/seeds/proc/harvest(mob/user)
	var/obj/machinery/hydroponics/parent = loc //for ease of access
	var/t_amount = 0
	var/list/result = list()
	var/output_loc = parent.Adjacent(user) ? user.loc : parent.loc //needed for TK
	var/product_name
	var/yield_amount = getYield()
	if(yield_amount >= 10)
		yield_amount = 10 + log(1.4) * (getYield() - 1)
	while(t_amount < yield_amount)
		if(prob(30))
			var/obj/item/seeds/seed_prod
			if(prob(10) && has_viable_mutations())
				seed_prod = create_valid_mutation(output_loc, TRUE)
			else
				seed_prod = src.Copy_drop(output_loc)
			result.Add(seed_prod) // User gets a consumable
			t_amount++
		else
			var/obj/item/food/grown/t_prod
			if(prob(10) && has_viable_mutations())
				t_prod = create_valid_mutation(output_loc)
			else
				t_prod = new product(output_loc, src)
			if(parent.myseed.plantname != initial(parent.myseed.plantname))
				t_prod.name = parent.myseed.plantname
			if(parent.myseed.plantdesc)
				t_prod.desc = parent.myseed.plantdesc
			t_prod.seed.name = parent.myseed.name
			t_prod.seed.desc = parent.myseed.desc
			t_prod.seed.plantname = parent.myseed.plantname
			t_prod.seed.plantdesc = parent.myseed.plantdesc
			result.Add(t_prod) // User gets a consumable
			if(!t_prod)
				return
			t_amount++
			product_name = t_prod.seed.plantname
	if(getYield() >= 1)
		SSblackbox.record_feedback("tally", "food_harvested", getYield(), product_name)
	parent.update_tray(user)

	return result


/obj/item/seeds/proc/prepare_result(var/obj/item/T)
	if(!T.reagents)
		CRASH("[T] has no reagents.")
	var/reagent_max = 0
	for(var/rid in reagents_add)
		reagent_max += reagents_add[rid]
	if(IS_EDIBLE(T) || istype(T, /obj/item/grown))
		var/obj/item/food/grown/grown_edible = T
		for(var/rid in reagents_add)
			var/reagent_overflow_mod = reagents_add[rid]
			if(reagent_max > 1)
				reagent_overflow_mod = (reagents_add[rid]/ reagent_max)
			var/edible_vol = grown_edible.reagents ? grown_edible.reagents.maximum_volume : 0
			var/amount = max(1, round((edible_vol)*(potency/100) * reagent_overflow_mod, 1)) //the plant will always have at least 1u of each of the reagents in its reagent production traits
			var/list/data
			if(rid == /datum/reagent/blood) // Hack to make blood in plants always O-
				data = list("blood_type" = "O-")
			if(istype(grown_edible) && (rid == /datum/reagent/consumable/nutriment || rid == /datum/reagent/consumable/nutriment/vitamin))
				data = grown_edible.tastes // apple tastes of apple.
				//Handles the distillary trait, swaps nutriment and vitamins for that species brewable if it exists.
				if(get_gene(/datum/plant_gene/trait/brewing) && grown_edible.distill_reagent)
					T.reagents.add_reagent(grown_edible.distill_reagent, amount/2)
					continue

			T.reagents.add_reagent(rid, amount, data)

		//Handles the juicing trait, swaps nutriment and vitamins for that species various juices if they exist. Mutually exclusive with distilling.
		if(get_gene(/datum/plant_gene/trait/juicing) && grown_edible.juice_results)
			grown_edible.on_juice()
			grown_edible.reagents.add_reagent_list(grown_edible.juice_results)

		/// The number of nutriments we have inside of our plant, for use in our heating / cooling genes
		var/num_nutriment = T.reagents.get_reagent_amount(/datum/reagent/consumable/nutriment)

		// Heats up the plant's contents by 25 kelvin per 1 unit of nutriment. Mutually exclusive with cooling.
		if(get_gene(/datum/plant_gene/trait/chem_heating))
			T.visible_message(span_notice("[T] releases freezing air, consuming its nutriments to heat its contents."))
			T.reagents.remove_all_type(/datum/reagent/consumable/nutriment, num_nutriment, strict = TRUE)
			T.reagents.chem_temp = min(1000, (T.reagents.chem_temp + num_nutriment * 25))
			T.reagents.handle_reactions()
			playsound(T.loc, 'sound/effects/sizzle2.ogg', 5)
		// Cools down the plant's contents by 5 kelvin per 1 unit of nutriment. Mutually exclusive with heating.
		else if(get_gene(/datum/plant_gene/trait/chem_cooling))
			T.visible_message(span_notice("[T] releases a blast of hot air, consuming its nutriments to cool its contents."))
			T.reagents.remove_all_type(/datum/reagent/consumable/nutriment, num_nutriment, strict = TRUE)
			T.reagents.chem_temp = max(3, (T.reagents.chem_temp + num_nutriment * -5))
			T.reagents.handle_reactions()
			playsound(T.loc, 'sound/effects/space_wind.ogg', 50)


/// Setters procs ///
/obj/item/seeds/proc/adjust_yield(adjustamt)
	yield = yield + adjustamt
	if(yield <= 0 && get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
		yield = 1 // Mushrooms always have a minimum yield of 1.
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/yield)
	if(C)
		C.value = yield

/obj/item/seeds/proc/adjust_lifespan(adjustamt)
	lifespan = lifespan + adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/lifespan)
	if(C)
		C.value = lifespan

/obj/item/seeds/proc/adjust_endurance(adjustamt)
	endurance = endurance + adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/endurance)
	if(C)
		C.value = endurance

/obj/item/seeds/proc/adjust_production(adjustamt)
	production = production + adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/production)
	if(C)
		C.value = production

/obj/item/seeds/proc/adjust_maturation(adjustamt)
	maturation = maturation + adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/maturation)
	if(C)
		C.value = maturation

/obj/item/seeds/proc/adjust_potency(adjustamt)
	potency = potency + adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/potency)
	if(C)
		C.value = potency

/obj/item/seeds/proc/adjust_weed_rate(adjustamt)
	weed_rate = CLAMP(weed_rate + adjustamt, 0, 10)
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/weed_rate)
	if(C)
		C.value = weed_rate

/obj/item/seeds/proc/adjust_weed_chance(adjustamt)
	weed_chance = CLAMP(weed_chance + adjustamt, 0, 100)
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/weed_chance)
	if(C)
		C.value = weed_chance
//Directly setting stats

/obj/item/seeds/proc/set_yield(adjustamt)
	if(yield != -1) // Unharvestable shouldn't suddenly turn harvestable
		yield = CLAMP(adjustamt, 0, 10)

		if(yield <= 0 && get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
			yield = 1 // Mushrooms always have a minimum yield of 1.
		var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/yield)
		if(C)
			C.value = yield

/obj/item/seeds/proc/set_lifespan(adjustamt)
	lifespan = CLAMP(adjustamt, 10, 100)
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/lifespan)
	if(C)
		C.value = lifespan

/obj/item/seeds/proc/set_endurance(adjustamt)
	endurance = adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/endurance)
	if(C)
		C.value = endurance

/obj/item/seeds/proc/set_production(adjustamt)
	if(yield != -1)
		production = adjustamt
		var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/production)
		if(C)
			C.value = production

/obj/item/seeds/proc/set_maturation(adjustamt)
	if(yield != -1)
		maturation = adjustamt
		var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/maturation)
		if(C)
			C.value = maturation

/obj/item/seeds/proc/set_potency(adjustamt)
	if(potency != -1)
		potency = adjustamt
		var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/potency)
		if(C)
			C.value = potency

/obj/item/seeds/proc/set_weed_rate(adjustamt)
	weed_rate = adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/weed_rate)
	if(C)
		C.value = weed_rate

/obj/item/seeds/proc/set_weed_chance(adjustamt)
	weed_chance = adjustamt
	var/datum/plant_gene/core/C = get_gene(/datum/plant_gene/core/weed_chance)
	if(C)
		C.value = weed_chance


/obj/item/seeds/proc/get_analyzer_text()  //in case seeds have something special to tell to the analyzer
	var/text = ""
	if(!get_gene(/datum/plant_gene/trait/plant_type/weed_hardy) && !get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism) && !get_gene(/datum/plant_gene/trait/plant_type/alien_properties))
		text += "- Plant type: Normal plant\n"
	if(get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
		text += "- Plant type: Weed. Can grow in nutrient-poor soil.\n"
	if(get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
		text += "- Plant type: Mushroom. Can grow in dry soil.\n"
	if(get_gene(/datum/plant_gene/trait/plant_type/alien_properties))
		text += "- Plant type: <span class='warning'>UNKNOWN</span> \n"
	if(potency != -1)
		text += "- Potency: [potency]\n"
	if(yield != -1)
		text += "- Yield: [min(yield, max_yield)]\n"
	text += "- Maturation speed: [maturation]\n"
	if(yield != -1)
		text += "- Production speed: [production]\n"
	text += "- Endurance: [endurance]\n"
	text += "- Lifespan: [lifespan]\n"
	text += "- Weed Growth Rate: [weed_rate]\n"
	text += "- Weed Vulnerability: [weed_chance]\n"
	if(rarity)
		text += "- Species Discovery Value: [rarity]\n"
	var/all_traits = ""
	for(var/datum/plant_gene/trait/traits in genes)
		if(istype(traits, /datum/plant_gene/trait/plant_type))
			continue
		all_traits += " [traits.get_name()]"
	text += "- Plant Traits:[all_traits]\n"

	text += "*---------*"

	return text

/obj/item/seeds/proc/on_chem_reaction(datum/reagents/S)  //in case seeds have some special interaction with special chems
	return

/obj/item/seeds/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/plant_analyzer))
		to_chat(user, "<span class='info'>*---------*\n This is \a <span class='name'>[src]</span>.</span>")
		var/text = get_analyzer_text()
		if(text)
			to_chat(user, "<span class='notice'>[text]</span>")

		return

	if (istype(O, /obj/item/pen))
		var/penchoice = input(user, "What would you like to edit?") as null|anything in list("Plant Name","Plant Description","Seed Description")
		if(QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
			return

		if(penchoice == "Plant Name")
			var/input = stripped_input(user,"What do you want to name the plant?", default=plantname, max_length=MAX_NAME_LEN)
			if(QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
				return
			name = "pack of [input] seeds"
			plantname = input
			renamedByPlayer = TRUE

		if(penchoice == "Plant Description")
			var/input = stripped_input(user,"What do you want to change the description of \the plant to?", default=plantdesc, max_length=MAX_NAME_LEN)
			if(QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
				return
			plantdesc = input

		if(penchoice == "Seed Description")
			var/input = stripped_input(user,"What do you want to change the description of \the seeds to?", default=desc, max_length=MAX_NAME_LEN)
			if(QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
				return
			desc = input
	..() // Fallthrough to item/attackby() so that bags can pick seeds up







// Checks plants for broken tray icons. Use Advanced Proc Call to activate.
// Maybe some day it would be used as unit test.
/proc/check_plants_growth_stages_icons()
	var/list/states = icon_states('icons/obj/hydroponics/growing.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_fruits.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_flowers.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_mushrooms.dmi')
	states |= icon_states('icons/obj/hydroponics/growing_vegetables.dmi')
	var/list/paths = typesof(/obj/item/seeds) - /obj/item/seeds - typesof(/obj/item/seeds/sample)

	for(var/seedpath in paths)
		var/obj/item/seeds/seed = new seedpath

		for(var/i in 1 to seed.growthstages)
			if("[seed.icon_grow][i]" in states)
				continue
			to_chat(world, "[seed.name] ([seed.type]) lacks the [seed.icon_grow][i] icon!")

		if(!(seed.icon_dead in states))
			to_chat(world, "[seed.name] ([seed.type]) lacks the [seed.icon_dead] icon!")

		if(seed.icon_harvest) // mushrooms have no grown sprites, same for items with no product
			if(!(seed.icon_harvest in states))
				to_chat(world, "[seed.name] ([seed.type]) lacks the [seed.icon_harvest] icon!")

/obj/item/seeds/proc/randomize_stats()
	set_lifespan(rand(25, 60))
	set_endurance(rand(15, 35))
	set_production(rand(2, 10))
	set_yield(rand(1, 10))
	set_potency(rand(10, 35))
	set_weed_rate(rand(1, 10))
	set_weed_chance(rand(5, 100))
	maturation = rand(6, 12)

/obj/item/seeds/proc/add_random_reagents(lower = 0, upper = 2)
	var/amount_random_reagents = rand(lower, upper)
	for(var/i in 1 to amount_random_reagents)
		var/random_amount = rand(4, 15) * 0.01 // this must be multiplied by 0.01, otherwise, it will not properly associate
		var/datum/plant_gene/reagent/R = new(get_random_reagent_id(), random_amount)
		if(R.can_add(src))
			genes += R
		else
			qdel(R)
	reagents_from_genes()

/obj/item/seeds/proc/add_random_traits(lower = 0, upper = 2)
	var/amount_random_traits = rand(lower, upper)
	for(var/i in 1 to amount_random_traits)
		var/random_trait = pick((subtypesof(/datum/plant_gene/trait)-typesof(/datum/plant_gene/trait/plant_type)))
		var/datum/plant_gene/trait/T = new random_trait
		if(T.can_add(src))
			genes += T
		else
			qdel(T)

/obj/item/seeds/proc/add_random_plant_type(normal_plant_chance = 75)
	if(prob(normal_plant_chance))
		var/random_plant_type = pick(subtypesof(/datum/plant_gene/trait/plant_type))
		var/datum/plant_gene/trait/plant_type/P = new random_plant_type
		if(P.can_add(src))
			genes += P
		else
			qdel(P)
