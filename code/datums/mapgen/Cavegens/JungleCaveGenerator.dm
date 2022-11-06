/datum/map_generator/cave_generator/jungle
	open_turf_types = list(/turf/open/floor/plating/grass/jungle = 1, /turf/open/floor/plating/dirt/jungle = 15, /turf/open/floor/plating/dirt/jungle/dark = 10)
	closed_turf_types =  list(/turf/closed/mineral/random/jungle = 1)
	blacklisted_turf_types = list(/turf/open/water/jungle) // Don't override rivers


	feature_spawn_list = list(/obj/structure/geyser/random = 1)
	mob_spawn_list = null // Jungle mobs are a bit too broken to just haphazardly have around at the moment
	flora_spawn_list = list(/obj/structure/flora/grass/jungle = 2 , \
		/obj/structure/flora/grass/jungle/b = 2 , \
		/obj/structure/flora/tree/jungle = 2 , \
		/obj/structure/flora/rock/jungle = 1, \
		/obj/structure/flora/junglebush = 2, \
		/obj/structure/flora/junglebush/b = 1 , \
		/obj/structure/flora/junglebush/c = 2, \
		/obj/structure/flora/junglebush/large = 1, \
		/obj/structure/flora/rock/pile/largejungle = 1 \
		)

	flora_spawn_chance = 15
	initial_closed_chance = 45
	smoothing_iterations = 50
	birth_limit = 4
	death_limit = 3
