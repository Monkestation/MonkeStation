GLOBAL_LIST_INIT(golem_waves, list(/datum/golem_wave/dormant,
                                   /datum/golem_wave/negligible,
                                   /datum/golem_wave/typical,
                                   /datum/golem_wave/substantial,
                                   /datum/golem_wave/major,
                                   /datum/golem_wave/abnormal,
								   /datum/golem_wave/intense,
								   /datum/golem_wave/insane))

/datum/golem_wave
	var/burrow_count  // Total number of burrows spawned over the course of drilling
	var/burrow_interval  // Number of seconds that pass between each new burrow spawns
	var/golem_spawn  // Number of golems spawned by each burrow on spawn event
	var/spawn_interval  // Number of seconds that pass between spawn events of burrows
	var/special_probability  // Number of spawn events between a Special is spawned
	var/mineral_multiplier  // A multiplier of materials excavated by the drillW

/datum/golem_wave/dormant
	burrow_count = 2
	burrow_interval = 15 SECONDS
	golem_spawn = 2
	spawn_interval = 20 SECONDS
	special_probability = 5
	mineral_multiplier = 1.0

/datum/golem_wave/negligible
	burrow_count = 3
	burrow_interval = 15 SECONDS
	golem_spawn = 2
	spawn_interval = 20 SECONDS
	special_probability = 6
	mineral_multiplier = 1.1

/datum/golem_wave/typical
	burrow_count = 3
	burrow_interval = 12 SECONDS
	golem_spawn = 3
	spawn_interval = 15 SECONDS
	special_probability = 8
	mineral_multiplier = 1.2

/datum/golem_wave/substantial
	burrow_count = 4
	burrow_interval = 12 SECONDS
	golem_spawn = 3
	spawn_interval = 15 SECONDS
	special_probability = 8
	mineral_multiplier = 1.35

/datum/golem_wave/major
	burrow_count = 5
	burrow_interval = 10 SECONDS
	golem_spawn = 4
	spawn_interval = 12 SECONDS
	special_probability = 8
	mineral_multiplier = 1.5

/datum/golem_wave/abnormal
	burrow_count = 7
	burrow_interval = 9 SECONDS
	golem_spawn = 4
	spawn_interval = 10 SECONDS
	special_probability = 15
	mineral_multiplier = 3.0

/datum/golem_wave/intense
	burrow_count = 9
	burrow_interval = 9 SECONDS
	golem_spawn = 4
	spawn_interval = 10 SECONDS
	special_probability = 20
	mineral_multiplier = 5.0

/datum/golem_wave/insane
	burrow_count = 11
	burrow_interval = 5 SECONDS
	golem_spawn = 6
	spawn_interval = 8 SECONDS
	special_probability = 30
	mineral_multiplier = 7.0
