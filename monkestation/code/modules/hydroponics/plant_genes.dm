/datum/plant_gene/trait/proc/process_stats(obj/item/seeds/parent_seed)
	if(trait_flags & TRAIT_HALVES_YIELD)
		parent_seed.adjust_yield(parent_seed.yield * 0.5)
	if(trait_flags & TRAIT_HALVES_PRODUCTION)
		parent_seed.adjust_production(parent_seed.production * 0.5)
	if(trait_flags & TRAIT_HALVES_POTENCY)
		parent_seed.adjust_potency(parent_seed.potency * 0.5)
	if(trait_flags & TRAIT_HALVES_ENDURANCE)
		parent_seed.adjust_endurance(parent_seed.endurance * 0.5)
	if(trait_flags & TRAIT_HALVES_LIFESPAN)
		parent_seed.adjust_lifespan(parent_seed.lifespan * 0.5)
/datum/plant_gene/trait/noreact
	// Makes plant reagents not react until squashed.
	name = "Separated Chemicals"

/datum/plant_gene/trait/noreact/on_new(obj/item/food/grown/grown_food, newloc)
	..()
	ENABLE_BITFIELD(grown_food.reagents.flags, NO_REACT)

/datum/plant_gene/trait/noreact/on_squashreact(obj/item/food/grown/grown_food, atom/target)
	DISABLE_BITFIELD(grown_food.reagents.flags, NO_REACT)
	grown_food.reagents.handle_reactions()


/**
 * A plant trait that causes the plant's food reagents to ferment instead.
 *
 * In practice, it replaces the plant's nutriment and vitamins with half as much of it's fermented reagent.
 * This exception is executed in seeds.dm under 'prepare_result'.
 *
 * Incompatible with auto-juicing composition.
 */
/datum/plant_gene/trait/brewing
	name = "Auto-Distilling Composition"
	trait_ids = CONTENTS_CHANGE_ID

/**
 * Similar to auto-distilling, but instead of brewing the plant's contents it juices it.
 *
 * Incompatible with auto-distilling composition.
 */
/datum/plant_gene/trait/juicing
	name = "Auto-Juicing Composition"
	trait_ids = CONTENTS_CHANGE_ID

/**
 * Plays a laughter sound when someone slips on it.
 * Like the sitcom component but for plants.
 * Just like slippery skin, if we have a trash type this only functions on that. (Banana peels)
 */
/datum/plant_gene/trait/plant_laughter
	name = "Hallucinatory Feedback"
	/// Sounds that play when this trait triggers
	var/list/sounds = list('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg')

/datum/plant_gene/trait/plant_laughter/on_slip(obj/item/food/grown/our_plant, mob/living/carbon/target)
	. = ..()
	our_plant.audible_message(span_notice("[our_plant] lets out burst of laughter."))
	playsound(our_plant, pick(sounds), 100, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
/**
 * A plant trait that causes the plant to gain aesthetic googly eyes.
 *
 * Has no functional purpose outside of causing japes, adds eyes over the plant's sprite, which are adjusted for size by potency.
 */
/datum/plant_gene/trait/eyes
	name = "Oculary Mimicry"
	/// Our googly eyes appearance.
	var/mutable_appearance/googly

/datum/plant_gene/trait/eyes/on_new(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	googly = mutable_appearance('icons/obj/hydroponics/harvest.dmi', "eyes")
	googly.appearance_flags = RESET_COLOR
	our_plant.add_overlay(googly)


/**
 * This trait automatically heats up the plant's chemical contents when harvested.
 * This requires nutriment to fuel. 1u nutriment = 25 K.
 */
/datum/plant_gene/trait/chem_heating
	name = "Exothermic Activity"
	trait_ids = TEMP_CHANGE_ID
	trait_flags = TRAIT_HALVES_YIELD

/**
 * This trait is the opposite of above - it cools down the plant's chemical contents on harvest.
 * This requires nutriment to fuel. 1u nutriment = -5 K.
 */
/datum/plant_gene/trait/chem_cooling
	name = "Endothermic Activity"
	trait_ids = TEMP_CHANGE_ID
	trait_flags = TRAIT_HALVES_YIELD
