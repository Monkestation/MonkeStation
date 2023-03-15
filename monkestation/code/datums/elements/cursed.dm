//monkestation port from TG
/**
 * # cursed element!
 *
 *Attaching this element to something will make it float, and get a special ai controller!
 */
/datum/element/cursed
	element_flags = ELEMENT_DETACH

/datum/element/cursed/Attach(datum/target, slot)
	. = ..()
	if(!isitem(target))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/master = target
	var/datum/ai_controller/ai = new /datum/ai_controller/cursed(master)
	ai.blackboard[BB_TARGET_SLOT] = slot
	master.ai_controller = ai
//	master.AddElement(/datum/element/movetype_handler)
//	ADD_TRAIT(master, TRAIT_MOVE_FLYING, ELEMENT_TRAIT) im pretty sure TRAIT_MOVE stuff would require a major refactor port, as I was unable to find a way to make items fly

/datum/element/cursed/Detach(datum/source)
	. = ..()
	var/obj/item/master = source
	QDEL_NULL(master.ai_controller)
//	REMOVE_TRAIT(master, TRAIT_MOVE_FLYING, ELEMENT_TRAIT) im not doing that
//	master.RemoveElement(/datum/element/movetype_handler)
