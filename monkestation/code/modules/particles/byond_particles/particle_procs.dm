///ATOM PROCS

/*
These are for byonds native particle system as they are limited to a single object instance
this creates dummy objects to store the particles in useful for objects that have multiple
particles like bonfires.
*/

/atom
	var/list/particle_refs = null

/atom/proc/update_or_add_particles(particles/updatee, particle_key, added_appearance_flags, force = FALSE, layer = null)
	if(!particle_key)
		CRASH("update_or_add_particles called without a key ref.")

	LAZYINITLIST(particle_refs)
	///holder variable if it doesn't exist it will soon
	var/obj/particle_holder/holder
	holder = particle_refs[particle_key]

	if(!holder && updatee)
		holder = new /obj/particle_holder

	else if(!holder)
		return

	if(!force && holder.particles == updatee) //Not forced, and they are the same? ignore it
		return

	if(!isnull(layer))
		holder.layer = layer

	holder.particles = updatee
	holder.vis_locs |= src
	particle_refs[particle_key] = holder
	holder.appearance_flags |= added_appearance_flags

/atom/proc/remove_specific_particle(particle_key)
	if(!particle_key)
		CRASH("remove_specific_particle was called without a proper particle key.")

	if(!particle_refs)
		return //can't remove something we don't have

	var/obj/particle_holder/holder = particle_refs[particle_key]
	holder?.vis_locs = null
	qdel(holder)
	particle_refs -= particle_key

/atom/proc/remove_all_particles()
	if(!particle_refs)
		return //can't remove something we don't have

	for(var/particle as anything in particle_refs)
		var/obj/particle_object = particle_refs[particle]

		if(!particle_object)
			continue

		particle_object.vis_locs = null
		particle_object.particles = null

		qdel(particle_object)

/atom/proc/return_particles(particle_key)
	RETURN_TYPE(/particles)

	if(!particle_key)
		CRASH("called return particles without a particle key!")

	if(!particle_refs)
		return /// no point scanning a list thats empty for something

	var/obj/particle_object = particle_refs[particle_key]

	return particle_object?.particles
