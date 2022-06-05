/obj/item/organ/bladder
	name = "bladder"
	icon_state = "innards" //replace later i ain't a good spriter
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BLADDER
	desc = "For managing your waste"

	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	var/fullness = 0
	var/max_capacity = 300
	var/decay_rate = 0.1
	var/usage = 10

	var/list/waste_list = list(/datum/reagent/urine = 10)

/obj/item/organ/bladder/on_life()
	..()
	if(fullness > 0)
		if(fullness - decay_rate < 0)
			fullness -= fullness
		else
			fullness -= decay_rate

/obj/item/organ/bladder/proc/output_waste(/mob/owner)
	if(fullness < 0)
		return FALSE
	if(fullness - usage < 0)
		return FALSE
	owner.audible_message("[owner] pisses all over the floor.", audible_message_flags = list(CHATMESSAGE_EMOTE = TRUE))
	var/datum/reagents/temporary = new(10000)
	temporary.add_reagent_list(waste_list, no_react = TRUE)
	var/turf/under_owner = get_turf(owner)

	under_owner.add_liquid_from_reagents(temporary)
	qdel(temporary)

