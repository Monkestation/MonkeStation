/obj/item/autosurgeon/neuromod/biomatter_transfer
	name = "biomatter transfer neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/biomatter_transfer)

/obj/item/organ/cyberimp/neuromod/targeted/biomatter_transfer
	name = "Biomatter Transfer"
	desc = "This neuromod allows you to transfer your biomatter to someone else, hurting you and healing them."
	cooldown = 10 SECONDS
	cast_message = "Your hands glow green. Click on a target."
	cancel_message = "Your hands stop glowing."
	max_distance = 2
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/biomatter_transfer/activate(target)
	if(!isliving(target))
		return

	var/mob/living/living_target = target

	..()

	if(!do_mob(owner,living_target, 3 SECONDS))
		return

	var/owner_damage_type = pick(BRUTE,BURN,TOX)
	var/damage_amount = rand(10,15)

	var/damage_text = "body hurt"
	switch(owner_damage_type)
		if(BRUTE)
			damage_text = "veins burst"
		if(BURN)
			damage_text = "skin char"
		if(TOX)
			damage_text = "blood boil"

	owner.apply_damage(damage_amount,owner_damage_type)
	living_target.heal_ordered_damage(damage_amount, list(BRUTE,BURN,TOX,OXY))

	to_chat(owner,"<span class='danger'>You feel your [damage_text] as you heal [living_target].</span>")
	to_chat(living_target,"<span class='notice'>You feel your pain fade as [owner] holds \his hand over you.</span>")


