//Organ and Experimentor stuff

#define NEUROMOD_SPECIAL 1
#define NEUROMOD_SUPER_RARE 3
#define NEUROMOD_RARE 5
#define NEUROMOD_UNCOMMON 7
#define NEUROMOD_COMMON 9

/obj/item/mimic_organ
	name = "mimic organ"
	desc = "A mass of black goo. The E.X.P.E.R.I-MENTOR could probably do something with this. You can also Grind it down to get rezadone."
	icon = 'monkestation/icons/obj/misc/neuromods.dmi'
	icon_state = "mimic_organ"
	item_state = "mimic_organ"
	grind_results = list(/datum/reagent/medicine/rezadone = 15)
	w_class = WEIGHT_CLASS_SMALL
	var/static/list/neuromod_list = list(
		//SPECIAL
		/obj/item/autosurgeon/neuromod/clown = NEUROMOD_SPECIAL,
		//SUPER RARE
		/obj/item/autosurgeon/neuromod/stalk = NEUROMOD_SUPER_RARE,
		/obj/item/autosurgeon/neuromod/electrostatic_burst = NEUROMOD_SUPER_RARE,
		/obj/item/autosurgeon/neuromod/divination = NEUROMOD_SUPER_RARE,
		//RARE
		/obj/item/autosurgeon/neuromod/phantom_shift = NEUROMOD_RARE,
		/obj/item/autosurgeon/neuromod/smuggle = NEUROMOD_RARE,
		/obj/item/autosurgeon/neuromod/mindjack = NEUROMOD_RARE,
		/obj/item/autosurgeon/neuromod/weapon_transformation = NEUROMOD_RARE,
		/obj/item/autosurgeon/neuromod/mimic_composition = NEUROMOD_RARE,
		//UNCOMMON
		/obj/item/autosurgeon/neuromod/biomatter_transfer = NEUROMOD_UNCOMMON,
		/obj/item/autosurgeon/neuromod/kinetic_blast = NEUROMOD_UNCOMMON,
		/obj/item/autosurgeon/neuromod/rat_form = NEUROMOD_UNCOMMON,
		/obj/item/autosurgeon/neuromod/grasp = NEUROMOD_UNCOMMON,
		/obj/item/autosurgeon/neuromod/corpseswap = NEUROMOD_UNCOMMON,
		//COMMON
		/obj/item/autosurgeon/neuromod/superthermal = NEUROMOD_COMMON,
		/obj/item/autosurgeon/neuromod/psychoshock = NEUROMOD_COMMON,
		/obj/item/autosurgeon/neuromod/scramble_electronics = NEUROMOD_COMMON,
	)

/obj/item/mimic_organ/proc/roll_neuromod()
	var/obj/item/autosurgeon/neuromod/new_neuromod = pickweight(neuromod_list)
	new new_neuromod(get_turf(src))
	qdel(src)

//Autosurgeon

/obj/item/autosurgeon/neuromod
	name = "neuromod"
	desc = "A device that rebuilds your brain to give you abilities latent in the mimic's dna."
	icon = 'icons/obj/device.dmi'
	icon_state = "autoimplanter"
	item_state = "nothing"
	w_class = WEIGHT_CLASS_SMALL
	uses = 1
	starting_organ = list(/obj/item/organ/cyberimp/neuromod)

/obj/item/autosurgeon/neuromod/examine(mob/user)
	. = ..()
	for(var/obj/item/organ in storedorgan)
		. += organ.desc

/obj/item/autosurgeon/neuromod/attack_self(mob/user)
	if(user.getorganslot(ORGAN_SLOT_BRAIN_NEUROMOD))
		to_chat(user,"<span class='warning'>You already have a neuromod, any more would ruin your brain!</span>")
		return
	..()
	if(!uses)
		desc = "[initial(desc)] Looks like it's been used up."

/obj/item/autosurgeon/neuromod/attackby(obj/item/implant, mob/user, params)
	if(istype(implant, organ_type))
		to_chat(user, "<span class='notice'>You can't fit the [implant] into [src].</span>")
	else
		return ..()

/obj/item/autosurgeon/neuromod/screwdriver_act(mob/user,obj/item/screwdriver)
	return FALSE

//Implant Status Effect

/datum/status_effect/neuromod
	id = "Neuromod"
	examine_text = "<span class='danger'>SUBJECTPRONOUN has an eye that is red and swollen.</span>"
	alert_type = null

//Neuromod Implant

/obj/item/organ/cyberimp/neuromod
	desc = "This is a neuromod."
	name = "Neuromod"
	icon = 'monkestation/icons/mob/actions/actions_neuromods.dmi'
	icon_state = "phantom_shift"
	implant_color = "#c41ae6"
	var/cooldown = 0 SECONDS
	slot = ORGAN_SLOT_BRAIN_NEUROMOD
	COOLDOWN_DECLARE(neuromod_cooldown)

/obj/item/organ/cyberimp/neuromod/ui_action_click()
	if(!COOLDOWN_FINISHED(src, neuromod_cooldown))
		to_chat(owner, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, neuromod_cooldown)*0.1] seconds to use [src] again!</span>")
		return TRUE
	COOLDOWN_START(src, neuromod_cooldown, cooldown)

/obj/item/organ/cyberimp/neuromod/Insert(mob/living/carbon/user, special, drop_if_replaced)
	. = ..()
	user.apply_status_effect(/datum/status_effect/neuromod)

/obj/item/organ/cyberimp/neuromod/Remove(mob/living/carbon/user, special)
	. = ..()
	user.remove_status_effect(/datum/status_effect/neuromod)

//Neuromod Implant - Targeted

/obj/item/organ/cyberimp/neuromod/targeted
	var/active = FALSE
	var/cast_message = "<span class='notice'>You start using the neuromod. Click on a target.</span>"
	var/cancel_message = "<span class='notice'>You stop using the neuromod.</span>"
	//The max distance you can use a spell from. -1 for infinite range.
	var/max_distance = 9

/obj/item/organ/cyberimp/neuromod/targeted/ui_action_click()
	if(!COOLDOWN_FINISHED(src, neuromod_cooldown))
		to_chat(owner, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, neuromod_cooldown)*0.1] seconds to use [src] again!</span>")
		return TRUE
	if(!active)
		active = TRUE
		owner.click_intercept = src
		to_chat(owner, cast_message)
	else
		active = FALSE
		owner.click_intercept = null
		to_chat(owner, cancel_message)

/obj/item/organ/cyberimp/neuromod/targeted/proc/activate(target)
	COOLDOWN_START(src, neuromod_cooldown, cooldown)
	return

/obj/item/organ/cyberimp/neuromod/targeted/proc/InterceptClickOn(mob/living/carbon/caller, params, atom/target)
	active = FALSE
	caller.click_intercept = null
	if(get_dist(caller,target) <= max_distance || max_distance == -1)
		activate(target)
	else
		to_chat(owner, "<span class='warning'>That place is out of your reach.</span>")
