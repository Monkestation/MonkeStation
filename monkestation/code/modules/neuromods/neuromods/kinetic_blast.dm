/obj/item/autosurgeon/neuromod/kinetic_blast
	name = "kinetic blast neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/kinetic_blast)

/obj/item/organ/cyberimp/neuromod/kinetic_blast
	name = "Kinetic Blast"
	desc = "This neuromod blasts nearby people and objects away."
	icon_state = "kinetic_blast"
	cooldown = 30 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/kinetic_blast/ui_action_click()
	. = ..()
	if(.)
		return
	owner.add_emitter(/obj/emitter/mimic/kinetic_blast,"kinetic_blast",burst_mode=TRUE)
	playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, 1)
	owner.visible_message("<span class='danger'>[owner] sends out a wave of dark energy, knocking everything around!</span>","<span class='danger'>You activate the neuromod, pushing everything away!</span>")
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/to_throw as mob|obj in orange(7, owner_turf))
		if(to_throw.anchored || thrown_items[to_throw])
			continue
		var/throwtarget = get_edge_target_turf(owner_turf, get_dir(owner_turf, get_step_away(to_throw, owner_turf)))
		to_throw.safe_throw_at(throwtarget, 10, 1, force = MOVE_FORCE_EXTREMELY_STRONG)
		thrown_items[to_throw] = to_throw

/obj/emitter/mimic/kinetic_blast
	particles = new/particles/mimic/kinetic_blast

/particles/mimic/kinetic_blast
	width = 124
	height = 124
	count = 128
	spawning = SPAWN_ALL_PARTICLES_INSTANTLY
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	position = generator("box", list(-20,-20), list(20,20), NORMAL_RAND)
	velocity = generator("circle", -25, 25, NORMAL_RAND)
	friction = 0.25
	color = generator("color", "#630a63", "#bd0aa5", NORMAL_RAND)
