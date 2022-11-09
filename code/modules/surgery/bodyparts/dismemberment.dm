
/obj/item/bodypart/proc/can_dismember(obj/item/I)
	if(dismemberable)
		return TRUE

//Dismember a limb
/obj/item/bodypart/proc/dismember(dam_type = BRUTE)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE

	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	affecting.receive_damage(CLAMP(brute_dam/2 * affecting.body_damage_coeff, 15, 50), CLAMP(burn_dam/2 * affecting.body_damage_coeff, 0, 50)) //Damage the chest based on limb's existing damage
	C.visible_message("<span class='danger'><B>[C]'s [src.name] has been violently dismembered!</B></span>")

	if(C.stat <= SOFT_CRIT)//No more screaming while unconsious
		if(IS_ORGANIC_LIMB(affecting))//Chest is a good indicator for if a carbon is robotic in nature or not.
			C.emote("scream")

	SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "dismembered", /datum/mood_event/dismembered)
	drop_limb()

	C.update_equipment_speed_mods() // Update in case speed affecting item unequipped by dismemberment
	var/turf/location = C.loc
	if(istype(location))
		C.add_splatter_floor(location)

	if(QDELETED(src)) //Could have dropped into lava/explosion/chasm/whatever
		return TRUE
	if(dam_type == BURN)
		burn()
		return TRUE
	add_mob_blood(C)
	var/direction = pick(GLOB.cardinals)
	var/t_range = rand(2,max(throw_range/2, 2))
	var/turf/target_turf = get_turf(src)
	for(var/i in 1 to t_range-1)
		var/turf/new_turf = get_step(target_turf, direction)
		if(!new_turf)
			break
		target_turf = new_turf
		if(new_turf.density)
			break
	throw_at(target_turf, throw_range, throw_speed)
	return TRUE


/obj/item/bodypart/chest/dismember()
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	. = list()
	var/organ_spilled = 0
	var/turf/T = get_turf(C)
	C.add_splatter_floor(T)
	playsound(get_turf(C), 'sound/misc/splort.ogg', 80, 1)
	for(var/X in C.internal_organs)
		var/obj/item/organ/O = X
		var/org_zone = check_zone(O.zone)
		if(org_zone != BODY_ZONE_CHEST)
			continue
		O.Remove(C)
		O.forceMove(T)
		organ_spilled = 1
		. += X
	if(cavity_item)
		cavity_item.forceMove(T)
		. += cavity_item
		cavity_item = null
		organ_spilled = 1

	if(organ_spilled)
		C.visible_message("<span class='danger'><B>[C]'s internal organs spill out onto the floor!</B></span>")



//limb removal. The "special" argument is used for swapping a limb with a new one without the effects of losing a limb kicking in.
/obj/item/bodypart/proc/drop_limb(special)
	if(!owner)
		return
	var/atom/Tsec = owner.drop_location()
	var/mob/living/carbon/C = owner
	update_limb(1)
	C.bodyparts -= src

	if(held_index)
		C.dropItemToGround(owner.get_item_for_held_index(held_index), 1)
		C.hand_bodyparts[held_index] = null

	owner = null

	for(var/X in C.surgeries) //if we had an ongoing surgery on that limb, we stop it.
		var/datum/surgery/S = X
		if(S.operated_bodypart == src)
			C.surgeries -= S
			qdel(S)
			break

	for(var/obj/item/I in embedded_objects)
		embedded_objects -= I
		I.forceMove(src)
	if(!C.has_embedded_objects())
		C.clear_alert("embeddedobject")
		SEND_SIGNAL(C, COMSIG_CLEAR_MOOD_EVENT, "embedded")

	if(!special)
		if(C.dna)
			for(var/X in C.dna.mutations) //some mutations require having specific limbs to be kept.
				var/datum/mutation/human/MT = X
				if(MT.limb_req && MT.limb_req == body_zone)
					C.dna.force_lose(MT)

		for(var/X in C.internal_organs) //internal organs inside the dismembered limb are dropped.
			var/obj/item/organ/O = X
			var/org_zone = check_zone(O.zone)
			if(org_zone != body_zone)
				continue
			O.transfer_to_limb(src, C)


	synchronize_bodytypes(C)

	update_icon_dropped()
	C.update_health_hud() //update the healthdoll
	C.update_body()
	C.update_hair()
	C.update_mobility()

	if(!Tsec)	// Tsec = null happens when a "dummy human" used for rendering icons on prefs screen gets its limbs replaced.
		qdel(src)
		return

	if(is_pseudopart)
		drop_organs(C)	//Psuedoparts shouldn't have organs, but just in case
		qdel(src)
		return

	forceMove(Tsec)



//when a limb is dropped, the internal organs are removed from the mob and put into the limb
/obj/item/organ/proc/transfer_to_limb(obj/item/bodypart/LB, mob/living/carbon/C)
	Remove(C, TRUE)
	forceMove(LB)

/obj/item/organ/brain/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	Remove(C)	//Changeling brain concerns are now handled in Remove
	forceMove(LB)
	LB.brain = src
	if(brainmob)
		LB.brainmob = brainmob
		brainmob = null
		LB.brainmob.forceMove(LB)
		LB.brainmob.set_stat(DEAD)

/obj/item/organ/eyes/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	LB.eyes = src
	..()

/obj/item/organ/ears/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	LB.ears = src
	..()

/obj/item/organ/tongue/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	LB.tongue = src
	..()

/obj/item/bodypart/chest/drop_limb(special)
	if(special)
		..()

/obj/item/bodypart/r_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
			if(R)
				R.update_icon()
		if(C.gloves)
			C.dropItemToGround(C.gloves, TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay


/obj/item/bodypart/l_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/L = C.hud_used.hand_slots["[held_index]"]
			if(L)
				L.update_icon()
		if(C.gloves)
			C.dropItemToGround(C.gloves, TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay


/obj/item/bodypart/r_leg/drop_limb(special)
	if(owner && !special)
		if(owner.legcuffed)
			owner.legcuffed.forceMove(owner.drop_location()) //At this point bodypart is still in nullspace
			owner.legcuffed.dropped(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed()
		if(owner.shoes)
			owner.dropItemToGround(owner.shoes, TRUE)
	..()

/obj/item/bodypart/l_leg/drop_limb(special) //copypasta
	if(owner && !special)
		if(owner.legcuffed)
			owner.legcuffed.forceMove(owner.drop_location())
			owner.legcuffed.dropped(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed()
		if(owner.shoes)
			owner.dropItemToGround(owner.shoes, TRUE)
	..()

/obj/item/bodypart/head/drop_limb(special)
	if(!special)
		//Drop all worn head items
		for(var/X in list(owner.glasses, owner.ears, owner.wear_mask, owner.head))
			var/obj/item/I = X
			owner.dropItemToGround(I, TRUE)

	owner.wash_cream() //clean creampie overlay

	//Handle dental implants
	for(var/datum/action/item_action/hands_free/activate_pill/AP in owner.actions)
		AP.Remove(owner)
		var/obj/pill = AP.target
		if(pill)
			pill.forceMove(src)

	name = owner ? "[owner.real_name]'s head" : "unknown [limb_id] head"
	..()

//Attach a limb to a human and drop any existing limb of that type.
/obj/item/bodypart/proc/replace_limb(mob/living/carbon/C, special, is_creating = FALSE)
	if(!istype(C))
		return
	var/obj/item/bodypart/O = C.get_bodypart(body_zone)
	if(O)
		O.drop_limb(1)
	attach_limb(C, special, is_creating)

/obj/item/bodypart/head/replace_limb(mob/living/carbon/C, special, is_creating = FALSE)
	if(!istype(C))
		return
	var/obj/item/bodypart/head/O = C.get_bodypart(body_zone)
	if(O)
		if(!special)
			return
		else
			O.drop_limb(1)
	attach_limb(C, special, is_creating)

/obj/item/bodypart/proc/attach_limb(mob/living/carbon/C, special, is_creating = FALSE)
	moveToNullspace()
	owner = C
	C.bodyparts += src
	if(held_index)
		if(held_index > C.hand_bodyparts.len)
			C.hand_bodyparts.len = held_index
		C.hand_bodyparts[held_index] = src
		if(C.dna.species.mutanthands && !is_pseudopart)
			C.put_in_hand(new C.dna.species.mutanthands(), held_index)
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/hand = C.hud_used.hand_slots["[held_index]"]
			if(hand)
				hand.update_icon()
		C.update_inv_gloves()

	if(special) //non conventional limb attachment
		for(var/X in C.surgeries) //if we had an ongoing surgery to attach a new limb, we stop it.
			var/datum/surgery/S = X
			var/surgery_zone = check_zone(S.location)
			if(surgery_zone == body_zone)
				C.surgeries -= S
				qdel(S)
				break

	for(var/obj/item/organ/O in contents)
		O.Insert(C)

	// Bodyparts need to be sorted for leg masking to be done properly. It also will allow for some predictable
	// behavior within said bodyparts list. We sort it here, as it's the only place we make changes to bodyparts.
	C.bodyparts = sort_list(C.bodyparts, /proc/cmp_bodypart_by_body_part_asc)

	synchronize_bodytypes(C)
	if(is_creating)
		update_limb(is_creating = TRUE)
	update_bodypart_damage_state()

	C.updatehealth()
	C.update_body()
	C.update_hair()
	C.update_mobility()


/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	//Transfer some head appearance vars over
	if(brain)
		if(brainmob)
			brainmob.container = null //Reset brainmob head var.
			brainmob.forceMove(brain) //Throw mob into brain.
			brain.brainmob = brainmob //Set the brain to use the brainmob
			brainmob = null //Set head brainmob var to null
		brain.Insert(C) //Now insert the brain proper
		brain = null //No more brain in the head

	if(tongue)
		tongue = null
	if(ears)
		ears = null
	if(eyes)
		eyes = null

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		hair_color = H.hair_color
		hair_style = H.hair_style
		facial_hair_color = H.facial_hair_color
		facial_hair_style = H.facial_hair_style
		lip_style = H.lip_style
		lip_color = H.lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)

	//Handle dental implants
	for(var/obj/item/reagent_containers/pill/P in src)
		for(var/datum/action/item_action/hands_free/activate_pill/AP in P.actions)
			P.forceMove(C)
			AP.Grant(C)
			break

	..()

/obj/item/bodypart/proc/synchronize_bodytypes(mob/living/carbon/C)
	if(!C.dna.species)
		return
	//This codeblock makes sure that the owner's bodytype flags match the flags of all of it's parts.
	var/all_limb_flags
	for(var/obj/item/bodypart/BP as() in C.bodyparts)
		all_limb_flags =  all_limb_flags | BP.bodytype

	C.dna.species.bodytype = all_limb_flags

//Regenerates all limbs. Returns amount of limbs regenerated
/mob/living/proc/regenerate_limbs(noheal, excluded_limbs)
	return 0

/mob/living/carbon/regenerate_limbs(noheal, list/excluded_limbs)
	var/list/limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	if(excluded_limbs)
		limb_list -= excluded_limbs
	for(var/Z in limb_list)
		. += regenerate_limb(Z, noheal)

/mob/living/proc/regenerate_limb(limb_zone, noheal)
	return

/mob/living/carbon/regenerate_limb(limb_zone, noheal)
	var/obj/item/bodypart/L
	if(get_bodypart(limb_zone))
		return 0
	L = newBodyPart(limb_zone, 0, 0)
	L.replace_limb(src, TRUE, TRUE)
	return 1
