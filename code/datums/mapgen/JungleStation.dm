#define BIOME_PLAINS "plains"
#define BIOME_JUNGLE "jungle"

/datum/map_generator/junglestation

	var/list/possible_biomes = list(
		BIOME_JUNGLE = list(LOW_HUMIDITY = /datum/biome/junglestation/jungle,
						MED_HUMIDITY = /datum/biome/junglestation/jungle_sparse,
						HIGH_HUMIDITY = /datum/biome/junglestation/jungle_heavy),

		BIOME_PLAINS = list(LOW_HUMIDITY = /datum/biome/junglestation/toxic_pit,
						MED_HUMIDITY = /datum/biome/junglestation/plains,
						HIGH_HUMIDITY = /datum/biome/junglestation/plains)
	)
	///Used to select "zoom" level into the perlin noise, higher numbers result in slower transitions
	var/perlin_zoom = 65

	var/list/cellular_preferences = list(
		LOW_DENSITY = list(
			WORLEY_REG_SIZE = 1,
			WORLEY_THRESHOLD = 2.5,
			WORLEY_NODE_PER_REG = 75),

		MED_DENSITY = list(
			CA_INITIAL_CLOSED_CHANCE = 45,
			CA_SMOOTHING_INTERATIONS = 20,
			CA_BIRTH_LIMIT = 4,
			CA_DEATH_LIMIT = 3),

		HIGH_DENSITY = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 5.5,
			WORLEY_NODE_PER_REG = 25)
		)

	var/list/ore_preferences = list(
		ORE_EMPTY = list(
			WORLEY_REG_SIZE = 40,
			WORLEY_THRESHOLD = 25,
			WORLEY_NODE_PER_REG = 50),

		ORE_IRON = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_URANIUM = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_TITANIUM = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_PLASMA = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_GOLD = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_SILVER = list(
			WORLEY_REG_SIZE = 15,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10),

		ORE_DILITHIUM = list(
			WORLEY_REG_SIZE = 3,
			WORLEY_THRESHOLD = 1,
			WORLEY_NODE_PER_REG = 10)

		)
//creates a 2d map of every single ore vein on the map
/datum/map_generator/junglestation/proc/generate_ores(list/turfs)
	var/list/ore_strings = list(
		ORE_DILITHIUM  = rustg_worley_generate("[ore_preferences[ORE_DILITHIUM][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_DILITHIUM][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_DILITHIUM][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),

		ORE_PLASMA  = rustg_worley_generate("[ore_preferences[ORE_PLASMA][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_PLASMA][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_PLASMA][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_GOLD  = rustg_worley_generate("[ore_preferences[ORE_GOLD][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_GOLD][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_GOLD][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_URANIUM  = rustg_worley_generate("[ore_preferences[ORE_URANIUM][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_URANIUM][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_URANIUM][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_TITANIUM  = rustg_worley_generate("[ore_preferences[ORE_TITANIUM][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_TITANIUM][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_TITANIUM][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_SILVER  = rustg_worley_generate("[ore_preferences[ORE_SILVER][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_SILVER][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_SILVER][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_IRON  = rustg_worley_generate("[ore_preferences[ORE_IRON][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_IRON][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_IRON][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"),
		ORE_EMPTY  = rustg_worley_generate("[ore_preferences[ORE_EMPTY][WORLEY_REG_SIZE]]",
										"[ore_preferences[ORE_EMPTY][WORLEY_THRESHOLD]]",
										"[ore_preferences[ORE_EMPTY][WORLEY_NODE_PER_REG]]",
										"[world.maxx]",
										"1",
										"2"))
	//order of generation, ordered from most common to rarest
	var/list/generation_queue = list(
		ORE_EMPTY,
		ORE_IRON,
		ORE_SILVER,
		ORE_TITANIUM,
		ORE_URANIUM,
		ORE_GOLD,
		ORE_PLASMA,
		ORE_DILITHIUM
	)
	var/return_list[world.maxx * world.maxy]


	for(var/t in turfs)
		var/turf/gen_turf = t
		var/generated = FALSE
		for(var/ore in generation_queue)
			if(ore_strings[ore][world.maxx * (gen_turf.y - 1) + gen_turf.x] == "1")
				continue
			return_list[world.maxx * (gen_turf.y - 1) + gen_turf.x] = ore
			generated = TRUE
			break

		if(!generated)
			return_list[world.maxx * (gen_turf.y - 1) + gen_turf.x] = ORE_EMPTY

		CHECK_TICK

	return return_list

/datum/map_generator/junglestation/generate_terrain(list/turfs)
	var/start_time = REALTIMEOFDAY
	var/list/ore_map = generate_ores(turfs)



	var/toxic_seed = rand(0, 50000)
	var/humid_seed = rand(0, 50000)
	var/list/density_strings = list()
	density_strings[LOW_DENSITY] = rustg_worley_generate("[cellular_preferences[LOW_DENSITY][WORLEY_REG_SIZE]]",
								 				"[cellular_preferences[LOW_DENSITY][WORLEY_THRESHOLD]]",
												"[cellular_preferences[LOW_DENSITY][WORLEY_NODE_PER_REG]]",
												"[world.maxx]",
												"1",
												"2")

	density_strings[MED_DENSITY] = rustg_cnoise_generate("[cellular_preferences[MED_DENSITY][CA_INITIAL_CLOSED_CHANCE]]",
									 			"[cellular_preferences[MED_DENSITY][CA_SMOOTHING_INTERATIONS]]",
												"[cellular_preferences[MED_DENSITY][CA_BIRTH_LIMIT]]",
												"[cellular_preferences[MED_DENSITY][CA_DEATH_LIMIT]]",
												"[world.maxx]",
												"[world.maxy]")

	density_strings[HIGH_DENSITY] = rustg_worley_generate("[cellular_preferences[HIGH_DENSITY][WORLEY_REG_SIZE]]",
								 				"[cellular_preferences[HIGH_DENSITY][WORLEY_THRESHOLD]]",
												"[cellular_preferences[HIGH_DENSITY][WORLEY_NODE_PER_REG]]",
												"[world.maxx]",
												"1",
												"2")
	var/plains_string = rustg_dbp_generate("[toxic_seed]","60","75","[world.maxx]","-0.05","1.1")
	var/list/jungle_strings = list()
	jungle_strings[HIGH_HUMIDITY] = rustg_dbp_generate("[humid_seed]","60","75","[world.maxx]","-0.1","1.1")
	jungle_strings[MED_HUMIDITY] = rustg_dbp_generate("[humid_seed]","60","75","[world.maxx]","-0.3","-0.1")

	for(var/t in turfs) //Go through all the turfs and generate them
		var/turf/gen_turf = t
		var/plains_pick = text2num(plains_string[world.maxx * (gen_turf.y - 1) + gen_turf.x]) ? BIOME_PLAINS : BIOME_JUNGLE

		var/jungle_pick = text2num(jungle_strings[HIGH_HUMIDITY][world.maxx * (gen_turf.y - 1) + gen_turf.x]) ? HIGH_HUMIDITY : text2num(jungle_strings[MED_HUMIDITY][world.maxx * (gen_turf.y - 1) + gen_turf.x]) ? MED_HUMIDITY : LOW_HUMIDITY

		var/datum/biome/junglestation/selected_biome = possible_biomes[plains_pick][jungle_pick]

		selected_biome = SSmapping.biomes[selected_biome] //Get the instance of this biome from SSmapping
		var/turf/GT = selected_biome.generate_turf(gen_turf,density_strings)
		if(istype(GT,/turf/open/floor/plating/dirt/jungleland))
			var/turf/open/floor/plating/dirt/jungleland/J = GT
			J.ore_present = ore_map[world.maxx * (gen_turf.y - 1) + gen_turf.x]
		var/area/jungleland/jungle_area = selected_biome.this_area
		var/area/old_area = GT.loc
		old_area.contents -= GT
		jungle_area.contents += GT
		GT.change_area(old_area,jungle_area)
		CHECK_TICK

	for(var/biome in subtypesof(/datum/biome/junglestation))
		var/datum/biome/junglestation/selected_biome = SSmapping.biomes[biome]
		selected_biome.this_area.reg_in_areas_in_z()

	var/message = "Jungle land finished in [(REALTIMEOFDAY - start_time)/10]s!"
	to_chat(world, "<span class='boldannounce'>[message]</span>")
	log_world(message)
