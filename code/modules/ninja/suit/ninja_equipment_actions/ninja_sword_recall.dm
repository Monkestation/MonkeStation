/datum/action/item_action/ninja_sword_recall
	name = "Recall Energy Katana (Variable Cost)"
	desc = "Teleports the Energy Katana linked to this suit to its wearer, cost based on distance."
	button_icon_state = "energy_katana"
	icon_icon = 'icons/obj/items_and_weapons.dmi'

/**
  * Proc called to recall the ninja's sword.
  *
  * Called to summon the ninja's katana back to them
  * If the katana can see the ninja, it will throw itself towards them.
  * If not, the katana will teleport itself to the ninja.
  */
/obj/item/clothing/suit/space/space_ninja/proc/ninja_sword_recall()
	var/mob/living/carbon/human/ninja = affecting
	var/cost = 0
	var/inview = TRUE

	if(!zandatsu)
		to_chat(ninja, "<span class='warning'>Could not locate Energy Katana!</span>")
		return

	if(zandatsu in ninja)
		return

	var/distance = get_dist(ninja,zandatsu)

	if(!(zandatsu in view(ninja)))
		cost = distance //Actual cost is cost x 10, so 5 turfs is 50 cost.
		inview = FALSE

	if(!ninja_cost(cost))
		if(iscarbon(zandatsu.loc))
			var/mob/living/carbon/sword_holder = zandatsu.loc
			sword_holder.transferItemToLoc(zandatsu, get_turf(zandatsu), TRUE)

		else
			zandatsu.forceMove(get_turf(zandatsu))

		if(inview) //If we can see the katana, throw it towards ourselves, damaging people as we go.
			zandatsu.spark_system.start()
			playsound(ninja, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
			ninja.visible_message("<span class='danger'>\the [zandatsu] flies towards [ninja]!</span>","<span class='warning'>You hold out your hand and \the [zandatsu] flies towards you!</span>")
			zandatsu.throw_at(ninja, distance+1, zandatsu.throw_speed, ninja)

		else //Else just TP it to us.
			zandatsu.returnToOwner(ninja, 1)
