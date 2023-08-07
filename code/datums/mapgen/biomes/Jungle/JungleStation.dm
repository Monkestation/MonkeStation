/datum/biome/junglestation
	var/cellular_noise_map_id = MED_DENSITY
	var/turf/closed_turf = /turf/closed/mineral/random
	var/list/dense_flora = list()
	var/list/loose_flora = list()
	var/loose_flora_density = 0 // from 0 to 100
	var/dense_flora_density = 100
	var/spawn_fauna_on_closed = FALSE
	var/area/jungleland/this_area = /area/jungleland

/datum/biome/junglestation/New()
	. = ..()
	this_area = new this_area()

/datum/biome/junglestation/generate_turf(turf/gen_turf,list/density_map)

	var/closed = text2num(density_map[cellular_noise_map_id][world.maxx * (gen_turf.y - 1) + gen_turf.x])
	var/turf/chosen_turf
	if(closed)
		chosen_turf = closed_turf
		spawn_dense_flora(gen_turf)
	else
		chosen_turf = turf_type
		spawn_loose_flora(gen_turf)

	if((!closed || spawn_fauna_on_closed) && length(fauna_types) && prob(fauna_density))
		var/mob/fauna = pickweight(fauna_types)
		new fauna(gen_turf)
	. = gen_turf.ChangeTurf(chosen_turf, initial(chosen_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

/datum/biome/junglestation/proc/spawn_dense_flora(turf/gen_turf)
	if(length(dense_flora)  && prob(dense_flora_density))
		var/obj/structure/flora = pickweight(dense_flora)
		new flora(gen_turf)

/datum/biome/junglestation/proc/spawn_loose_flora(turf/gen_turf)
	if(length(loose_flora) && prob(loose_flora_density))
		var/obj/structure/flora = pickweight(loose_flora)
		new flora(gen_turf)

/datum/biome/junglestation/toxic_pit
	turf_type = /turf/open/floor/plating/dirt/jungleland/toxic_pit
	closed_turf = /turf/open/water/toxic_pit
	loose_flora = list(/obj/structure/flora/ausbushes/stalkybush = 2,/obj/structure/flora/rock = 2,/obj/structure/flora/rock/jungle = 2,/obj/structure/flora/rock/pile = 2,/obj/structure/flora/stump=2,/obj/structure/flora/tree/jungle = 1,/obj/structure/herb/explosive_shrooms = 0.2,/obj/structure/herb/cinchona = 0.05,/obj/structure/herb/liberal_hats = 0.5,/obj/structure/herb/fruit = 0.1)
	dense_flora = list(/obj/structure/flora/ausbushes/stalkybush = 1)
	loose_flora_density = 20
	dense_flora_density = 10
	fauna_density = 0.7
	spawn_fauna_on_closed = TRUE
	this_area = /area/jungleland/toxic_pit

/datum/biome/junglestation/plains
	turf_type = /turf/open/floor/plating/dirt/jungleland/jungle
	closed_turf = /turf/open/floor/plating/dirt/jungleland/toxic_pit
	dense_flora = list(/obj/structure/flora/rock = 2,/obj/structure/flora/rock/jungle = 1,/obj/structure/flora/rock/pile = 2)
	loose_flora = list(/obj/structure/flora/grass/jungle = 3,/obj/structure/flora/grass/jungle/b = 2,/obj/structure/flora/ausbushes = 2, /obj/structure/herb/random_plant = 1.5, /obj/structure/flora/ausbushes/leafybush = 1,/obj/structure/flora/ausbushes/sparsegrass = 1,/obj/structure/flora/ausbushes/fullgrass = 1,/obj/structure/herb/explosive_shrooms = 0.1,/obj/structure/flytrap = 0.1,/obj/structure/herb/fruit = 0.2)
	loose_flora_density = 30
	dense_flora_density = 1
	spawn_fauna_on_closed = TRUE
	this_area = /area/jungleland/plains

/datum/biome/junglestation/dry_swamp
	turf_type = /turf/open/floor/plating/dirt/jungleland/dry_swamp
	closed_turf = /turf/open/floor/plating/dirt/jungleland/dry_swamp1
	dense_flora = list(/obj/structure/flora/rock = 2,/obj/structure/flora/rock/jungle = 1,/obj/structure/flora/rock/pile = 2)
	loose_flora = list(/obj/structure/flora/ausbushes/stalkybush = 2,/obj/structure/flora/rock = 2,/obj/structure/flora/rock/jungle = 2,/obj/structure/flora/rock/pile = 2,/obj/structure/flora/stump=2,/obj/structure/flora/tree/jungle = 1,/obj/structure/herb/cinchona = 0.1, /obj/structure/flytrap = 0.1)
	dense_flora_density = 10
	loose_flora_density = 10
	fauna_density = 0.4
	spawn_fauna_on_closed = TRUE
	this_area = /area/jungleland/dry_swamp

/datum/biome/junglestation/jungle
	turf_type = /turf/open/floor/plating/dirt/jungleland/jungle
	closed_turf = /turf/open/floor/plating/dirt/jungleland/jungle
	cellular_noise_map_id = MED_DENSITY
	dense_flora = list(/obj/structure/flora/tree/jungle/small = 2,/obj/structure/flora/tree/jungle = 2, /obj/structure/flora/rock/jungle = 1, /obj/structure/flora/junglebush = 1, /obj/structure/flora/junglebush/b = 1, /obj/structure/flora/junglebush/c = 1, /obj/structure/flora/junglebush/large = 1, /obj/structure/flora/rock/pile/largejungle = 1)
	loose_flora = list(/obj/structure/flora/grass/jungle = 3,/obj/structure/flora/grass/jungle/b = 2,/obj/structure/flora/ausbushes = 2,/obj/structure/flora/ausbushes/leafybush = 1,/obj/structure/flora/ausbushes/sparsegrass = 1,/obj/structure/flora/ausbushes/fullgrass = 1,/obj/structure/herb/explosive_shrooms = 0.1,/obj/structure/flytrap = 0.1,/obj/structure/herb/fruit = 0.2)
	loose_flora_density = 30
	fauna_density = 0.65
	this_area = /area/jungleland/proper

/datum/biome/junglestation/jungle_sparse
	turf_type = /turf/open/floor/plating/dirt/jungleland/jungle
	closed_turf = /turf/open/floor/plating/dirt/jungleland/jungle
	cellular_noise_map_id = LOW_DENSITY
	dense_flora = list(/obj/structure/flora/tree/jungle/small = 2,/obj/structure/flora/tree/jungle = 2, /obj/structure/flora/rock/jungle = 1, /obj/structure/flora/junglebush = 1, /obj/structure/flora/junglebush/b = 1, /obj/structure/flora/junglebush/c = 1, /obj/structure/flora/junglebush/large = 1, /obj/structure/flora/rock/pile/largejungle = 1)
	loose_flora = list(/obj/structure/flora/grass/jungle = 3,/obj/structure/flora/grass/jungle/b = 2,/obj/structure/flora/ausbushes = 2,/obj/structure/flora/ausbushes/leafybush = 1,/obj/structure/flora/ausbushes/sparsegrass = 1,/obj/structure/flora/ausbushes/fullgrass = 1,/obj/structure/herb/explosive_shrooms = 0.1,/obj/structure/flytrap = 0.1,/obj/structure/herb/fruit = 0.2)
	loose_flora_density = 15
	fauna_density = 0.65
	this_area = /area/jungleland/proper

/datum/biome/junglestation/jungle_heavy
	turf_type = /turf/open/floor/plating/dirt/jungleland/jungle
	closed_turf = /turf/open/floor/plating/dirt/jungleland/jungle
	cellular_noise_map_id = HIGH_DENSITY
	dense_flora = list(/obj/structure/flora/tree/jungle/small = 2,/obj/structure/flora/tree/jungle = 2, /obj/structure/flora/rock/jungle = 1, /obj/structure/flora/junglebush = 1, /obj/structure/flora/junglebush/b = 1, /obj/structure/flora/junglebush/c = 1, /obj/structure/flora/junglebush/large = 1, /obj/structure/flora/rock/pile/largejungle = 1)
	loose_flora = list(/obj/structure/flora/grass/jungle = 3,/obj/structure/flora/grass/jungle/b = 2,/obj/structure/flora/ausbushes = 2,/obj/structure/flora/ausbushes/leafybush = 1,/obj/structure/flora/ausbushes/sparsegrass = 1,/obj/structure/flora/ausbushes/fullgrass = 1,/obj/structure/herb/explosive_shrooms = 0.1,/obj/structure/flytrap = 0.1,/obj/structure/herb/fruit = 0.2)
	loose_flora_density = 60
	fauna_density = 0.65
	this_area = /area/jungleland/proper
