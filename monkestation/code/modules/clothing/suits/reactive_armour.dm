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
	reactivearmor_cooldown_duration = 300

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

//Walter Armour
/obj/item/clothing/suit/armor/reactive/glacial
	name = "reactive glacial armor"
	desc = "An experimental suit of armor that chills the air around it."

/obj/item/clothing/suit/armor/reactive/glacial/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The walter fabricator is still recharging!</span>")
			return FALSE
		playsound(get_turf(src),'sound/effects/empulse.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], sending out an icy blast!</span>")
		var/turf/owner_turf = get_turf(owner)
		for(var/mob/living/carbon/target_atom as mob in oviewers(7, owner_turf))
			var/freezing_power = 50
			freezing_power -= (5*get_dist(owner_turf,target_atom))
			target_atom.adjust_bodytemperature(-freezing_power) //freezes less from further away

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/glacial/emp_act()
	for(var/mob/living/carbon/target_atom as mob in viewers(7, get_turf(src)))
		var/freezing_power = rand(1,100) //:) I love EMPS :)
		if(freezing_power<30)
			src.visible_message("<span class='danger'>[src] malfunctions, letting out an cold breeze.</span>")
		else if(freezing_power<60)
			src.visible_message("<span class='danger'>[src] malfunctions, chilling the air around it.</span>")
		else
			src.visible_message("<span class='danger'>[src] malfunctions, forming ice in the air around you.</span>")
		freezing_power -= (5*get_dist(get_turf(src),target_atom))
		target_atom.adjust_bodytemperature(-freezing_power)
	return

//Monkey Armour
/obj/item/clothing/suit/armor/reactive/primal
	name = "reactive primal armor"
	desc = "An experimental suit of armor that echoes the screeches of past monkeys."
	reactivearmor_cooldown_duration = 3 MINUTES //Big Cooldown
	hit_reaction_chance = 10 //Low monkey chance

/obj/item/clothing/suit/armor/reactive/primal/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The monkey generator is still recharging!</span>")
			return FALSE
		playsound(get_turf(src),'sound/creatures/monkey/monkey_screech_1.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], and screeches with the voices of a million monkeys!</span>")
		return_to_monkey(owner)

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/primal/proc/return_to_monkey(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/simple_animal/pet/new_gorilla = new /mob/living/simple_animal/hostile/gorilla/rabid(get_turf(user))
	user.forceMove(new_gorilla)
	user.mind.transfer_to(new_gorilla)
	ADD_TRAIT(user, TRAIT_NOBREATH, type) //so they dont suffocate while inside the gorilla
	addtimer(CALLBACK(src, .proc/become_human, new_gorilla), 10 SECONDS) //10 seconds should be enough time to realize you are monkey and fuck someone up without being able to pwn a whole group

/obj/item/clothing/suit/armor/reactive/primal/proc/become_human(mob/living/affected_mob)
	var/mob/living/carbon/human/human_mob = locate() in affected_mob
	affected_mob.mind.transfer_to(human_mob)
	human_mob.grab_ghost()
	human_mob.forceMove(get_turf(affected_mob))
	REMOVE_TRAIT(human_mob, TRAIT_NOBREATH, type)
	qdel(affected_mob)

/obj/item/clothing/suit/armor/reactive/primal/emp_act()
	return

//Petsplosion Armour
/obj/item/clothing/suit/armor/reactive/herd
	name = "reactive herd armor"
	desc = "An experimental suit of armor that creates groups of animals."
	var/list/current_herd = list()
	reactivearmor_cooldown_duration = 90 SECONDS
/obj/item/clothing/suit/armor/reactive/herd/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The animal generator is still recharging!</span>")
			return FALSE
		playsound(get_turf(src),'sound/effects/empulse.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], and summons a herd of animals!</span>")
		var/turf/owner_turf = get_turf(owner)
		become_animal(owner)
		for(var/i in 1 to rand(7,10)) //Summon the disguise herd
			var/mob/living/simple_animal/pet/new_animal = pick(/mob/living/simple_animal/pet/dog/corgi,/mob/living/simple_animal/pet/dog/pug,/mob/living/simple_animal/pet/dog/bullterrier,/mob/living/simple_animal/pet/fox,/mob/living/simple_animal/pet/cat/kitten,/mob/living/simple_animal/pet/cat)
			new_animal = new new_animal(owner_turf)
			current_herd += new_animal

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/herd/proc/become_animal(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/simple_animal/pet/chosen_animal = pick(/mob/living/simple_animal/pet/dog/corgi,/mob/living/simple_animal/pet/dog/pug,/mob/living/simple_animal/pet/dog/bullterrier,/mob/living/simple_animal/pet/fox,/mob/living/simple_animal/pet/cat/kitten,/mob/living/simple_animal/pet/cat)
	chosen_animal = new chosen_animal(get_turf(user))
	user.forceMove(chosen_animal)
	user.mind.transfer_to(chosen_animal)
	ADD_TRAIT(user, TRAIT_NOBREATH, type) //so they dont suffocate while inside the animal
	addtimer(CALLBACK(src, .proc/end_herd, chosen_animal), 30 SECONDS)

/obj/item/clothing/suit/armor/reactive/herd/proc/end_herd(mob/living/affected_mob)
	var/mob/living/carbon/human/human_mob = locate() in affected_mob
	affected_mob.mind.transfer_to(human_mob)
	human_mob.grab_ghost()
	human_mob.forceMove(get_turf(affected_mob))
	REMOVE_TRAIT(human_mob, TRAIT_NOBREATH, type)
	qdel(affected_mob)

	for(var/mob/living/herd_animal in current_herd)
		current_herd -= herd_animal
		qdel(herd_animal)

/obj/item/clothing/suit/armor/reactive/herd/emp_act()
	return

//Fluidic Armour
/obj/item/clothing/suit/armor/reactive/wet
	name = "reactive wet armor"
	desc = "An experimental suit of armor that's a little more damp than usual."
	reactivearmor_cooldown_duration = 2 MINUTES
	var/static/list/random_liquid_list = list(
		/datum/reagent/water = 60,
		/datum/reagent/blood = 45,
		/datum/reagent/consumable/ethanol/beer = 30,
		/datum/reagent/lube = 5,
		/datum/reagent/lube/superlube = 1,
		)

/obj/item/clothing/suit/armor/reactive/wet/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The liquid generator is still recharging!</span>")
			return FALSE
		playsound(get_turf(src),'sound/effects/empulse.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], and drips a ton of liquid!</span>")
		var/turf/owner_turf = get_turf(owner)
		var/datum/reagent/random_liquid = pickweight(random_liquid_list)
		owner_turf.add_liquid(random_liquid, rand(50,100))

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/wet/emp_act()
	if(world.time < reactivearmor_cooldown) //I think we Really don't want liquid spam at all
		var/datum/reagent/random_liquid = pick(random_liquid_list) //unweighted pick :)
		var/turf/owner_turf = get_turf(src)
		owner_turf.add_liquid(random_liquid, rand(100,300))
		reactivearmor_cooldown = world.time + 4 MINUTES
	return
