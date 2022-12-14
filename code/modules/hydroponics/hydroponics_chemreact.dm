/**
 *This is NOW the gradual affects that each chemical applies on every process() proc. Nutrients now use a more robust reagent holder in order to apply less insane
 * stat changes as opposed to 271 lines of individual statline effects. Shoutout to the original comments on chems, I just cleaned a few up.
 */
/obj/machinery/hydroponics/proc/apply_chemicals(mob/user)
	///Contains the reagents within the tray.
	if(myseed)
		myseed.on_chem_reaction(reagents) //In case seeds have some special interactions with special chems, currently only used by vines
	for(var/c in reagents.reagent_list)
		var/datum/reagent/chem = c
		chem.on_hydroponics_apply(myseed, reagents, src, user)


/obj/machinery/hydroponics/proc/mutation_roll(mob/user)
	switch(rand(100))
		if(91 to 100)
			adjust_plant_health(-10)
			visible_message(span_warning("\The [myseed.plantname] starts to wilt and burn!"))
			return
		if(21 to 40)
			visible_message(span_notice("\The [myseed.plantname] appears unusually reactive..."))
			return
		if(11 to 20)
			mutateweed()
			return
		if(0 to 10)
			mutatepest(user)
			return

/obj/machinery/hydroponics/proc/mutate(lifemut = 2, endmut = 5, productmut = 1, yieldmut = 2, potmut = 25, wrmut = 2, wcmut = 5, traitmut = 0) // Mutates the current seed
	if(!myseed)
		return
	myseed.mutate(lifemut, endmut, productmut, yieldmut, potmut, wrmut, wcmut, traitmut)

/obj/machinery/hydroponics/proc/hardmutate()
	mutate(4, 10, 2, 4, 50, 4, 10, 3)


/obj/machinery/hydroponics/proc/mutatespecie() // Mutagent produced a new plant!
	if(!myseed || dead)
		return

	var/oldPlantName = myseed.plantname
	if(myseed.mutatelist.len > 0)
		var/mutantseed = pick(myseed.mutatelist)
		qdel(myseed)
		myseed = null
		myseed = new mutantseed
	else
		return

	hardmutate()
	age = 0
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0 // Reset

	var/message = "<span class='warning'>[oldPlantName] suddenly mutates into [myseed.plantname]!</span>"
	addtimer(CALLBACK(src, .proc/after_mutation, message), 0.5 SECONDS)


/obj/machinery/hydroponics/proc/mutateweed() // If the weeds gets the mutagent instead. Mind you, this pretty much destroys the old plant
	if( weedlevel > 5 )
		if(myseed)
			qdel(myseed)
			myseed = null
		var/newWeed = pick(/obj/item/seeds/liberty, /obj/item/seeds/angel, /obj/item/seeds/nettle/death, /obj/item/seeds/kudzu)
		myseed = new newWeed
		dead = 0
		hardmutate()
		age = 0
		plant_health = myseed.endurance
		lastcycle = world.time
		harvest = 0
		weedlevel = 0 // Reset

		var/message = "<span class='warning'>The mutated weeds in [src] spawn some [myseed.plantname]!</span>"
		addtimer(CALLBACK(src, .proc/after_mutation, message), 0.5 SECONDS)
	else
		to_chat(usr, "<span class='warning'>The few weeds in [src] seem to react, but only for a moment...</span>")

/obj/machinery/hydroponics/proc/mutatepest(mob/user)
	if(pestlevel > 5)
		message_admins("[ADMIN_LOOKUPFLW(user)] caused spiderling pests to spawn in a hydro tray")
		log_game("[key_name(user)] caused spiderling pests to spawn in a hydro tray")
		visible_message("<span class='warning'>The pests seem to behave oddly...</span>")
		spawn_atom_to_turf(/obj/structure/spider/spiderling/hunter, src, 3, FALSE)
	else
		to_chat(user, "<span class='warning'>The pests seem to behave oddly, but quickly settle down...</span>")

//Called after plant mutation, update the appearance of the tray content and send a visible_message()
/obj/machinery/hydroponics/proc/after_mutation(message)
	update_icon()
	visible_message(message)


/// Tray Setters - The following procs adjust the tray or plants variables, and make sure that the stat doesn't go out of bounds.///
/obj/machinery/hydroponics/proc/adjust_plant_nutriments(adjustamt)
	reagents.remove_any(adjustamt)

/obj/machinery/hydroponics/proc/adjust_waterlevel(adjust_amount)
	if(self_sustaining)
		return
	waterlevel = CLAMP(waterlevel + adjust_amount, 0, maxwater)
	if(adjust_amount>0)
		adjust_toxic(-round(adjust_amount/4))//Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.

/obj/machinery/hydroponics/proc/adjust_plant_health(adjust_amount)
	if(self_sustaining)
		return
	if(myseed && !dead)
		plant_health = CLAMP(plant_health + adjust_amount, 0, myseed.endurance)

/obj/machinery/hydroponics/proc/adjust_toxic(adjust_amount)
	if(self_sustaining)
		return
	toxic = CLAMP(toxic + adjust_amount, 0, 100)

/obj/machinery/hydroponics/proc/adjust_pestlevel(adjust_amount)
	if(self_sustaining)
		return
	pestlevel = CLAMP(pestlevel + adjust_amount, 0, 10)

/obj/machinery/hydroponics/proc/adjust_weedlevel(adjust_amount)
	if(self_sustaining)
		return
	weedlevel = CLAMP(weedlevel + adjust_amount, 0, 10)
