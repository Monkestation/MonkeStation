/datum/component/distance_bound
	dupe_mode = COMPONENT_DUPE_ALLOWED

	var/mob/living/target //Who to follow
	var/max_dist
	var/kill_on_distance
	var/kill_on_target_death

/datum/component/distance_bound/Initialize(target, max_dist, kill_on_distance = FALSE, kill_on_target_death = TRUE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isliving(target))
		return COMPONENT_INCOMPATIBLE

	src.target = target
	src.max_dist = max_dist
	src.kill_on_distance = kill_on_distance
	src.kill_on_target_death = kill_on_target_death

	START_PROCESSING(SSdcs, src)

/datum/component/distance_bound/process(delta_time)
	var/mob/living/owner = parent

	var/distance = get_dist(owner,target)

	if(distance > max_dist)
		if(kill_on_distance)
			to_chat(owner,"<span class='danger'>You're too far away, your soul tears itself apart!</span>")
			owner.death()
			qdel(src)
		else
			owner.forceMove(target.loc)
		return

	if(QDELETED(target) || target.stat == DEAD)
		if(kill_on_target_death)
			to_chat(owner,"<span class='danger'>Your link to the world is lost, your soul tears itself apart!</span>")
			owner.death()
		qdel(src)
		return

	if(QDELETED(owner) || owner.stat == DEAD)
		qdel(src)
		return

/datum/component/distance_bound/Destroy()
	STOP_PROCESSING(SSdcs, src)
	return ..()
