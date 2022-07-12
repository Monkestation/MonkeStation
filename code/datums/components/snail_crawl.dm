/datum/component/snailcrawl
	var/mob/living/carbon/snail

/datum/component/snailcrawl/Initialize()
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), .proc/lubricate)
	snail = parent

/datum/component/snailcrawl/proc/lubricate()
	SIGNAL_HANDLER

	if(snail.resting && !snail.buckled) //s l i d e
		var/turf/open/OT = get_turf(snail)
		if(isopenturf(OT))
			OT.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10, wet_time_to_add =5)
		snail.add_movespeed_modifier(MOVESPEED_ID_SNAIL_CRAWL, update=TRUE, priority=100, multiplicative_slowdown=-2.5, movetypes=GROUND)
	else
		snail.remove_movespeed_modifier(MOVESPEED_ID_SNAIL_CRAWL)

/datum/component/snailcrawl/_RemoveFromParent()
	snail.remove_movespeed_modifier(MOVESPEED_ID_SNAIL_CRAWL)
	return ..()
