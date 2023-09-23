/mob/living/simple_animal/hostile/alien_mimic/tier3/necromantic
	name = "necromantic mimic"
	real_name = "necromantic mimic"
	melee_damage = 7
	secondary_damage_type = BRUTE
	hivemind_modifier = "necromantic"
	playstyle_string = "<span class='big bold'>You are a necromantic mimic,</span></b> you can make minds control corpses.</b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/pointed/mimic/necromancy
	)

/obj/effect/proc_holder/spell/pointed/mimic/necromancy
	name = "Raise Dead"
	desc = "Raise a corpse as a minion. <b>WARNING:</b> if you move too far from a raised corpse, it will die."
	charge_max = 45 SECONDS

/obj/effect/proc_holder/spell/pointed/mimic/necromancy/cast(list/targets,mob/user = usr)
	. = ..()
	if(.)
		return

	for(var/mob/living/target in targets)
		if(HAS_TRAIT(target, TRAIT_HUSK))
			to_chat(user,"<span class='notice'>Their corpse is too damaged to raise!</span>")
			revert_cast(user)
			return

		if(target.stat != DEAD)
			to_chat(user,"<span class='notice'>They aren't dead!</span>")
			revert_cast(user)
			return

		to_chat(user,"<span class='notice'>You start summoning a ghost to overtake the corpse!</span>")
		var/list/candidates = list()
		candidates = pollGhostCandidates("Would you like to become [target] (raised by necromantic mimic).", poll_time = 10 SECONDS)

		if(!LAZYLEN(candidates))
			to_chat(user,"<span class='notice'>No ghosts took control of the corpse!</span>")
			revert_cast(user)
			return

		to_chat(user,"<span class='notice'>A ghost has taken control of the corpse!</span>")

		var/mob/dead/observer/chosen_candidate = pick(candidates)
		target.key = chosen_candidate.key

		to_chat(target,"<span class='notice big'>You have been summoned by a necromantic mimic</span><span class='notice'> if you stray too far from your summoner, <b>you will die!</b></span>")

		target.revive(TRUE)
		target.AddComponent(/datum/component/distance_bound, user, 15, TRUE)
		target.add_emitter(/obj/emitter/mimic/necro_summon,"necro_summon")
		target.remove_all_languages()
		target.copy_languages(user)
		RegisterSignal(target, COMSIG_MOB_DEATH, .proc/unsummon)
		return
	revert_cast(user)

/obj/effect/proc_holder/spell/pointed/mimic/necromancy/proc/unsummon(mob/target)
	SIGNAL_HANDLER

	UnregisterSignal(target, COMSIG_MOB_DEATH)

	target.language_holder = null
	target.update_atom_languages()

	target.remove_emitter("necro_summon")

/obj/emitter/mimic/necro_summon
	particles = new/particles/mimic/necro_summon

/particles/mimic/necro_summon
	width = 124
	height = 124
	count = 128
	spawning = 10
	lifespan = 0.5 SECONDS
	fade = 0.2 SECONDS
	position = generator("box", list(-10,10), list(10,20), UNIFORM_RAND)
	velocity = generator("circle", -5, 5, NORMAL_RAND)
	friction = 0.15
	color = "#9b319b"
