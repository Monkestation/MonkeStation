/mob/living/simple_animal/hostile/alien_mimic/tier3/infesting
	name = "infesting mimic"
	real_name = "infesting mimic"
	// icon_state = "infesting"
	// icon_living = "infesting"
	melee_damage = 10
	secondary_damage_type = TOX
	hivemind_modifier = "infesting"
	playstyle_string = "<span class='big bold'>You are an infesting mimic,</span></b> you can summon weak mimics that drop poison clouds on death.</b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/clone_request/infestation
	)

/mob/living/simple_animal/hostile/alien_mimic/tier3/infesting/death(gibbed)
	. = ..()
	var/datum/effect_system/smoke_spread/chem/smoke = new
	var/turf/user_turf = get_turf(src)

	create_reagents(15)

	reagents.add_reagent(/datum/reagent/toxin/mimic, 15)
	smoke.attach(user_turf)
	smoke.set_up(reagents, rand(3,5), user_turf, silent = TRUE)
	smoke.start()
	visible_message("<span class='danger'>[src] explodes in a could of poisonous gas!</span>")

// Mimic Clone
/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/infesting
	name = "infesting mimic"
	real_name = "infesting mimic"
	melee_damage = 5
	playstyle_string = "<span class='big bold'>You are an infesting mimic clone,</span></b> you can explode in a poisonous gas cloud.</b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/infestation_explode
	)

/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/infesting/death(gibbed)
	. = ..()
	var/datum/effect_system/smoke_spread/chem/smoke = new
	var/turf/user_turf = get_turf(src)

	create_reagents(15)

	reagents.add_reagent(/datum/reagent/toxin/mimic, 15)
	smoke.attach(user_turf)
	smoke.set_up(reagents, rand(3,5), user_turf, silent = TRUE)
	smoke.start()
	visible_message("<span class='danger'>[src] explodes in a could of poisonous gas!</span>")

// Abilities
/obj/effect/proc_holder/spell/self/mimic/infestation_explode
	name = "Self Destruct"
	desc = "Die, spilling poisonous gas everywhere."
	action_icon = 'icons/mob/actions/actions_hive.dmi'
	action_icon_state = "warp"
	charge_max = 10 SECONDS

/obj/effect/proc_holder/spell/self/mimic/infestation_explode/cast(mob/user)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/hostile/alien_mimic/etheric_clone/infesting/mimic_user = user

	if(mimic_user.summoned)
		to_chat(user,"<span class='notice'>You can't self destruct while you aren't summoneed!</span>")
		revert_cast(user)
		return

	for(var/mob/living/victim in range(3,src))
		victim.Knockdown(3 SECONDS)
	user.death()

/obj/effect/proc_holder/spell/self/mimic/clone_request/infestation
	name = "Request Infestation Clone"
	mimic_type = /mob/living/simple_animal/hostile/alien_mimic/etheric_clone/infesting
