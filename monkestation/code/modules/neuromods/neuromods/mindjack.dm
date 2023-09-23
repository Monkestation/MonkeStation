/obj/item/autosurgeon/neuromod/mindjack
	name = "mindjack neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/targeted/mindjack)

/obj/item/organ/cyberimp/neuromod/targeted/mindjack
	name = "Mindjack"
	desc = "This neuromod allows you to temporarily command other beings."
	icon_state = "mindjack"
	cast_message = "<span class='notice'>You feel your presence grow. Click on a target area.</span>"
	cancel_message = "<span class='notice'>You ease up.</span>"
	max_distance = 9
	cooldown = 3 MINUTES
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/targeted/mindjack/activate(target)
	//The cooldown is done in this order + resets so that you can't stock up on a bunch of mindcontrol
	//while also not scamming the user out of a use if they cancel midway through
	..()

	if(!isliving(target) || target == owner)
		COOLDOWN_RESET(src, neuromod_cooldown)
		return
	var/command = stripped_input(owner, "Enter the command for your target to follow.","Enter command")

	if(!command)
		COOLDOWN_RESET(src, neuromod_cooldown)
		return

	owner.visible_message("<span class='danger'>[owner] stares intently at [target] as a dark mist flies off of [owner.p_them()].</span>","<span class='danger'>A dark aura rises off of you.</span>")
	owner.add_emitter(/obj/emitter/mimic/mindjack,"mindjack")
	if(do_mob(owner,owner,5 SECONDS))
		owner.remove_emitter("mindjack")
		if(get_dist(owner,target) <= max_distance)
			COOLDOWN_RESET(src, neuromod_cooldown)
			return
		to_chat(owner,"<span class='notice'>You send your command directly to your target's brain.</span>")
		mind_control(command,target)
	owner.remove_emitter("mindjack")

/obj/item/organ/cyberimp/neuromod/targeted/mindjack/proc/mind_control(command, mob/living/target)
	to_chat(target, "<span class='userdanger'>Your mind goes blank, and you can only think of a single command...</span>")
	to_chat(target, "<span class='mind_control'>[command]</span>")
	log_admin("[key_name(owner)] used the mindjack neuromod on [key_name(target)]: [command]")
	var/atom/movable/screen/alert/mind_control/mind_alert = target.throw_alert("mind_control", /atom/movable/screen/alert/mind_control)
	mind_alert.command = command
	addtimer(CALLBACK(src, .proc/clear_mind_control, target), 30 SECONDS)

/obj/item/organ/cyberimp/neuromod/targeted/mindjack/proc/clear_mind_control(mob/living/target)
	to_chat(target, "<span class='userdanger'>You feel the compulsion fade, and you <i>completely forget</i> about your previous orders.</span>")
	target.clear_alert("mind_control")

/obj/emitter/mimic/mindjack
	particles = new/particles/mimic/mindjack

/particles/mimic/mindjack
	count = 256
	spawning = 6
	lifespan = 1.5 SECONDS
	fade = 0.7 SECONDS
	gravity = list(0,0.5,0)
	color = generator("color", "#802980", "#cf13b6", NORMAL_RAND)
	position = generator("box", list(-7,7,0), list(7,13,0), NORMAL_RAND)
	velocity = generator("box", list(-1,0,0), list(1,0,0), NORMAL_RAND)
	friction = 0.1
	drift = list(0,0.25,0)
