//Radioactive Anomaly (Radioactive Goo)

/obj/effect/anomaly/radioactive
	name = "Radioactive Anomaly"
	desc = "A highly unstable mass of charged particles leaving waste material in it's wake."
	icon_state = "shield-grey"
	color = "#86c4dd"
	var/active = TRUE

/obj/effect/anomaly/radioactive/Initialize(mapload, new_lifespan)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/anomaly/radioactive/Destroy()
	. = ..()
	RemoveElement(/datum/element/connect_loc)

/obj/effect/anomaly/radioactive/proc/on_entered(datum/source, atom/movable/atom_movable)
	SIGNAL_HANDLER
	if(active && isliving(atom_movable))
		var/mob/living/victim = atom_movable
		active = FALSE
		victim.Paralyze(1 SECONDS)
		var/atom/target = get_edge_target_turf(victim, get_dir(src, get_step_away(victim, src)))
		victim.throw_at(target, 3, 1)
		radiation_pulse(victim, 100)
		to_chat(victim, "<span class='danger'>You're hit with a force of atomic energy!</span>")

/obj/effect/anomaly/radioactive/anomalyEffect(delta_time)
	..()
	active = TRUE
	if(isinspace(src))
		return
	radiation_pulse(src, 50)
	if(!locate(/obj/effect/decal/nuclear_waste) in src.loc)
		playsound(src, pick('sound/misc/desecration-01.ogg','sound/misc/desecration-02.ogg', 'sound/misc/desecration-03.ogg'), 50, 1)
		new /obj/effect/decal/nuclear_waste(src.loc)
		if(prob(25))
			new /obj/effect/decal/nuclear_waste/epicenter(src.loc)

/obj/effect/anomaly/radioactive/detonate()
	playsound(src, 'sound/effects/empulse.ogg', 100, 1)
	radiation_pulse(src, 500)


//Fluid Anomaly (Random Fluid)

#define NORMAL_FLUID_AMOUNT 25
#define DANGEROUS_FLUID_AMOUNT 100

/obj/effect/anomaly/fluid
	name = "Fluidic Anomaly"
	desc = "An anomaly pulling in liquids from places unknown. Better get the mop."
	icon_state = "bluestream_fade"
	var/dangerous = FALSE
	var/list/fluid_choices = list()

/obj/effect/anomaly/fluid/Initialize(mapload, new_lifespan)
	. = ..()
	if(prob(10))
		dangerous = TRUE //Unrestricts the reagent choice and increases fluid amounts

	for(var/i = 1, i <= rand(1,5), i++) //Between 1 and 5 random chemicals
		fluid_choices += dangerous ? get_unrestricted_random_reagent_id() : get_random_reagent_id()

/obj/effect/anomaly/fluid/anomalyEffect(delta_time)
	..()
	if(isinspace(src))
		return
	var/turf/spawn_point = get_turf(src)
	spawn_point.add_liquid(pick(fluid_choices), dangerous ? DANGEROUS_FLUID_AMOUNT : NORMAL_FLUID_AMOUNT, chem_temp = rand(BODYTEMP_COLD_DAMAGE_LIMIT, BODYTEMP_HEAT_DAMAGE_LIMIT))

/obj/effect/anomaly/fluid/detonate()
	if(isinspace(src))
		return
	var/turf/spawn_point = get_turf(src)
	spawn_point.add_liquid(pick(fluid_choices), (dangerous ? DANGEROUS_FLUID_AMOUNT : NORMAL_FLUID_AMOUNT) * 5, chem_temp = rand(BODYTEMP_COLD_DAMAGE_LIMIT, BODYTEMP_HEAT_DAMAGE_LIMIT))

#undef NORMAL_FLUID_AMOUNT
#undef DANGEROUS_FLUID_AMOUNT

//Storm Anomaly (Lightning)

#define STORM_MIN_RANGE 3
#define STORM_MAX_RANGE 5
#define STORM_POWER_LEVEL 1000


/obj/effect/anomaly/storm
	name = "Storm Anomaly"
	desc = "The power of a tesla contained in an anomalous crackling orb."
	icon_state = "electricity2"
	lifespan = 30 SECONDS //Way too strong to give a full 99 seconds.
	var/active = TRUE


/obj/effect/anomaly/storm/Initialize(mapload, new_lifespan)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/anomaly/storm/Destroy()
	. = ..()
	RemoveElement(/datum/element/connect_loc)

/obj/effect/anomaly/storm/proc/on_entered(datum/source, atom/movable/atom_movable)
	SIGNAL_HANDLER

	if(active && iscarbon(atom_movable))
		var/mob/living/carbon/target = atom_movable
		active = FALSE
		target.electrocute_act(10, "[name]", safety=1)
		target.adjustFireLoss(10)

/obj/effect/anomaly/storm/anomalyEffect(delta_time)
	..()
	if(!active) //Only works every other tick
		active = TRUE
		return
	active = FALSE

	tesla_zap(src, rand(STORM_MIN_RANGE, STORM_MAX_RANGE), STORM_POWER_LEVEL)

	if(isinspace(src)) //No clouds in space
		return
	var/turf/location = get_turf(src)
	location.atmos_spawn_air("water_vapor=10;TEMP=320")


#undef STORM_MIN_RANGE
#undef STORM_MAX_RANGE
#undef STORM_POWER_LEVEL

//Vaporous Anomaly (Slippery)

/obj/effect/anomaly/vaporous
	name = "Vaporous Anomaly"
	desc = "An anomalous collection of water vapor streaming out into your station."
	icon_state = "smoke"

//Frost Anomaly (Freezing)

/obj/effect/anomaly/frost
	name = "Chilling Anomaly"
	desc = "A mass of frozen gasses found in this region of space."
	icon_state = "impact_laser_blue"

//Pet Anomaly (Random Pets)

/obj/effect/anomaly/petsplosion
	name = "Lifebringer Anomaly"
	desc = "An odd anomalous gateway that seemingly creates new life out of nowhere."
	icon_state = "bluestream_fade"


//Clown Anomaly (Clowns and Banana Peels)

/obj/effect/anomaly/clown
	name = "Honking Anomaly"
	desc = "An anomaly that smells faintly of bananas and lubricant."
	icon_state = "static"

//Monkey Anomaly (Group of angry monkeys)

/obj/effect/anomaly/monkey
	name = "Screeching Anomaly"
	desc = "An anomalous one-way gateway that leads straight to Monkey Planet"
	icon_state = "bhole3"

