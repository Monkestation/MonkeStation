/obj/item/autosurgeon/neuromod/mimic_composition
	name = "mimic composition neuromod"
	starting_organ = list(/obj/item/organ/cyberimp/neuromod/mimic_composition)

/obj/item/organ/cyberimp/neuromod/mimic_composition
	name = "Mimic Composition"
	desc = "This neuromod allows you to ventcrawl and walk through airlocks & grilles."
	icon_state = "mimic_composition"
	cooldown = 2 MINUTES
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/cyberimp/neuromod/mimic_composition/ui_action_click()
	. = ..()
	if(.)
		return

	owner.add_emitter(/obj/emitter/mimic/mimic_composition,"mimic_composition")
	owner.ventcrawler = VENTCRAWLER_ALWAYS
	owner.pass_flags |= PASSGRILLE | PASSDOORS
	owner.alpha /= 2
	to_chat(owner, "<span class='notice'>Your skin feels gaseous and slimy. You get the urge to scamper around in the vents.</span>")

	addtimer(CALLBACK(src, .proc/normal_composition), 30 SECONDS)

/obj/item/organ/cyberimp/neuromod/mimic_composition/proc/normal_composition()
	owner.remove_emitter("mimic_composition")
	owner.ventcrawler = VENTCRAWLER_NONE
	owner.pass_flags &= ~(PASSGRILLE|PASSDOORS)
	owner.alpha *= 2
	owner.remove_emitter(/obj/emitter/mimic/mimic_composition,"mimic_composition")
	to_chat(owner, "<span class='notice'>Your body reshapes itself.</span>")

/obj/emitter/mimic/mimic_composition
	particles = new/particles/mimic/mimic_composition

/particles/mimic/mimic_composition
	spawning = 4
	lifespan = 0.7 SECONDS
	fade = 0.5 SECONDS
	gravity = list(0,1,0)
	color = generator("color", "#802980", "#cf13b6", NORMAL_RAND)
	position = generator("box", list(-10,-7,0), list(10,7,0), NORMAL_RAND)
	velocity = generator("box", list(-3,0,0), list(3,10,0), NORMAL_RAND)
	friction = 0.5
	drift = generator("box", list(0,0.2,0), list(0,0.5,0), NORMAL_RAND)
