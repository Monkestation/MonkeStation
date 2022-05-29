/obj/item/skillchip
	name = "skillchip"
	desc = "This biochip integrates with user's brain to enable mastery of specific skill. Consult certified Nanotrasen neurosurgeon before use."

	icon = 'icons/obj/card.dmi'
	icon_state = "data_3"
	custom_price = 500
	w_class = WEIGHT_CLASS_SMALL

	/// Trait automatically granted by this chip, optional
	var/auto_trait
	/// Skill name shown on UI
	var/skill_name
	/// Skill description shown on UI
	var/skill_description
	/// FS icon show on UI
	var/skill_icon = "brain"
	/// Message shown when implanting the chip
	var/implanting_message
	/// Message shown when extracting the chip
	var/removal_message
	//If set to TRUE, trying to extract the chip will destroy it instead
	var/removable = TRUE
	/// How many skillslots this one takes
	var/slot_cost = 1

/// Called after implantation and/or brain entering new body
/obj/item/skillchip/proc/on_apply(mob/living/carbon/user,silent=TRUE)
	if(!silent && implanting_message)
		to_chat(user,implanting_message)
	if(auto_trait)
		ADD_TRAIT(user,auto_trait,SKILLCHIP_TRAIT)
	user.used_skillchip_slots += slot_cost

/// Called after removal and/or brain exiting the body
/obj/item/skillchip/proc/on_removal(mob/living/carbon/user,silent=TRUE)
	if(!silent && removal_message)
		to_chat(user,removal_message)
	if(auto_trait)
		REMOVE_TRAIT(user,auto_trait,SKILLCHIP_TRAIT)
	user.used_skillchip_slots -= slot_cost

/// Checks if this implant is valid to implant in a given mob.
/obj/item/skillchip/proc/can_be_implanted(mob/living/carbon/target)
	//No brain
	var/obj/item/organ/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(QDELETED(target_brain))
		return FALSE
	//No skill slots left
	if(target.used_skillchip_slots + slot_cost > target.max_skillchip_slots)
		return FALSE
	//Only one copy of each for now.
	if(locate(type) in target_brain.skillchips)
		return FALSE
	return TRUE

/// Returns readable reason why implanting cannot succeed --todo switch to flag retval in can_be_implanted to cut down copypaste
/obj/item/skillchip/proc/can_be_implanted_message(mob/living/carbon/target)
	//No brain
	var/obj/item/organ/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(QDELETED(target_brain))
		return "No brain detected."
	//No skill slots left
	if(target.used_skillchip_slots + slot_cost > target.max_skillchip_slots)
		return "Complexity limit exceeded."
	//Only one copy of each for now.
	if(locate(type) in target_brain.skillchips)
		return "Duplicate chip detected."
	return "Chip ready for implantation."
