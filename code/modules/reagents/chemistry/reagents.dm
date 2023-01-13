#define REM REAGENTS_EFFECT_MULTIPLIER

GLOBAL_LIST_INIT(name2reagent, build_name2reagent())

/proc/build_name2reagent()
	. = list()
	for (var/t in subtypesof(/datum/reagent))
		var/datum/reagent/R = t
		if (length(initial(R.name)))
			.[ckey(initial(R.name))] = t


//Various reagents
//Toxin & acid reagents
//Hydroponics stuff

/datum/reagent
	var/name = "Reagent"
	var/description = ""
	var/specific_heat = SPECIFIC_HEAT_DEFAULT		//J/(K*mol)
	var/taste_description = "metaphorical salt"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/glass_name = "glass of ...what?" // use for specialty drinks.
	var/glass_desc = "You can't really tell what this is."
	var/glass_icon_state = null // Otherwise just sets the icon to a normal glass with the mixture of the reagents in the glass.
	var/shot_glass_icon_state = null
	var/datum/reagents/holder = null
	var/reagent_state = LIQUID
	var/list/data
	var/current_cycle = 0
	var/volume = 0									//pretend this is moles
	var/color = "#000000" // rgb: 0, 0, 0
	var/can_synth = TRUE // can this reagent be synthesized? (for example: odysseus syringe gun)
	var/metabolization_rate = REAGENTS_METABOLISM //how fast the reagent is metabolized by the mob
	var/overrides_metab = 0
	var/overdose_threshold = 0
	var/random_unrestricted = TRUE
	var/process_flags = ORGANIC // What can process this? ORGANIC, SYNTHETIC, or ORGANIC | SYNTHETIC?. We'll assume by default that it affects organics.
	var/overdosed = 0 // You fucked up and this is now triggering its overdose effects, purge that shit quick.
	var/self_consuming = FALSE
	var/reagent_weight = 1 //affects how far it travels when sprayed
	var/metabolizing = FALSE
	var/list/addiction_types = null

	var/gas = null //do we have an associated gas? (expects a string, not a datum typepath!)
	var/condensating_point = T0C // anything below this temperature in terms of K will start having the gases rapidly condense
	var/condensation_amount = 1
	var/molarity = 5 // How many units per mole of this reagent. Technically this is INVERSE molarity, but hey.

	//MONKESTATION EDIT ADDITION
	///Whether it will evaporate if left untouched on a liquids simulated puddle
	var/evaporates = TRUE
	///How much fire power does the liquid have, for burning on simulated liquids. Not enough fire power/unit of entire mixture may result in no fire
	var/liquid_fire_power = 0
	///How fast does the liquid burn on simulated turfs, if it does
	var/liquid_fire_burnrate = 0
	///Whether a fire from this requires oxygen in the atmosphere
	var/fire_needs_oxygen = TRUE
	///The opacity of the chems used to determine the alpha of liquid turfs
	var/opacity = 175
	///The rate of evaporation in units per call
	var/evaporation_rate = 0.5
	///if this reagent should condense down into a liquid
	var/condenses_liquid = TRUE
	///does this reagent convert into a gas
	var/converts_to_gas = FALSE
	//MONKESTATION EDIT END
/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null

/datum/reagent/proc/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1, touch_protection = 0)
	if(!istype(M))
		return 0
	if(method == VAPOR) //smoke, foam, spray
		if(M.reagents)
			var/modifier = CLAMP((1 - touch_protection), 0, 1)
			var/amount = round(reac_volume*modifier, 0.1)
			if(amount >= 0.5)
				M.reagents.add_reagent(type, amount)
	return 1

/datum/reagent/proc/reaction_obj(obj/O, volume)
	return

/datum/reagent/proc/reaction_evaporation(turf/T, volume)
	if(converts_to_gas)
		var/temp = holder ? holder.chem_temp : T20C
		if(get_gas())
			T.atmos_spawn_air("[get_gas()]=[(volume/molarity) * 0.5];TEMP=[temp]") // each cycle produces half as much gas as the last

/datum/reagent/proc/reaction_turf(turf/T, volume, show_message, from_gas)
	return

/datum/reagent/proc/reaction_liquid(obj/O, volume)
	return

/datum/reagent/proc/on_mob_life(mob/living/carbon/M)
	current_cycle++
	holder.remove_reagent(type, metabolization_rate * M.metabolism_efficiency) //By default it slowly disappears.
	return

/datum/reagent/proc/on_transfer(atom/A, method=TOUCH, trans_volume) //Called after a reagent is transfered
	return

/datum/reagents/proc/react_single(datum/reagent/R, atom/A, method = TOUCH, volume_modifier = 1, show_message = TRUE)
	var/react_type
	if(isliving(A))
		react_type = "LIVING"
		if(method == INGEST)
			var/mob/living/L = A
			L.taste(src)
	else if(isturf(A))
		react_type = "TURF"
	else if(isobj(A))
		react_type = "OBJ"
	else
		return
	switch(react_type)
		if("LIVING")
			var/touch_protection = 0
			if(method == VAPOR)
				var/mob/living/L = A
				touch_protection = L.get_permeability_protection()
			R.reaction_mob(A, method, R.volume * volume_modifier, show_message, touch_protection)
		if("TURF")
			R.reaction_turf(A, R.volume * volume_modifier, show_message)
		if("OBJ")
			R.reaction_obj(A, R.volume * volume_modifier, show_message)

// Called when this reagent is first added to a mob
/datum/reagent/proc/on_mob_add(mob/living/L)
	return

// Called when this reagent is removed while inside a mob
/datum/reagent/proc/on_mob_delete(mob/living/L)
	SEND_SIGNAL(L, COMSIG_CLEAR_MOOD_EVENT, "[type]_overdose")
	return

// Called when this reagent first starts being metabolized by a liver
/datum/reagent/proc/on_mob_metabolize(mob/living/L)
	return

// Called when this reagent stops being metabolized by a liver
/datum/reagent/proc/on_mob_end_metabolize(mob/living/L)
	return

/datum/reagent/proc/on_move(mob/M)
	return

// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(data)
	return

// Called when two reagents of the same are mixing.
/datum/reagent/proc/on_merge(data)
	return

/datum/reagent/proc/on_update(atom/A)
	return

// Called when the reagent container is hit by an explosion
/datum/reagent/proc/on_ex_act(severity)
	return

// Called if the reagent has passed the overdose threshold and is set to be triggering overdose effects
/datum/reagent/proc/overdose_process(mob/living/M)
	return

/datum/reagent/proc/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You feel like you took too much of [name]!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)
	return

/proc/pretty_string_from_reagent_list(list/reagent_list)
	//Convert reagent list to a printable string for logging etc
	var/list/rs = list()
	for (var/datum/reagent/R in reagent_list)
		rs += "[R.name], [R.volume]"

	return rs.Join(" | ")

/datum/reagent/proc/define_gas()
	var/list/cached_reactions = GLOB.chemical_reactions_list
	for(var/reaction in cached_reactions[src.type])
		var/datum/chemical_reaction/new_reaction = reaction
		if(!istype(new_reaction))
			continue
		if(new_reaction.required_reagents.len < 2) // no reagents that react on their own
			return null
	var/datum/gas/new_gas = new
	new_gas.id = "[src.type]"
	new_gas.name = name
	new_gas.specific_heat = specific_heat / 10
	new_gas.color = color
	new_gas.breath_reagent = src.type
	new_gas.group = GAS_GROUP_CHEMICALS
	new_gas.moles_visible = MOLES_GAS_VISIBLE
	return new_gas

/datum/reagent/proc/create_gas()
	var/datum/gas/new_gas = define_gas()
	if(istype(new_gas)) // if this reagent should never be a gas, define_gas may return null
		GLOB.gas_data.add_gas(new_gas)
		var/datum/gas_reaction/condensation/condensation_reaction = new(src) // did you know? you can totally just add new reactions at runtime. it's allowed
		SSair.add_reaction(condensation_reaction)
	return new_gas


/datum/reagent/proc/get_gas()
	if(gas)
		return gas
	else
		var/datum/auxgm/cached_gas_data = GLOB.gas_data
		. = "[src.type]"
		if(!(. in cached_gas_data.ids))
			create_gas()
