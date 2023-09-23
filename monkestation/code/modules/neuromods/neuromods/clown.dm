/obj/item/autosurgeon/neuromod/clown
	uses = 1
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/clown)

/obj/item/autosurgeon/neuromod/clown/attack_self(mob/user)
	if(!uses)
		return
	if(user.mind.assigned_role != "Clown")
		to_chat(user, "<span class='danger'>The Honkmother does not deem you funny enough to accept her blessing.</span>")
		user.throw_at(get_edge_target_turf(user,pick(GLOB.alldirs)),rand(1,10),rand(1,10),force=rand(MOVE_FORCE_EXTREMELY_WEAK,MOVE_FORCE_OVERPOWERING))
		return
	to_chat(user, "<span class='notice'>You accept the Honkmother's boon.</span>")
	..()

/obj/item/autosurgeon/neuromod/clown
	name = "clown neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/clown)

/obj/item/organ/cyberimp/neuromod/targeted/clown
	name = "Honkmother's Blessing"
	desc = "This neuromod allows you to be very silly."
	cast_message = "<span class='notice'>You call upon the Honkmother. Click on a target.</span>"
	cancel_message = "<span class='notice'>The clownish power leaves your body for now.</span>"
	max_distance = -1
	cooldown = 1 MINUTES
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bike_horn"
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/clown/activate(target)
	owner.visible_message("<span class='danger'>A clownish aura rises off of [owner].</span>")
	playsound(get_turf(target),'sound/items/airhorn.ogg', 100, 1)
	if(isliving(target))
		living_roll(owner,target)
	else if(isturf(target))
		turf_roll(owner,target)
	else
		return
	..()

/obj/item/organ/cyberimp/neuromod/targeted/clown/proc/living_roll(mob/living/user, mob/living/target,value)
	if(!istype(target))
		return
	if(target.stat == DEAD)
		to_chat(target,"<span class='danger'>You can't clown on dead people!</span>")
		return
	switch(rand(1,10))
		if(1) //Launch
			target.throw_at(get_edge_target_turf(target,pick(GLOB.alldirs)),rand(1,10),rand(1,10),force=rand(MOVE_FORCE_EXTREMELY_WEAK,MOVE_FORCE_OVERPOWERING))
		if(2) //Stun
			target.Stun(rand(1 SECONDS, 10 SECONDS))
			target.Knockdown(rand(1 SECONDS, 10 SECONDS))
		if(3) //A little Zap :)
			target.electrocute_act(rand(1,20),user)
			to_chat(target,"<span class='danger'>Clownish power runs through your veins.</span>")
		if(4) //Position Swap
			var/turf/user_turf = get_turf(user)
			var/turf/target_turf = get_turf(target)
			do_teleport(user,target_turf)
			do_teleport(target,user_turf)
		if(5) //Turf Roll on the target's turf
			turf_roll(user,get_turf(target))
		if(6) //Backfire
			living_roll(target,user)
			to_chat(target,"<span class='danger'>You feel clownish magic bounce off of you.</span>")
			to_chat(user,"<span class='danger'>Your magic backfires!</span>")
		if(7) //Out of body experience
			if(target.mind)
				to_chat(target,"<span class='userdanger'>A powerful honk temporarily knocks you out of your body.</span>")
				target.ghostize()
				addtimer(CALLBACK(src, .proc/unghost, target), rand(3 SECONDS, 10 SECONDS))
		if(8) //I love having stamina!
			target.apply_damage(rand(10,100),STAMINA)
		if(9) //Species Change
			target.set_species(pick(subtypesof(/datum/species) - list(/datum/species/zombie/infectious,/datum/species/zombie/infectious/fast,/datum/species/human/supersoldier,/datum/species/debug)))
		if(10) //:)
			target.emote("fart")

/obj/item/organ/cyberimp/neuromod/targeted/clown/proc/turf_roll(mob/living/user,turf/target_turf)
	if(!istype(target_turf))
		return

	switch(rand(1,5))
		if(1) //Teleport
			do_teleport(user,target_turf)
		if(2) //AoE living roll - High risk since every person has a chance to backfire
			for(var/mob/living/possible_target in view(rand(4,7)))
				if(possible_target.stat != DEAD)
					living_roll(user,possible_target)
		if(3) //Foam up the place
			new /obj/effect/particle_effect/foam(target_turf)
		if(4) //Smoke up the place
			new /obj/effect/particle_effect/smoke(target_turf)
		if(5) //Pull field
			for(var/mob/living/possible_target in view(9))
				possible_target.safe_throw_at(target_turf,4,4,force=MOVE_FORCE_STRONG)

/obj/item/organ/cyberimp/neuromod/targeted/clown/proc/unghost(mob/living/target)
	target.grab_ghost()
