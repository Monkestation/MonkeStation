///ATOM PROCS

/*
These are for byonds native particle system as they are limited to a single object instance
this creates dummy objects to store the particles in useful for objects that have multiple
particles like bonfires.
*/

/atom
	var/obj/effect/abstract/particle_holder/master_holder


/atom/proc/add_emitter(obj/emitter/updatee, particle_key, priority)
	if(!priority)
		priority = 100

	priority = clamp(priority, 1, 100)

	if(!particle_key)
		CRASH("add_emitter called without a key ref.")

	if(!master_holder)
		master_holder = new(src.loc)

	var/obj/emitter/new_emitter = new updatee

	new_emitter.layer -= (priority / 1000)
	new_emitter.vis_locs |= src
	master_holder.emitters[particle_key] = new_emitter

/atom/proc/remove_emitter(particle_key)
	if(!particle_key)
		CRASH("remove_emitter called without a key ref.")

	if(!master_holder || !master_holder.emitters[particle_key])
		return
	var/obj/emitter/removed_emitter = master_holder.emitters[particle_key]
	removed_emitter.vis_locs -= src

	master_holder.emitters -= particle_key
	qdel(removed_emitter)
