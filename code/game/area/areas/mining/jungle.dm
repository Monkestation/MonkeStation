/// Basetype both for all jungle areas.
/area/jungle
	name = "Jungle Planetoid"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	sound_environment = SOUND_AREA_JUNGLE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	outdoors = TRUE

/// Ruins and Monsters begin spawning here
/area/jungle/generated
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/jungle_generator

/// Ditto + Megafauna.
/area/jungle/generated/megafauna
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/// Used for more mountainous or cavernous sections of map.
/area/jungle/cave
	name = "Jungle Cave System"

/// Ruins + Monsters spawn here
/area/jungle/cave/generated
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/jungle

/// Ditto + Megafauna.
/area/jungle/cave/generated/megafauna
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED
