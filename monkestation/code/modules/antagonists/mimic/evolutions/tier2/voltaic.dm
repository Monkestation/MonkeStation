/mob/living/simple_animal/hostile/alien_mimic/tier2/voltaic
	name = "voltaic mimic"
	real_name = "voltaic mimic"
	// icon_state = "voltaic"
	// icon_living = "voltaic"
	melee_damage = 5
	secondary_damage_type = BURN
	hivemind_modifier = "Voltaic"
	playstyle_string = "<span class='big bold'>You are a voltaic mimic,</span></b> you deal brute and burn damage, stun and electrocute people on hit, and \
						can activate an emp.</b>"
	possible_evolutions = list(
		"surging - dash and zap everyone in your path" = /mob/living/simple_animal/hostile/alien_mimic/tier3/surging,
		"tesla - shock nearby enemies" = /mob/living/simple_animal/hostile/alien_mimic/tier3/tesla
	)
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/emp
	)

/mob/living/simple_animal/hostile/alien_mimic/tier2/voltaic/death(gibbed)
	tesla_zap(src, 5, 4000)
	..()

/mob/living/simple_animal/hostile/alien_mimic/tier2/voltaic/AttackingTarget()
	if(!isliving(target))
		return ..()

	var/mob/living/victim = target
	if(buckled && buckled == victim && HAS_TRAIT(victim, TRAIT_SHOCKIMMUNE))
		victim.Stun(1 SECONDS)
		victim.electrocute_act(1, src)
	..()

/obj/effect/proc_holder/spell/self/mimic/emp
	name = "EMP"
	desc = "Send out electromagnetic pulses, scrambling electronics in the area."
	action_icon_state = "emp"
	charge_max = 2 MINUTES
	sound = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/self/mimic/emp/cast(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return

	playsound(get_turf(user), sound, 50,1)
	empulse(get_turf(user), 2, 4)
	return
