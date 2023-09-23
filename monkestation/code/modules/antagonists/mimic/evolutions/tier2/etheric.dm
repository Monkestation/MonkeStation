/mob/living/simple_animal/hostile/alien_mimic/tier2/etheric
	name = "etheric mimic"
	real_name = "etheric mimic"
	// icon_state = "etheric"
	// icon_living = "etheric"
	melee_damage = 7
	secondary_damage_type = TOX
	hivemind_modifier = "etheric"
	playstyle_string = "<span class='big bold'>You are an etheric mimic,</span></b> you deal poison damage and can temporarily summon another mimic.</b>"
	possible_evolutions = list(
		"plentiful - summon 2 clones instead of 1" = /mob/living/simple_animal/hostile/alien_mimic/tier3/plentiful,
		"infesting - summon weaker clones that explode into poisonous clouds" = /mob/living/simple_animal/hostile/alien_mimic/tier3/infesting
	)
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/clone_request
	)


// Mimic Clone
/mob/living/simple_animal/hostile/alien_mimic/etheric_clone
	name = "etheric mimic"
	real_name = "etheric mimic"
	can_evolve = FALSE
	// icon_state = "etheric"
	// icon_living = "etheric"
	melee_damage = 7
	secondary_damage_type = TOX
	hivemind_modifier = "etheric"
	playstyle_string = "<span class='big bold'>You are an etheric mimic clone,</span></b> you can summon yourself or be summoned temporarily.</b>"
	var/mob/living/simple_animal/hostile/alien_mimic/tier2/etheric/origin_mimic
	var/summoned = FALSE

/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/Life()
	if(origin_mimic.stat == DEAD)
		qdel(src)

// Abilities
/obj/effect/proc_holder/spell/self/mimic/clone
	name = "Clone"
	desc = "Temporarily split into two mimics."
	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_icon_state = "warp"
	charge_max = 90 SECONDS
	var/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/clone_mimic

/obj/effect/proc_holder/spell/self/mimic/clone/cast(mob/user)
	. = ..()
	if(.)
		return

	clone_mimic.forceMove(get_turf(user))
	clone_mimic.summoned = FALSE
	user.visible_message("<span class='danger'>A second mimic falls out of [user]</span>")

	addtimer(CALLBACK(src, .proc/unsummon_mimic, user), 45 SECONDS)

/obj/effect/proc_holder/spell/self/mimic/clone/proc/unsummon_mimic(mob/user)
	clone_mimic.forceMove(user)
	clone_mimic.visible_message("<span class='danger'>[clone_mimic] disappears into thin air!</span>")
	clone_mimic.revive(TRUE)
	clone_mimic.grab_ghost()
	clone_mimic.summoned = FALSE


/obj/effect/proc_holder/spell/self/mimic/clone_request
	name = "Request Clone"
	desc = "Request a ghost to become your clone."
	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_icon_state = "warp"
	charge_max = 30 SECONDS
	//The type of mimic that gets summoned
	var/mimic_type = /mob/living/simple_animal/hostile/alien_mimic/etheric_clone
	var/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/clone_mimic

/obj/effect/proc_holder/spell/self/mimic/clone_request/cast(mob/user)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/hostile/alien_mimic/mimic_user = user

	var/list/possible_clones = list()
	possible_clones = pollGhostCandidates("A mimic ([user.real_name]) is looking for a player to become their clone.")

	if(LAZYLEN(possible_clones))
		var/mob/dead/observer/picked_clone = pick(possible_clones)

		clone_mimic = new mimic_type(user)
		clone_mimic.origin_mimic = user
		clone_mimic.name = "etheric mimic"
		clone_mimic.real_name = user.real_name + "'s clone"
		clone_mimic.toggle_ai(AI_OFF)
		clone_mimic.mimic_team = mimic_user.mimic_team

		clone_mimic.key = picked_clone.key
		to_chat(user, "<span class='notice'>You created a clone!</span>")

		var/obj/effect/proc_holder/spell/self/mimic/clone/clone = new
		user.AddSpell(clone)
		clone.clone_mimic = clone_mimic
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You were unable to summon a clone, try again later!</span>")

