/obj/item/autosurgeon/neuromod/corpseswap
	name = "corpse swap neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/corpseswap)

/obj/item/organ/cyberimp/neuromod/targeted/corpseswap
	name = "Corpse Swap"
	desc = "This neuromod allows you to swap minds with a corpse."
	icon_state = "mindjack"
	cast_message = "<span class='notice'>Your connection to your body grows weaker. Click on a target area.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	max_distance = 9
	cooldown = 5 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/corpseswap/activate(mob/living/carbon/target)
	if(!iscarbon(target))
		return

	if(target.stat != DEAD)
		to_chat(owner,"<span class='danger'>They aren't dead!<span>")
		return

	to_chat(owner,"<span class='notice'>You start to focus on [target]...</span>")
	if(do_mob(owner,owner,5 SECONDS))
		to_chat(owner,"<span class='notice'>You send your command directly to your target's brain.</span>")
		swap(target)

	..()


/obj/item/organ/cyberimp/neuromod/targeted/corpseswap/proc/swap(mob/living/target)
	// Swap health - don't want them to get free heals
	var/brute_loss = owner.getBruteLoss()
	var/fire_loss = owner.getFireLoss()
	var/oxy_loss = owner.getOxyLoss()
	var/tox_loss = owner.getToxLoss()

	owner.fully_heal()

	owner.adjustBruteLoss(target.getBruteLoss())
	owner.adjustFireLoss(target.getFireLoss())
	owner.adjustOxyLoss(target.getOxyLoss())
	owner.adjustToxLoss(target.getToxLoss())

	target.revive(TRUE)

	target.adjustBruteLoss(brute_loss)
	target.adjustFireLoss(fire_loss)
	target.adjustOxyLoss(oxy_loss)
	target.adjustToxLoss(tox_loss)

	//Swap Bodies
	var/mob/dead/observer/ghost = owner.ghostize(0)
	if(target.ckey)
		target.mind.transfer_to(owner)

	ghost.mind.transfer_to(target)
	if(ghost.key)
		target.key = ghost.key
	qdel(ghost)

	Insert(target)
