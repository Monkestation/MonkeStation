#define STATIC_NUTRIENT_CAPACITY 10
/obj/machinery/hydroponics
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray"
	density = TRUE
	pixel_z = 8
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	circuit = /obj/item/circuitboard/machine/hydroponics
	use_power = NO_POWER_USE
	var/waterlevel = 100	//The amount of water in the tray (max 100)
	var/maxwater = 100		//The maximum amount of water in the tray
	///The maximum nutrient reagent container size of the tray.
	var/maxnutri = 20

	var/pestlevel = 0		//The amount of pests in the tray (max 10)
	var/weedlevel = 0		//The amount of weeds in the tray (max 10)
	var/yieldmod = 1		//Nutriment's effect on yield
	var/mutmod = 1			//Nutriment's effect on mutations
	var/toxic = 0			//Toxicity in the tray?
	var/age = 0				//Current age
	var/dead = 0			//Is it dead?
	var/plant_health		//Its health

	var/lastproduce = 0		//Last time it was harvested
	var/lastcycle = 0		//Used for timing of cycles.
	var/cycledelay = 200	//About 10 seconds / cycle
	var/harvest = 0			//Ready to harvest?

	var/obj/item/seeds/myseed = null	//The currently planted seed

	var/rating = 1
	var/unwrenchable = 1

	var/recent_bee_visit = FALSE //Have we been visited by a bee recently, so bees dont overpollinate one plant
	///The last user to add a reagent to the tray, mostly for logging purposes.
	var/datum/weakref/lastuser
	///precent of nutriment drained per process defaults to 10%
	var/nutriment_drain_precent = 10
	var/self_sustaining = FALSE //If the tray generates nutrients and water on its own

	var/obj/machinery/mother_tree/connected_tree

/obj/machinery/hydroponics/Initialize(mapload)
	create_reagents(maxnutri)
	reagents.add_reagent(/datum/reagent/plantnutriment/eznutriment, 10) //Half filled nutrient trays for dirt trays to have more to grow with in prison/lavaland.
	. = ..()

	for(var/obj/machinery/mother_tree/located_tree in range(5, src))
		connected_tree = located_tree
		connected_tree.attached_component.connected_trays += src
		return
/obj/machinery/hydroponics/constructable
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"

/obj/machinery/hydroponics/constructable/RefreshParts()
	. = ..()
	var/tmp_capacity = 0
	for (var/obj/item/stock_parts/matter_bin/M in component_parts)
		tmp_capacity += M.rating
	for (var/obj/item/stock_parts/manipulator/M in component_parts)
		rating = M.rating
	maxwater = tmp_capacity * 50 // Up to 300
	maxnutri = tmp_capacity * 5 + STATIC_NUTRIENT_CAPACITY // Up to 30
	reagents.maximum_volume = maxnutri
	nutriment_drain_precent = 10/rating

/obj/machinery/hydroponics/constructable/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Tray efficiency at <b>[rating*100]%</b>.</span>"


/obj/machinery/hydroponics/Destroy()
	if(myseed)
		qdel(myseed)
		myseed = null
	return ..()

/obj/machinery/hydroponics/constructable/attackby(obj/item/I, mob/user, params)
	if (user.a_intent != INTENT_HARM)
		// handle opening the panel
		if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
			return
		else if(default_deconstruction_crowbar(I))
			return

	return ..()


/obj/machinery/hydroponics/bullet_act(obj/item/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(!myseed)
		return ..()
	if(istype(Proj , /obj/item/projectile/energy/floramut))
		mutate()
	else if(istype(Proj , /obj/item/projectile/energy/florayield))
		return myseed.bullet_act(Proj)
	else
		return ..()

/obj/machinery/hydroponics/process(delta_time)
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time

	if(myseed && (myseed.loc != src))
		myseed.forceMove(src)

	if(world.time > (lastcycle + cycledelay) && waterlevel > 10 && reagents.total_volume > 2 && pestlevel < 10 && weedlevel < 10)
		lastcycle = world.time
		if(myseed && !dead)
			// Advance age
			age++
			needs_update = 1


//Nutrients//////////////////////////////////////////////////////////////
			apply_chemicals(lastuser?.resolve())
			// Nutrients deplete slowly
			adjust_plant_nutriments(reagents.total_volume * (nutriment_drain_precent * 0.01))

//Photosynthesis/////////////////////////////////////////////////////////
			// Lack of light hurts non-mushrooms
			if(isturf(loc))
				var/turf/currentTurf = loc
				var/lightAmt = currentTurf.get_lumcount()
				if(myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
					if(lightAmt < 0.2)
						adjust_plant_health(-0.4 / rating)
				else // Non-mushroom
					if(lightAmt < 0.4)
						adjust_plant_health(-0.8 / rating)

//Water//////////////////////////////////////////////////////////////////
			// Drink random amount of water
			adjust_waterlevel(-rand(1,6) / rating)

			// If the plant is dry, it loses health pretty fast, unless mushroom
			if(waterlevel <= 10 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
				adjust_plant_health(-rand(0, 0.4) / rating)
				if(waterlevel <= 0)
					adjust_plant_health(-rand(0, 0.8) / rating)

			// Sufficient water level and nutrient level = plant healthy but also spawns weeds
			else if(waterlevel > 10 && reagents.total_volume > 0)
				adjust_plant_health(rand(1,2) / rating)
				if(myseed && prob(myseed.weed_chance))
					adjust_weedlevel(myseed.weed_rate)
				else if(prob(5))  //5 percent chance the weed population will increase
					adjust_weedlevel(1 / rating)

//Toxins/////////////////////////////////////////////////////////////////

			// Too much toxins cause harm, but when the plant drinks the contaiminated water, the toxins disappear slowly
			if(toxic >= 40 && toxic < 80)
				adjust_plant_health(-1 / rating)
				adjust_toxic(-rand(1,10) / rating)
			else if(toxic >= 80) // I don't think it ever gets here tbh unless above is commented out
				adjust_plant_health(-3)
				adjust_toxic(-rand(1,10) / rating)

//Pests & Weeds//////////////////////////////////////////////////////////

			if(pestlevel >= 8)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					adjust_plant_health(-0.8 / rating)

				else
					adjust_plant_health(2 / rating)
					adjust_pestlevel(-1 / rating)

			else if(pestlevel >= 4)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					adjust_plant_health(-0.4 / rating)

				else
					adjust_plant_health(1 / rating)
					if(prob(50))
						adjust_pestlevel(-1 / rating)

			else if(pestlevel < 4 && myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
				adjust_plant_health(-0.8 / rating)
				if(prob(5))
					adjust_pestlevel(-1 / rating)

			// If it's a weed, it doesn't stunt the growth
			if(weedlevel >= 5 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
				adjust_plant_health(-0.4 / rating)

//This is the part with pollination
			pollinate()
//Health & Age///////////////////////////////////////////////////////////

			// Plant dies if plant_health <= 0
			if(plant_health <= 0)
				plantdies()
				adjust_weedlevel(1 / rating) // Weeds flourish

			// If the plant is too old, lose health fast
			if(age > myseed.lifespan)
				adjust_plant_health(-rand(1,5) / rating)

			// Harvest code
			if(myseed.harvest_age > age * (1 + myseed.production * 0.044) && (myseed.harvest_age) > (age + lastproduce) * (1 + myseed.production * 0.044) && (!harvest && !dead))
				nutrimentMutation()
				if(myseed && myseed.yield != -1) // Unharvestable shouldn't be harvested
					if(connected_tree)
						SEND_SIGNAL(connected_tree, COMSIG_BOTANY_FINAL_GROWTH, src)
					harvest = 1
					lastproduce = age
				else
					lastproduce = age
			if(prob(5))  // On each tick, there's a 5 percent chance the pest population will increase
				adjust_pestlevel(1 / rating)
		else
			if(waterlevel > 10 && reagents.total_volume > 0 && prob(10))  // If there's no plant, the percentage chance is 10%
				adjust_weedlevel(1 / rating)

		// Weeeeeeeeeeeeeeedddssss
		if(weedlevel >= 10 && prob(50)) // At this point the plant is kind of fucked. Weeds can overtake the plant spot.
			weedinvasion() // Weed invasion into empty tray
			needs_update = 1
		if (needs_update)
			update_icon()

		if(myseed && prob(5 * (11-myseed.production)))
			for(var/g in myseed.genes)
				if(istype(g, /datum/plant_gene/trait))
					var/datum/plant_gene/trait/selectedtrait = g
					selectedtrait.on_grow(src)
	return

/obj/machinery/hydroponics/proc/nutrimentMutation()
	if (mutmod == 0)
		return
	if (mutmod == 1)
		if(prob(80))		//80%
			mutate()
		else if(prob(75))	//15%
			hardmutate()
		return
	if (mutmod == 2)
		if(prob(50))		//50%
			mutate()
		else if(prob(50))	//25%
			hardmutate()
		else if(prob(50))	//12.5%
			mutatespecie()
		return
	return

/obj/machinery/hydroponics/update_icon()
	//Refreshes the icon and sets the luminosity
	cut_overlays()

	if(self_sustaining)
		if(istype(src, /obj/machinery/hydroponics/soil))
			add_atom_colour(rgb(255, 175, 0), FIXED_COLOUR_PRIORITY)
		else
			add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "gaia_blessing"))
		set_light(3)

	if(myseed)
		update_icon_plant()
		update_icon_lights()

	if(!self_sustaining)
		if(myseed && myseed.get_gene(/datum/plant_gene/trait/glow))
			var/datum/plant_gene/trait/glow/G = myseed.get_gene(/datum/plant_gene/trait/glow)
			set_light(G.glow_range(myseed), G.glow_power(myseed), G.glow_color)
		else
			set_light(0)
	update_name()
	return

/obj/machinery/hydroponics/proc/update_icon_plant()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(dead)
		plant_overlay.icon_state = myseed.icon_dead
	else if(harvest)
		if(!myseed.icon_harvest)
			plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
		else
			plant_overlay.icon_state = myseed.icon_harvest
	else
		var/t_growthstate = clamp(round((age / myseed.maturation) * myseed.growthstages), 1, myseed.growthstages)
		plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	add_overlay(plant_overlay)

/obj/machinery/hydroponics/proc/update_icon_lights()
	if(waterlevel <= 10)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowwater3"))
	if(reagents.total_volume <= 2)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lownutri3"))
	if(plant_health <= (myseed.endurance / 2))
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowhealth3"))
	if(weedlevel >= 5 || pestlevel >= 5 || toxic >= 40)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_alert3"))
	if(harvest)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_harvest3"))


/obj/machinery/hydroponics/examine(user)
	. = ..()
	if(myseed)
		. += "<span class='info'>It has <span class='name'>[myseed.plantname]</span> planted.</span>"
		if (dead)
			. += "<span class='warning'>It's dead!</span>"
		else if (harvest)
			. += "<span class='info'>It's ready to harvest.</span>"
		else if (plant_health <= (myseed.endurance / 2))
			. += "<span class='warning'>It looks unhealthy.</span>"
	else
		. += "<span class='info'>It's empty.</span>"

	if(!self_sustaining)
		. += "<span class='info'>Water: [waterlevel]/[maxwater].</span>\n"+\
		"<span class='info'>Nutrient: [reagents.total_volume]/[maxnutri].</span>"
	else
		. += "<span class='info'>It doesn't require any water or nutrients.</span>"

	if(weedlevel >= 5)
		to_chat(user, "<span class='warning'>It's filled with weeds!</span>")
	if(pestlevel >= 5)
		to_chat(user, "<span class='warning'>It's filled with tiny worms!</span>")
	to_chat(user, "" )


/obj/machinery/hydroponics/proc/weedinvasion() // If a weed growth is sufficient, this happens.
	dead = FALSE
	switch(rand(1,18))		// randomly pick predominative weed
		if(16 to 18)
			myseed = new /obj/item/seeds/reishi(src)
		if(14 to 15)
			myseed = new /obj/item/seeds/nettle(src)
		if(12 to 13)
			myseed = new /obj/item/seeds/harebell(src)
		if(10 to 11)
			myseed = new /obj/item/seeds/amanita(src)
		if(8 to 9)
			myseed = new /obj/item/seeds/chanter(src)
		if(6 to 7)
			myseed = new /obj/item/seeds/tower(src)
		if(4 to 5)
			myseed = new /obj/item/seeds/plump(src)
		else
			myseed = new /obj/item/seeds/starthistle(src)
	age = 1
	lastproduce = 1
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0 // Reset
	pestlevel = 0 // Reset
	update_icon()
	visible_message("<span class='warning'>The empty tray is overtaken by some [myseed.plantname]!</span>")


/obj/machinery/hydroponics/proc/plantdies() // OH NOES!!!!! I put this all in one function to make things easier
	plant_health = 0
	harvest = 0
	pestlevel = 0 // Pests die
	lastproduce = 0
	if(!dead)
		update_icon()
		dead = 1

/**
 * Plant Cross-Pollination.
 * Checks all plants in the tray's oview range, then averages out the seed's potency, instability, and yield values.
 * If the seed's instability is >= 20, the seed donates one of it's reagents to that nearby plant.
 * * Range - The Oview range of trays to which to look for plants to donate reagents.
 */
/obj/machinery/hydroponics/proc/pollinate(range = 1)
	for(var/obj/machinery/hydroponics/T in oview(src, range))
		//Here is where we check for window blocking.
		if(!Adjacent(T) && range <= 1)
			continue
		if(T.myseed && !T.dead)
			T.myseed.blooming_stage++
			T.myseed.set_potency(round((T.myseed.potency+(1/10)*(myseed.potency-T.myseed.potency))))
			T.myseed.set_yield(round((T.myseed.yield+(1/2)*(myseed.yield-T.myseed.yield))))
			if(myseed.blooming_stage >= 5 && prob(70) && length(T.myseed.reagents_add))
				var/list/datum/plant_gene/reagent/possible_reagents = list()
				for(var/datum/plant_gene/reagent/reag in T.myseed.genes)
					possible_reagents += reag
				var/datum/plant_gene/reagent/reagent_gene = pick(possible_reagents) //Let this serve as a lession to delete your WIP comments before merge.
				if(reagent_gene.can_add(myseed))
					if(!reagent_gene.try_upgrade_gene(myseed))
						myseed.genes += reagent_gene.Copy()
					myseed.reagents_from_genes()
					myseed.blooming_stage = 0
					continue


/obj/machinery/hydroponics/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(IS_EDIBLE(O) || is_reagent_container(O))  // Syringe stuff (and other reagent containers now too)
		var/obj/item/reagent_containers/reagent_source = O

		if(!reagent_source.reagents.total_volume)
			to_chat(user, span_warning("[reagent_source] is empty!"))
			return 1

		if(reagents.total_volume >= reagents.maximum_volume && !reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
			to_chat(user, span_notice("[src] is full."))
			return

		var/list/trays = list(src)//makes the list just this in cases of syringes and compost etc
		var/target = myseed ? myseed.plantname : src
		var/visi_msg = ""
		var/transfer_amount

		if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
			visi_msg="[user] composts [reagent_source], spreading it through [target]"
			transfer_amount = reagent_source.reagents.total_volume
			SEND_SIGNAL(reagent_source, COMSIG_ITEM_ON_COMPOSTED, user)
		else
			transfer_amount = reagent_source.amount_per_transfer_from_this
			if(istype(reagent_source, /obj/item/reagent_containers/syringe/))
				var/obj/item/reagent_containers/syringe/syr = reagent_source
				visi_msg="[user] injects [target] with [syr]"
			// Beakers, bottles, buckets, etc.
			if(reagent_source.is_drainable())
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		if(visi_msg)
			visible_message("<span class='notice'>[visi_msg].</span>")

		for(var/obj/machinery/hydroponics/H in trays)
		//cause I don't want to feel like im juggling 15 tamagotchis and I can get to my real work of ripping flooring apart in hopes of validating my life choices of becoming a space-gardener
			//This was originally in apply_chemicals, but due to apply_chemicals only holding nutrients, we handle it here now.
			if(reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
				var/water_amt = reagent_source.reagents.get_reagent_amount(/datum/reagent/water) * transfer_amount / reagent_source.reagents.total_volume
				var/water_amt_adjusted = H.adjust_waterlevel(round(water_amt))
				reagent_source.reagents.remove_reagent(/datum/reagent/water, water_amt_adjusted)
				for(var/datum/reagent/not_water_reagent as anything in reagent_source.reagents.reagent_list)
					if(istype(not_water_reagent,/datum/reagent/water))
						continue
					var/transfer_me_to_tray = reagent_source.reagents.get_reagent_amount(not_water_reagent.type) * transfer_amount / reagent_source.reagents.total_volume
					reagent_source.reagents.trans_id_to(H.reagents, not_water_reagent.type, transfer_me_to_tray)
			else
				reagent_source.reagents.trans_to(H.reagents, transfer_amount, transfered_by = user)
			lastuser = WEAKREF(user)
			if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
				qdel(reagent_source)
				H.update_appearance()
				return 1
			H.update_appearance()
		if(reagent_source) // If the source wasn't composted and destroyed
			reagent_source.update_appearance()
		return 1

	else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		if(!myseed)
			if(istype(O, /obj/item/seeds/kudzu))
				investigate_log("had Kudzu planted in it by [key_name(user)] at [AREACOORD(src)]","kudzu")
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, "<span class='notice'>You plant [O].</span>")
			dead = 0
			myseed = O
			age = 1
			lastproduce = 1
			plant_health = myseed.endurance
			lastcycle = world.time
			update_icon()
		else
			to_chat(user, "<span class='warning'>[src] already has seeds in it!</span>")

	else if(istype(O, /obj/item/plant_analyzer))
		var/list/combined_msg = list()
		if(myseed)
			combined_msg += "*** <B>[myseed.plantname]</B> ***"
			combined_msg += "- Plant Age: <span class='notice'>[age]</span>"
			var/list/text_string = myseed.get_analyzer_text()
			if(text_string)
				combined_msg += "[text_string]"
		else
			combined_msg += "<B>No plant found.</B>"
		combined_msg += "- Weed level: <span class='notice'>[weedlevel] / 10</span>"
		combined_msg += "- Pest level: <span class='notice'>[pestlevel] / 10</span>"
		combined_msg += "- Toxicity level: <span class='notice'>[toxic] / 100</span>"
		combined_msg += "- Water level: <span class='notice'>[waterlevel] / [maxwater]</span>"
		combined_msg += "- Nutrition level: <span class='notice'>[reagents.total_volume] / [maxnutri]</span>"
		combined_msg += ""

		to_chat(user, examine_block(combined_msg.Join("\n")))
	else if(istype(O, /obj/item/cultivator))
		if(weedlevel > 0)
			user.visible_message("[user] uproots the weeds.", "<span class='notice'>You remove the weeds from [src].</span>")
			weedlevel = 0
			update_icon()
		else
			to_chat(user, "<span class='warning'>This plot is completely devoid of weeds! It doesn't need uprooting.</span>")

	else if(istype(O, /obj/item/storage/bag/plants))
		harvest_plant(user)
		for(var/obj/item/food/grown/G in locate(user.x,user.y,user.z))
			SEND_SIGNAL(O, COMSIG_TRY_STORAGE_INSERT, G, user, TRUE)

	else if(default_unfasten_wrench(user, O))
		if(!anchored)
			connected_tree = null
		else
			connected_tree = locate() in range(5)
		return

	else if(istype(O, /obj/item/shovel/spade))
		if(!myseed && !weedlevel)
			to_chat(user, "<span class='warning'>[src] doesn't have any plants or weeds!</span>")
			return
		user.visible_message("<span class='notice'>[user] starts digging out [src]'s plants...</span>",
			"<span class='notice'>You start digging out [src]'s plants...</span>")
		if(O.use_tool(src, user, 50, volume=50) || (!myseed && !weedlevel))
			user.visible_message("<span class='notice'>[user] digs out the plants in [src]!</span>", "<span class='notice'>You dig out all of [src]'s plants!</span>")
			if(myseed) //Could be that they're just using it as a de-weeder
				age = 0
				plant_health = 0
				lastproduce = 0
				if(harvest)
					harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
				qdel(myseed)
				myseed = null
			weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
			update_icon()

	else
		return ..()

/obj/machinery/hydroponics/can_be_unfasten_wrench(mob/user, silent)
	if (!unwrenchable)  // case also covered by NODECONSTRUCT checks in default_unfasten_wrench
		return CANT_UNFASTEN
	return ..()

/obj/machinery/hydroponics/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(issilicon(user)) //How does AI know what plant is?
		return
	harvest_plant(user)

/obj/machinery/hydroponics/proc/harvest_plant(mob/user)
	if(harvest)
		if(HAS_TRAIT(user, FOOD_JOB_BOTANIST))
			var/random_increase = rand(1, 20) * 0.01
			if(prob(50))
				myseed.adjust_potency(round(myseed.potency *random_increase, 1))
			if(prob(20))
				myseed.adjust_yield(round(myseed.yield * random_increase, 1))
			if(prob(35))
				myseed.adjust_lifespan(round(myseed.lifespan * random_increase, 1))
			if(prob(40))
				myseed.adjust_endurance(round(myseed.endurance * random_increase, 1))

		return myseed.harvest(user)

	else if(dead)
		dead = 0
		to_chat(user, "<span class='notice'>You remove the dead plant from [src].</span>")
		qdel(myseed)
		myseed = null
		update_icon()
	else
		if(user)
			examine(user)

/obj/machinery/hydroponics/proc/update_tray(mob/user)
	harvest = 0
	lastproduce = age
	if(istype(myseed, /obj/item/seeds/replicapod))
		to_chat(user, "<span class='notice'>You harvest from the [myseed.plantname].</span>")
	else if(myseed.getYield() <= 0)
		to_chat(user, "<span class='warning'>You fail to harvest anything useful!</span>")
	else
		to_chat(user, "<span class='notice'>You harvest [myseed.getYield()] items from the [myseed.plantname].</span>")
	if(!myseed.get_gene(/datum/plant_gene/trait/repeated_harvest))
		qdel(myseed)
		myseed = null
		dead = 0
		age = 0
		lastproduce = 0
	update_icon()

/obj/machinery/hydroponics/proc/spawnplant() // why would you put strange reagent in a hydro tray you monster I bet you also feed them blood
	var/list/livingplants = list(/mob/living/simple_animal/hostile/tree, /mob/living/simple_animal/hostile/killertomato)
	var/chosen = pick(livingplants)
	var/mob/living/simple_animal/hostile/C = new chosen
	C.faction = list("plants")

/obj/machinery/hydroponics/proc/become_self_sufficient() // Ambrosia Gaia effect
	visible_message("<span class='boldnotice'>[src] begins to glow with a beautiful light!</span>")
	self_sustaining = TRUE
	update_icon()

/obj/machinery/hydroponics/update_name()
	if(renamedByPlayer)
		return
	if(myseed)
		name = "[initial(name)] ([myseed.plantname])"
	else
		name = initial(name)
	return ..()

///////////////////////////////////////////////////////////////////////////////
/obj/machinery/hydroponics/soil //Not actually hydroponics at all! Honk!
	name = "soil"
	desc = "A patch of dirt."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	circuit = null
	density = FALSE
	use_power = NO_POWER_USE
	flags_1 = NODECONSTRUCT_1
	unwrenchable = FALSE

/obj/machinery/hydroponics/soil/update_icon_lights()
	return // Has no lights

/obj/machinery/hydroponics/soil/attackby(obj/item/O, mob/user, params)
	if(O.tool_behaviour == TOOL_SHOVEL && !istype(O, /obj/item/shovel/spade)) //Doesn't include spades because of uprooting plants
		to_chat(user, "<span class='notice'>You clear up [src]!</span>")
		qdel(src)
	else
		return ..()
