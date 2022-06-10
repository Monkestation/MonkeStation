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

/obj/effect/anomaly/fluid
	name = "Fluidic Anomaly"
	desc = "An anomaly pulling in liquids from places unknown. Better get the mop."
	icon_state = "bluestream_fade"

//Storm Anomaly (Lightning)

/obj/effect/anomaly/storm
	name = "Storm Anomaly"
	desc = "An unstable mass of crackling electrical energy."
	icon_state = "electricity2"

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

