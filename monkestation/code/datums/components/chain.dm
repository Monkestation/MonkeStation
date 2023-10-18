
/*
This component attaches to things that'll follow another object
Like connecting a person to a wheelchair so they get dragged behind it
*/
/datum/component/chain
	//The thing the parent will follow
	var/atom/movable/attachment_point

	var/atom/movable/owner
	var/max_dist
	var/equal_force

	var/datum/beam/tether_beam

/datum/component/chain/Initialize(target, max_dist=3, equal_force = TRUE, draw_beam = TRUE)
	if(!ismovableatom(parent) || !ismovableatom(target))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	attachment_point = target
	src.max_dist = max_dist
	src.equal_force = equal_force

	if(draw_beam)
		tether_beam = owner.Beam(target, "usb_cable_beam", 'icons/obj/wiremod.dmi', maxdistance = max_dist+1)

	RegisterSignal(target, COMSIG_MOVABLE_PRE_MOVE, .proc/on_attachment_move)
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, .proc/on_parent_move)
	RegisterSignal(owner, COMSIG_ATOM_ATTACK_HAND, .proc/on_parent_touched)
	RegisterSignal(owner, COMSIG_ATOM_TOOL_ACT(TOOL_WIRECUTTER), .proc/on_parent_wirecutters)

	if(draw_beam)
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/on_atom_moved)
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/on_atom_moved)

/datum/component/chain/Destroy(force, silent)
	. = ..()
	if(tether_beam)
		qdel(tether_beam)
		tether_beam = null
	owner = null
	attachment_point = null

/datum/component/chain/proc/on_atom_moved(atom/movable/mover, old_loc, movement_dir, forced, old_locs, momentum_change)
	SIGNAL_HANDLER

	spawn(0)
		tether_beam.recalculate()

/datum/component/chain/proc/on_attachment_move(atom/movable/mover, newloc)
	SIGNAL_HANDLER

	if(!owner)
		qdel(src)
		return

	var/dist = get_dist(owner,newloc)
	if(dist < max_dist)
		return

	if(!owner.anchored)
		owner.Move(get_step_towards(owner,mover))

	if(isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.Knockdown(1 SECONDS)

	if(dist > max_dist)
		owner.visible_message("<span class='notice'>The tether snaps!</span>")
		qdel(src)
		return

/datum/component/chain/proc/on_parent_move(atom/movable/mover, newloc)
	SIGNAL_HANDLER

	if(!attachment_point)
		qdel(src)
		return

	var/dist = get_dist(attachment_point,newloc)
	if(dist < max_dist)
		return

	if(dist > max_dist)
		qdel(src)
		return

	if(attachment_point.anchored)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

	attachment_point.Move(get_step_towards(attachment_point,mover))

	if(equal_force)
		return

	if(isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.Knockdown(1 SECONDS)
		to_chat(owner,"<span class='notice'>You trip on the tether!</span>")
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/component/chain/proc/on_parent_touched(datum/source, mob/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/untie_parent, user)

/datum/component/chain/proc/untie_parent(mob/user)
	if(user == owner)
		user.visible_message("<span class='notice'>[user] begins untying the cable from \himself.</span>","<span class='notice'>You begin untying the cable from yourself.</span>")
	else
		user.visible_message("<span class='notice'>[user] begins untying the cable from [owner].</span>","<span class='notice'>You begin untying the cable from [owner].</span>")
	if(do_mob(user, owner, 10 SECONDS))
		qdel(src)

/datum/component/chain/proc/on_parent_wirecutters(datum/source, mob/user)
	SIGNAL_HANDLER

	if(user == owner)
		user.visible_message("<span class='notice'>[user] cuts \himself free.</span>","<span class='notice'>You cut yourself free.</span>")
	else
		user.visible_message("<span class='notice'>[user] cuts [owner] free.</span>","<span class='notice'>[user] cuts you free] free.</span>")
	qdel(src)
	return COMPONENT_BLOCK_TOOL_ATTACK
