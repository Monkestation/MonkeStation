/mob/living/simple_animal/hostile/alien_mimic/tier3/surging
	name = "surging mimic"
	real_name = "surging mimic"
	// icon_state = "voltaic"
	// icon_living = "voltaic"
	hivemind_modifier = "surging"
	melee_damage = 7
	secondary_damage_type = BURN
	playstyle_string = "<span class='big bold'>You are a surging mimic,</span></b> you can teleport, shocking everyone in your path.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/pointed/mimic/surge,
		/obj/effect/proc_holder/spell/self/mimic/emp
	)

//Abilities
/obj/effect/proc_holder/spell/pointed/mimic/surge
	name = "Surge"
	desc = "surge yourself in a direction, dealing massive damage to wherever you hit"
	charge_max = 45 SECONDS
	var/shock_damage = 15

/obj/effect/proc_holder/spell/pointed/mimic/surge/cast(list/targets,mob/user = usr)
	. = ..()
	if(.)
		return

	for(var/target in targets)
		var/turflist = get_line(user, get_turf(target))
		surge(user, turflist)
		user.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
		do_teleport(user,target)
		return
	revert_cast(user)

/obj/effect/proc_holder/spell/pointed/mimic/surge/can_cast(mob/living/simple_animal/hostile/alien_mimic/tier3/surging/user = usr)
	if(istype(user) && user.disguised)
		to_chat(user, "<span class='danger'>You cannot use this while disguised!</span>")
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/pointed/mimic/surge/proc/surge(mob/user, turflist)
	for(var/turf/current_turf in turflist)
		for(var/mob/living/victim in current_turf)
			victim.Knockdown(3 SECONDS)
			victim.electrocute_act(shock_damage, user)



