/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD
	held_state = "chick"
	gender = FEMALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps.")
	emote_see = list("pecks at the ground.","flaps its tiny wings.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pecks"
	attacktext = "pecks"
	health = 3
	maxHealth = 3
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"

	do_footstep = TRUE

	///How close to being an adult is this chicken
	var/amount_grown = 0
	///What type of chicken is this?
	var/grown_type
	///Glass chicken exclusive:what reagent were the eggs filled with?
	var/list/glass_egg_reagent = list()
	///Stone Chicken Exclusive: what ore type is in the eggs?
	var/obj/item/stack/ore/production_type = null
	/// list of friends inherited by parent
	var/list/friends = list()

/mob/living/simple_animal/chick/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.total_chickens++

/mob/living/simple_animal/chick/Life()
	. =..()
	if(!.)
		return
	if(!stat && !ckey)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			var/mob/living/simple_animal/chicken/new_chicken = new grown_type(src.loc)
			new_chicken.Friends = src.friends
			new_chicken.age += rand(1,10) //add a bit of age to each chicken causing staggered deaths
			if(istype(new_chicken, /mob/living/simple_animal/chicken/glass))
				for(var/list_item in glass_egg_reagent)
					new_chicken.glass_egg_reagents.Add(list_item)

			if(istype(new_chicken, /mob/living/simple_animal/chicken/stone))
				if(production_type)
					new_chicken.production_type = production_type
			qdel(src)

/mob/living/simple_animal/chick/death(gibbed)
	friends = null
	GLOB.total_chickens--
	..()

/mob/living/simple_animal/chick/Destroy()
	friends = null
	if(stat != DEAD)
		GLOB.total_chickens--
	return ..()

/mob/living/simple_animal/chick/holo/Life()
	..()
	amount_grown = 0

/mob/living/simple_animal/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	gender = FEMALE
	health = 15
	maxHealth = 15
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)

	icon_state = "chicken_white"
	icon_living = "chicken_white"
	icon_dead = "chicken_white_dead"
	head_icon = 'icons/mob/pets_held_large.dmi'
	held_state = "chicken_white"

	speak_chance = 2
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.")

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicks"

	density = FALSE
	turns_per_move = 3
	butcher_results = list(/obj/item/food/meat/slab/chicken = 2)
	ventcrawler = VENTCRAWLER_ALWAYS
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"
	mobchatspan = "stationengineer"

	do_footstep = TRUE


/mob/living/simple_animal/chicken/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.total_chickens++
	chicken_type = src

	if(prob(40))
		gender = MALE

	if(gender == MALE)
		if(breed_name_male)
			name = " [breed_name_male]"
		else
			name = "[breed_name] Rooster"
	else
		if(breed_name_female)
			name = " [breed_name_female]"
		else
			name = "[breed_name] Hen"

/mob/living/simple_animal/chicken/death(gibbed)
	Friends = null
	GLOB.total_chickens--
	..()

/mob/living/simple_animal/chicken/Destroy()
	Friends = null
	if(stat != DEAD)
		GLOB.total_chickens--
	return ..()

/mob/living/simple_animal/chicken/attack_hand(mob/living/carbon/human/user)
	..()
	if(user.a_intent == "help")
		set_friendship(user, 0.1)

/mob/living/simple_animal/chicken/attackby(obj/item/given_item, mob/user, params)
	if(istype(given_item, /obj/item/food)) //feedin' dem chickens
		if(!stat && current_feed_amount <= 3 )
			feed_food(given_item, user)
			set_friendship(user, 1)
		else
			var/turf/vomited_turf = get_turf(src)
			vomited_turf.add_vomit_floor(src, VOMIT_TOXIC)
			to_chat(user, "<span class='warning'>[name] can't keep the food down, it vomits all over the floor!</span>")
			happiness -= 15
			current_feed_amount -= 3
	else
		..()

/mob/living/simple_animal/chicken/proc/set_friendship(new_friend, amount = 1)
	if(!Friends[new_friend])
		Friends[new_friend] = 0
	Friends[new_friend] += amount

/mob/living/simple_animal/chicken/proc/feed_food(obj/item/given_item, mob/user)
	for(var/datum/reagent/reagent in given_item.reagents.reagent_list)
		if(reagent in happy_chems && max_happiness_per_generation >= (happy_chems[reagent] * reagent.volume))
			happiness += happy_chems[reagent] * reagent.volume
			max_happiness_per_generation -= happy_chems[reagent] * reagent.volume
		if(!(reagent in consumed_reagents))
			consumed_reagents.Add(reagent)

	if(!(given_item in consumed_food))
		consumed_food.Add(given_item)

	if(given_item.type in liked_foods && max_happiness_per_generation >= 10)
		happiness += 10
		max_happiness_per_generation -= 10

	var/obj/item/food/placeholder_food_item = given_item
	for(var/food_type in placeholder_food_item.foodtypes)
		if(food_type in disliked_food_types)
			happiness -= 10
	if(user)
		var/feedmsg = "[user] feeds [given_item] to [name]! [pick(feedMessages)]"
		user.visible_message(feedmsg)

	qdel(given_item)
	eggs_left += rand(0, 2)
	current_feed_amount ++
	total_times_eaten ++

/mob/living/simple_animal/chicken/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, list/message_mods = list())
	. = ..()
	if(speaker != src && !radio_freq && !stat)
		if (speaker in Friends)
			speech_buffer = list()
			speech_buffer += speaker
			speech_buffer += lowertext(html_decode(message))

/mob/living/simple_animal/chicken/proc/handle_speech()
	if (speech_buffer.len > 0)
		var/who = speech_buffer[1] // Who said it?
		var/phrase = speech_buffer[2] // What did they say?
		if (findtext(phrase, "chickens")) // Talking to us
			if(findtext(phrase, "follow"))
				if (ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER])
					if(Friends[who] > Friends[ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER]]) // following you bby
						ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER] = who
						ai_controller.queue_behavior(/datum/ai_behavior/follow_leader)
				else
					if (Friends[who] >= CHICKEN_FRIENDSHIP_FOLLOW)
						ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER] = who
						ai_controller.queue_behavior(/datum/ai_behavior/follow_leader)

			else if (findtext(phrase, "stop"))
				ai_controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = null

			else if (findtext(phrase, "stay"))
				if(ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER] == who)
					AIStatus = AI_STATUS_ON
					ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER] = null
					SSmove_manager.stop_looping(src)

			else if (findtext(phrase, "attack"))
				if (Friends[who] >= CHICKEN_FRIENDSHIP_ATTACK)
					for (var/mob/living/target in view(7,src)-list(src,who))
						if (findtext(phrase, lowertext(target.name)))
							if (istype(target, /mob/living/simple_animal/chicken))
								return
							else if((!Friends[target] || Friends[target] < 1))
								if(ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER])
									ai_controller.blackboard[BB_CHICKEN_CURRENT_LEADER] = null
								ai_controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = target
						break
		speech_buffer = list()

/mob/living/simple_animal/chicken/Life()
	. =..()
	if(!.)
		return

	handle_speech()

	if(COOLDOWN_FINISHED(src, age_cooldown))
		COOLDOWN_START(src, age_cooldown, age_speed)
		age ++

	if(age > 100)
		src.death()

	var/animal_count = 0
	for(var/mob/living/simple_animal/animals in view(1, src))
		animal_count ++
	if(animal_count >= overcrowding)
		happiness --

	if(current_feed_amount == 0)
		happiness -= 0.1 ///lose happiness really slowly

	if(happiness < minimum_living_happiness)
		src.death()

	if(!stat && prob(3) && current_feed_amount > 0)
		current_feed_amount --
		if(current_feed_amount == 0)
			var/list/users = get_hearers_in_view(4, src.loc)
			for(var/mob/living/carbon/human/user in users)
				user.visible_message("[src] starts pecking at the floor, it must be hungry.")

	if((!stat && prob(3) && eggs_left > 0) && egg_type && GLOB.total_chickens < CONFIG_GET(number/max_chickens) && gender == FEMALE)
		ready_to_lay = TRUE

	if(ready_to_lay == TRUE)
		if(!movement_target || !(src in viewers(3, movement_target.loc)))
			movement_target = null
			stop_automated_movement = 0
			for(var/obj/structure/nestbox/nesting_box in view(3, src))
				movement_target = nesting_box
				break
		if(movement_target)
			stop_automated_movement = 1
			step_to(src, movement_target)

		if(!Adjacent(movement_target)) //can't reach box through windows.
			return

		if(src.loc == movement_target.loc)

			visible_message("[src] [pick(layMessage)]")

			eggs_left--
			var/obj/item/food/egg/layed_egg
			//Need to have eaten 5 times in order to have a chance at getting mutations
			if(src.total_times_eaten > 4 && prob(25))
				var/list/real_mutation = list()
				for(var/raw_list_item in src.mutation_list)
					var/datum/mutation/ranching/chicken/mutation = new raw_list_item
					real_mutation |= mutation
				if(real_mutation.len)
					var/datum/mutation/ranching/chicken/picked_mutation = pick(real_mutation)
					layed_egg = new picked_mutation.egg_type(get_turf(src))
					layed_egg.possible_mutations |= picked_mutation
				else
					layed_egg = new egg_type(get_turf(src))
			else
				layed_egg = new egg_type(get_turf(src))

			layed_egg.Friends = src.Friends
			layed_egg.layer_hen_type = src.chicken_type
			layed_egg.happiness = src.happiness
			layed_egg.consumed_food = src.consumed_food
			layed_egg.consumed_reagents = src.consumed_reagents
			layed_egg.pixel_x = rand(-6,6)
			layed_egg.pixel_y = rand(-6,6)

			if(glass_egg_reagents)
				layed_egg.food_reagents = glass_egg_reagents

			if(production_type)
				layed_egg.production_type = production_type

			if(eggs_fertile)
				if(prob(25) || layed_egg.possible_mutations.len) //25
					START_PROCESSING(SSobj, layed_egg)
			ready_to_lay = FALSE
			stop_automated_movement = 0

/obj/item/food/egg/process(delta_time)
	amount_grown += rand(4,8) * delta_time
	if(amount_grown >= 200)
		pre_hatch()

/obj/item/food/egg/proc/pre_hatch()
	var/list/final_mutations = list()
	var/failed_mutations = FALSE
	for(var/datum/mutation/ranching/chicken/mutation in possible_mutations)
		if(cycle_requirements(mutation))
			final_mutations |= mutation
		else
			desc = "Huh it seems like nothing is coming out of this one, maybe it needed something else?"
			failed_mutations = TRUE
	hatch(final_mutations, failed_mutations)

/obj/item/food/egg/proc/hatch(list/possible_mutations, failed_mutations)
	STOP_PROCESSING(SSobj, src)
	if(failed_mutations)
		return
	var/mob/living/simple_animal/chick/birthed = new /mob/living/simple_animal/chick(get_turf(src))

	if(possible_mutations.len)
		var/datum/mutation/ranching/chicken/chosen_mutation = pick(possible_mutations)
		birthed.grown_type = chosen_mutation.chicken_type
		if(chosen_mutation.nearby_items.len)
			absorbed_required_items(chosen_mutation.nearby_items)
	else
		birthed.grown_type = layer_hen_type.chicken_path

	if(birthed.grown_type == /mob/living/simple_animal/chicken/glass)
		for(var/list_item in src.reagents.reagent_list)
			birthed.glass_egg_reagent.Add(list_item)

	if(birthed.grown_type == /mob/living/simple_animal/chicken/stone)
		birthed.production_type = src.production_type

	visible_message("[src] hatches with a quiet cracking sound.")
	qdel(src)

/obj/item/food/egg/proc/absorbed_required_items(list/required_items)
	for(var/item in required_items)
		var/obj/item/removal_item = item
		var/obj/item/temp = locate(removal_item) in view(3, src.loc)
		if(temp)
			visible_message("[src] absorbs the nearby [temp.name] into itself.")
			qdel(temp)

/mob/living/simple_animal/chicken/turkey
	name = "\improper turkey"
	desc = "it's that time again."
	icon_state = "turkey_plain"
	icon_living = "turkey_plain"
	icon_dead = "turkey_plain_dead"
	speak = list("Gobble!","GOBBLE GOBBLE GOBBLE!","Cluck.")
	speak_emote = list("clucks","gobbles")
	emote_hear = list("gobbles.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.")
	density = FALSE
	health = 15
	maxHealth = 15
	attacktext = "pecks"
	attack_sound = 'sound/creatures/turkey.ogg'
	ventcrawler = VENTCRAWLER_ALWAYS
	feedMessages = list("It gobbles up the food voraciously.","It clucks happily.")
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"
	breed_name_male = "Turkey"
	breed_name_female = "Turkey"
