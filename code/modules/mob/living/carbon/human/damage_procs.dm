

/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, cap_loss_at = 0)
	// depending on the species, it will run the corresponding apply_damage code there
	if(stat != DEAD && (damagetype==BRUTE || damagetype==BURN) && damage>10 && prob(10+damage/2))
		INVOKE_ASYNC(src, .proc/emote, "scream")
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, cap_loss_at)

/mob/living/carbon/human/revive(full_heal = 0, admin_revive = 0)
	if(..())
		if(dna && dna.species)
			dna.species.spec_revival(src)
