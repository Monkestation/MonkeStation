/datum/reagent/toxin/mimic
	name = "Mimic Toxin"
	description = "A toxin produced by infesting mimics."
	color = "#47194b"
	toxpwr = 1

/datum/reagent/toxin/mimic/on_mob_life(mob/living/carbon/victim)
	victim.adjustStaminaLoss(15)
	victim.adjustCloneLoss(2)
	victim.Jitter(15)
	return ..()

//The following is all part of the botany chemical rebalance
/datum/reagent/toxin/lexorin
	can_synth = FALSE //Extremely deadly

/datum/reagent/toxin/bungotoxin
	can_synth = FALSE //A bit OP to directly have in a plant

/datum/reagent/toxin/initropidril
	can_synth = FALSE //Too strong for botany. 25% chance a tick to really ruin your day.

/datum/reagent/toxin/pancuronium
	can_synth = FALSE //Too strong for botany. Ten cycles and permastunned

/datum/reagent/toxin/sulfonal
	can_synth = FALSE //Too strong for botany. This stuff removes people from the round outright

/datum/reagent/toxin/coniine
	can_synth = FALSE //Too strong for botany. Kills in no time

/datum/reagent/toxin/curare
	can_synth = FALSE //Too strong for botany. 6 second stuns?

/datum/reagent/toxin/leaper_venom
	can_synth = FALSE //5 toxin a tick
