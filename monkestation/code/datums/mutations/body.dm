//dewarf shrinks your body
/datum/mutation/human/dewarf
	name = "Dewarf"
	desc = "A mutation believed to be the cause of Dewarfism, not to be confused with Dwarfism."
	quality = POSITIVE
	difficulty = 16
	instability = 5
	conflicts = list(GIGANTISM, DWARFISM)
	locked = TRUE    // Default intert species for now, so locked from regular pool.

/datum/mutation/human/dewarf/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.transform = owner.transform.Scale(0.9, 0.8)
	owner.visible_message("<span class='danger'>[owner] suddenly shrinks!</span>", "<span class='notice'>Everything around you seems to grow..</span>")

/datum/mutation/human/dewarf/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.transform = owner.transform.Scale(1.25, 1.25)
	owner.visible_message("<span class='danger'>[owner] suddenly grows!</span>", "<span class='notice'>Everything around you seems to shrink..</span>")
