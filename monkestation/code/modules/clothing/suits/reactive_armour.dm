//Honk armor
/obj/item/clothing/suit/armor/reactive/honk
	name = "reactive honk armor"
	desc = "An experimental suit of armor that honks violently."
	reactivearmor_cooldown_duration = 100

/obj/item/clothing/suit/armor/reactive/honk/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The horn is still recharging!</span>")
			return FALSE
		playsound(get_turf(owner),'sound/items/bikehorn.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] honks, converting the attack into a violent honk!</span>")
		var/turf/owner_turf = get_turf(owner)
		owner.Paralyze(30)
		for(var/mob/living/carbon/target_atom as mob in ohearers(7, owner_turf))
			target_atom.Paralyze(60)


		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE


/obj/item/clothing/suit/armor/reactive/honk/emp_act()
	if(active)
		playsound(get_turf(src),'sound/items/bikehorn.ogg', 100, 1)
		src.visible_message("<span class='danger'>[src] malfunctions, and honks extra hard!</span>")
		for(var/mob/living/carbon/target_atom as mob in hearers(7, get_turf(src))) //Includes the person wearing it
			target_atom.Paralyze(rand(50,200)) //Honk! (randomly between 5-20 seconds) :)
	return

//Mutation Armour
/obj/item/clothing/suit/armor/reactive/mutation
	name = "reactive mutation armor"
	desc = "An experimental suit of armor that gives off radioactive waves."
	reactivearmor_cooldown_duration = 200

/obj/item/clothing/suit/armor/reactive/mutation/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The armour is still recharging!</span>")
			return FALSE
		playsound(get_turf(owner),'sound/effects/empulse.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], sending out mutating waves of radiation!</span>")
		var/turf/owner_turf = get_turf(owner)

		for(var/mob/living/carbon/target_atom as mob in oviewers(7, owner_turf))
			if(target_atom.dna && !HAS_TRAIT(target_atom, TRAIT_RADIMMUNE))
				give_rand_mut(target_atom)
				target_atom.rad_act(40)

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/mutation/proc/remove_mutation(var/mob/living/carbon/mutation_holder, var/datum/mutation/selected_mutation)
	mutation_holder.dna.remove_mutation(selected_mutation)

/obj/item/clothing/suit/armor/reactive/mutation/proc/give_rand_mut(var/mob/living/carbon/recipient)
	var/list/possible_mutations = GLOB.all_mutations - GLOB.all_mutations[RACEMUT] //Monkey can't be unmutated like this :( (though I wouldn't be against letting monkey stay in anyway just to be funny)
	var/datum/mutation/chosen_mutation = pick(possible_mutations)
	recipient.dna.add_mutation(chosen_mutation)
	addtimer(CALLBACK(src, .proc/remove_mutation, recipient, chosen_mutation), 60 SECONDS)

/obj/item/clothing/suit/armor/reactive/mutation/emp_act()
	if(active)
		reactivearmor_cooldown = world.time + 1000
		src.visible_message("<span class='danger'>[src] malfunctions, and emits an extra strong wave!</span>")
		playsound(get_turf(src),'sound/effects/empulse.ogg', 100, 1)
		for(var/mob/living/carbon/target_atom as mob in viewers(7, get_turf(src))) //Includes the wearer
			if(target_atom.dna && !HAS_TRAIT(target_atom, TRAIT_RADIMMUNE))
				give_rand_mut(target_atom) //More mutations more Funny
				give_rand_mut(target_atom)
				give_rand_mut(target_atom)
				target_atom.rad_act(200)
	return

//Walter Armour
/obj/item/clothing/suit/armor/reactive/walter
	name = "reactive walter armor"
	desc = "An experimental suit of armor that gives off walter-ish vibes."
	hit_reaction_chance = 10 //Less Walter Spam

/obj/item/clothing/suit/armor/reactive/walter/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The walter fabricator is still recharging!</span>")
			return FALSE
		playsound(get_turf(owner),'sound/magic/summonitems_generic.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], turning it into walter!</span>")
		var/turf/owner_turf = get_turf(owner)
		new /mob/living/simple_animal/pet/dog/bullterrier/walter(owner_turf) //Walter

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/walter/emp_act()
	src.visible_message("<span class='danger'>[src] malfunctions, and walter appears!</span>")
	if(prob(50)) //50% chance for either a big walter are a few little walters
		var/mob/living/summoned_walter = new /mob/living/simple_animal/pet/dog/bullterrier/walter(get_turf(src))
		summoned_walter.resize = 3
		summoned_walter.update_transform()
	else
		for(var/i in 1 to rand(3,5))
			new /mob/living/simple_animal/pet/dog/bullterrier/walter/smallter(get_turf(src))
	return
