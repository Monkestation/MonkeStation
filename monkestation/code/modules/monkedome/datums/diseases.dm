//i tried to base it off of actual malaria
/datum/disease/malaria
	name = "Malaria Exotica"
	agent = "Plasmodium Exotica"
	cure_text = "Quinine, Synaptizine or Tonic water"
	max_stages = 8 // yes 8 fucking stages
	danger = DISEASE_HARMFUL
	disease_flags = CURABLE
	visibility_flags = HIDDEN_SCANNER
	spread_flags = DISEASE_SPREAD_BLOOD
	needs_all_cures = FALSE
	cures = list(/datum/reagent/quinine, /datum/reagent/medicine/synaptizine,/datum/reagent/consumable/tonic)
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

	var/next_stage_time = 0
	var/time_per_stage = 2 MINUTES //around 16 minutes till this reaches lethality

/datum/disease/malaria/infect(mob/living/infectee, make_copy)
	next_stage_time = world.time + time_per_stage
	return ..()

/datum/disease/malaria/stage_act()
	//we handle curing and stuff ourselves
	var/cure = has_cure()

	if(cure)
		if(prob(20))
			update_stage(stage - 1)
		if(stage == 0)
			cure()
		return

	if( world.time >= next_stage_time)
		update_stage(clamp(stage + 1,0,max_stages))
		next_stage_time = world.time + time_per_stage + rand(-(time_per_stage * 0.25), time_per_stage * 0.25)

	switch(stage)
		if(1) //asymptomatic for some time
			return
		if(2)
			visibility_flags = NONE
			affected_mob.adjust_bodytemperature(30, 0, BODYTEMP_HEAT_DAMAGE_LIMIT - 1) //slowly rising fever that is no lethal *yet*
			if(prob(10))
				to_chat(affected_mob, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))

			if(prob(40))
				to_chat(affected_mob, span_warning("[pick("You feel dizzy.", "Your head spins.")]"))
			return
		if(3)
			affected_mob.blood_volume -= 0.5
			affected_mob.adjust_bodytemperature(50, 0, BODYTEMP_HEAT_DAMAGE_LIMIT - 1) //fast rising not deadly fever
			if(prob(20))
				to_chat(affected_mob, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))

			if(prob(40))
				if(prob(50))
					to_chat(affected_mob, span_warning("[pick("You feel dizzy.", "Your head spins.")]"))
				else
					to_chat(affected_mob, span_userdanger("A wave of dizziness washes over you!"))
					affected_mob.Dizzy(5)

			if(prob(10))
				affected_mob.Jitter(5)
				if(prob(30))
					to_chat(affected_mob, span_warning("[pick("Your head hurts.", "Your head pounds.")]"))

			if(prob(30))
				affected_mob.emote("cough")

			return
		if(4) //another period of asymptomaticity before shit really hits the fan
			affected_mob.blood_volume -= 0.25
			return

		if(5) // a few more minutes before disease really becomes deadly
			danger = DISEASE_DANGEROUS
			affected_mob.blood_volume -= 0.75
			affected_mob.adjust_bodytemperature(30) //slowly rising fever that can become deadly
			if(prob(30))
				to_chat(affected_mob, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))

			if(prob(60))
				if(prob(40))
					to_chat(affected_mob, span_warning("[pick("You feel dizzy.", "Your head spins.")]"))
				else
					to_chat(affected_mob, span_userdanger("A wave of dizziness washes over you!"))
					affected_mob.Dizzy(5)

			if(prob(15))
				affected_mob.Jitter(5)
				if(prob(30))
					if(prob(50))
						to_chat(affected_mob, span_warning("[pick("Your head hurts.", "Your head pounds.")]"))
					else
						to_chat(affected_mob, span_warning("[pick("Your head hurts a lot.", "Your head pounds incessantly.")]"))
						affected_mob.adjustStaminaLoss(25)

			if(prob(40))
				affected_mob.emote("cough")

			return

		if(6) //another period of lower deadliness
			affected_mob.blood_volume -= 0.25
			if(prob(40))
				affected_mob.emote("cough")
			return
		if(7)
			affected_mob.blood_volume -= 1
			affected_mob.adjust_bodytemperature(35)
			if(prob(30))
				to_chat(affected_mob, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))


			if(prob(40))
				affected_mob.emote("cough")

			if(prob(15))
				affected_mob.Jitter(5)
				if(prob(60))
					if(prob(30))
						to_chat(affected_mob, span_warning("[pick("Your head hurts.", "Your head pounds.")]"))
					else
						to_chat(affected_mob, span_warning("[pick("Your head hurts a lot.", "Your head pounds incessantly.")]"))
						affected_mob.adjustStaminaLoss(25)

			if(prob(10))
				affected_mob.adjustStaminaLoss(20)
				to_chat(affected_mob, span_warning("[pick("You feel weak.", "Your body feel numb.")]"))
			return
		if(8)
			affected_mob.blood_volume -= 2
			affected_mob.adjust_bodytemperature(75) //a deadly fever
			if(prob(40))
				to_chat(affected_mob, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))

			if(prob(70))
				if(prob(30))
					to_chat(affected_mob, span_warning("[pick("You feel dizzy.", "Your head spins.")]"))
				else
					to_chat(affected_mob, span_userdanger("A wave of dizziness washes over you!"))
					affected_mob.Dizzy(5)

			if(prob(50))
				affected_mob.emote("cough")

			if(prob(20))
				affected_mob.Jitter(5)
				if(prob(50))
					to_chat(affected_mob, span_warning("[pick("Your head hurts a lot.", "Your head pounds incessantly.")]"))
					affected_mob.adjustStaminaLoss(25)
				else
					to_chat(affected_mob, span_userdanger("[pick("Your head hurts!", "You feel a burning knife inside your brain!", "A wave of pain fills your head!")]"))
					affected_mob.Stun(35)

			if(prob(25))
				affected_mob.adjustStaminaLoss(50)
				to_chat(affected_mob, span_warning("[pick("You feel very weak.", "Your body feel completely numb.")]"))
			return
		else
			return

	//instead of it being chance based, malaria is based on time
