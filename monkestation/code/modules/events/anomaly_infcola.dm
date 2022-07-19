/datum/round_event_control/infcola
	name = "Cola Infinitum"
	typepath = /datum/round_event/infcola
	min_players = 1
	max_occurrences = 10
	var/atom/special_target
	can_malf_fake_alert = TRUE

/datum/round_event/infcola
	announceWhen = 5

/datum/round_event/infcola/announce(fake)
	priority_announce("Our long-range anomaly scanners have detected leakage from a soda filled dimension. Nanotrasen is not responsible for any damages caused by these anomalous canisters.", "General Alert", SSstation.announcer.get_rand_alert_sound())

/obj/item/reagent_containers/food/drinks/soda_cans/inf
	name = "Space Cola INFINITE"
	desc = "Cola. Probably not from space. Proceed with caution."
	icon_state = "cola"
	list_reagents = list()

/obj/item/reagent_containers/food/drinks/soda_cans/inf/Initialize()
	var/reagents = volume
	while(reagents)
		var/newreagent = rand(1, min(reagents, 30))
		list_reagents += list((get_random_reagent_id() = newreagent))  // proc gives reagents from a whitelist
		reagents -= newreagent

	. = ..()

/datum/round_event/infcola/start()
	for(var/i in 1 to rand(5, 10))  // generates between 5-10 cans
		var/obj/item/reagent_containers/food/drinks/soda_cans/inf/newCan = new(src)
		var/turf/warp = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)
		newCan.forceMove(warp)
		do_smoke(location=warp)
