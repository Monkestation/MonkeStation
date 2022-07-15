/datum/antagonist/living_lube
	name = "Living Lube"
	roundend_category = "Living Lubes"
	antagpanel_category = "Living Lube"
	silent = TRUE
	give_objectives = FALSE
	show_to_ghosts = TRUE

/datum/antagonist/living_lube/on_gain()
	objectives += "Annoy the station as much as possible."
	// if(ishuman(owner.current))
	// 	var/mob/living/carbon/human/floridan = owner.current

	// 	//Abilities & Traits added here
	// 	// ADD_TRAIT(floridan, TRAIT_MONKEYLIKE, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_CLUMSY, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_DUMB, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_STABLELIVER, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_STABLEHEART, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_TOXIMMUNE, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_JAILBIRD, SPECIES_TRAIT)
	// 	// ADD_TRAIT(floridan, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)

	// 	floridan.physiology.stamina_mod = 0.25
	// 	floridan.physiology.stun_mod = 0.25
	// 	floridan.ventcrawler = 1
	// 	var/obj/effect/proc_holder/spell/targeted/florida_doorbuster/DB = new
	// 	var/obj/effect/proc_holder/spell/targeted/florida_cuff_break/CB = new
	// 	var/obj/effect/proc_holder/spell/targeted/florida_regeneration/RG = new
	// 	floridan.AddSpell(DB)
	// 	floridan.AddSpell(CB)
	// 	floridan.AddSpell(RG)
	// . = ..()
	// for(var/datum/objective/O in objectives)
	// 	log_objective(owner, O.explanation_text)



/datum/antagonist/living_lube/greet()
	var/mob/living/carbon/lube = owner.current

	owner.current.playsound_local(get_turf(owner.current), 'sound/items/bikehorn.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>You are the Living Lube!\nYou are an agent of chaos. Annoy the station as much as possible\n\nYou don't want to kill anyone, but you must be as much of an annoyance as possible.\n\nHonk!</span>")
	owner.announce_objectives()
	var/decided_name = "Living Lube"
	if(prob(1)) // Henk :)
		decided_name = "Pee Pee Peter"
	lube.name = "[decided_name]"
	lube.real_name = "[decided_name]"

