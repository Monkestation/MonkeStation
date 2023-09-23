/mob/living/simple_animal/hostile/alien_mimic/tier3/explosive
	name = "explosive mimic"
	real_name = "explosive mimic"
	// icon_state = "thermal"
	// icon_living = "thermal"
	melee_damage = 9
	melee_damage_type = BURN
	maxbodytemp = INFINITY
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	hivemind_modifier = "Explosive"
	playstyle_string = "<span class='big bold'>You are a explosive mimic,</span></b> you can explode, dealing massive damage nearby.</b>"
	absorption_heal = 80
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/explosion
	)

/mob/living/simple_animal/hostile/alien_mimic/tier3/explosive/death(gibbed)
	explosion(get_turf(src),-1,2,5, flame_range = 5)
	..()

/mob/living/simple_animal/hostile/alien_mimic/tier3/explosive/latch(mob/living/target)
	. = ..()
	if(!.)
		return

//Abilities
/obj/effect/proc_holder/spell/self/mimic/explosion
	name = "Explosion"
	desc = "Explode. <b>Warning:</b> Deals 40% of health to the user."
	charge_max = 3 MINUTES

/obj/effect/proc_holder/spell/self/mimic/explosion/cast(mob/user = usr)
	. = ..()
	if(.)
		return

	var/mob/living/simple_animal/hostile/alien_mimic/mimic_user = user

	for(var/mob/living/victim in oview(7))
		explosion(get_turf(user),-1,1,4, flame_range = 3)
		mimic_user.visible_message("<span class='userdanger'>[mimic_user] explodes!</span>")
