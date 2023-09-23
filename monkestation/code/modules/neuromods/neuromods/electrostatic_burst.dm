/obj/item/autosurgeon/neuromod/electrostatic_burst
	name = "electrostatic burst neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/electrostatic_burst)

/obj/item/organ/cyberimp/neuromod/targeted/electrostatic_burst
	name = "Electrostatic Burst"
	desc = "This neuromod allows you to emit a focused burst of electricity."
	cast_message = "<span class='notice'>You feel electricity under your skin. Click on a target area.</span>"
	cancel_message = "<span class='notice'>The electricity calms.</span>"
	max_distance = 9
	cooldown = 80 SECONDS
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/electrostatic_burst/activate(target)
	..()
	var/turf/target_turf = get_turf(target)
	to_chat(owner,"<span class='notice'>Sparks appear in the air as you focus on an area.</span")
	zap(target_turf)

/obj/item/organ/cyberimp/neuromod/targeted/electrostatic_burst/proc/zap(atom/target_turf)
	for(var/mob/living/possible_target in view(4,target_turf))
		if(HAS_TRAIT(possible_target, TRAIT_SHOCKIMMUNE))
			continue
		if(possible_target == owner)
			continue
		target_turf.Beam(possible_target, icon_state="lightning[rand(1,12)]", time=5, maxdistance = 32)
		if(possible_target.electrocute_act(15, owner, 1, SHOCK_NOSTUN))
			if(iscarbon(possible_target))
				var/mob/living/carbon/carbon_target = possible_target
				carbon_target.Stun(5 SECONDS)
				carbon_target.Knockdown(rand(6 SECONDS, 8 SECONDS))
		to_chat(possible_target,"<span class='danger'>A ball of electricity appears from [owner.name] and zaps you!</span>")
