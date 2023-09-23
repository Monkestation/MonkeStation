/obj/item/autosurgeon/neuromod/track
	name = "track neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/track)

/obj/item/organ/cyberimp/neuromod/targeted/track
	name = "Track"
	desc = "This neuromod allows you to mark a target, and gain information through them."
	cooldown = 10 SECONDS
	cast_message = "You look around for people to track. Click on a target."
	cancel_message = "You ease up."
	max_distance = 3
	var/mob/living/tracking
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/track/ui_action_click()
	if(tracking)
		var/choice = input(owner,"What do you want to do with your target?","Track Neuromod") in list("Watch","Communicate","Direction","Remove Tracker")
		track(choice)
	else
		..()

/obj/item/organ/cyberimp/neuromod/targeted/track/activate(target)
	if(!isliving(target))
		return

	var/mob/living/living_target = target

	..()
	owner.visible_message("<span class='notice'>A small black orb flies from [owner] into [target]'s shadow</span>",	\
						"<span class='notice'>You start tracking [living_target].</span>",vision_distance = 3)

	tracking = living_target

/obj/item/organ/cyberimp/neuromod/targeted/track/proc/track(choice)
	switch(choice)
		if("View")
			owner.reset_perspective(tracking)
			addtimer(CALLBACK(owner, /mob/living.proc/reset_perspective, owner), 10 SECONDS)
		if("Communicate")
			var/message = stripped_input(owner, "Enter a message to send to your target.","Communicate")
			if(!message)
				return
			to_chat(tracking, "<span class='notice'>You hear a voice behind you say \"[message]\"</span>")
			to_chat(owner, "<span class='notice'>You whisper \"<b>[message]</b>\" into the air.</span>")
		if("Direction")
			var/direction_text = "[dir2text(get_dir(owner, tracking))]"
			if(direction_text)
				to_chat(owner,"<span class='notice'>You feel [tracking] <b>[direction_text]</b> of you.</span>")
		if("Cancel Tracking")
			to_chat(tracking, "<span class='notice'>You stop tracking [tracking].</span>")
			tracking = null

