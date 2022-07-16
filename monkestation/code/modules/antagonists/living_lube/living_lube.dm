/datum/antagonist/living_lube
	name = "Living Lube"
	roundend_category = "Living Lubes"
	antagpanel_category = "Living Lube"
	silent = TRUE
	give_objectives = FALSE
	show_to_ghosts = TRUE

/datum/antagonist/living_lube/on_gain()
	objectives += "Annoy the station as much as possible."
	if(isliving(owner.current))
		var/mob/living/simple_animal/hostile/retaliate/clown/lube/lube = owner.current

		lube.maxHealth = 750 //What a god
		lube.health = 750
		lube.melee_damage = 0 //You can't kill people!
		lube.obj_damage = 0 //You can't kill people!
		lube.unsuitable_atmos_damage = 0 //Space won't get this little lube
		lube.minbodytemp = TCMB
		lube.maxbodytemp = T0C + 40
		//Abilities & Traits added here
		var/obj/effect/proc_holder/spell/aoe_turf/knock/living_lube/knock = new
		var/obj/effect/proc_holder/spell/aimed/banana_peel/living_lube/banana_peel = new
		var/obj/effect/proc_holder/spell/voice_of_god/clown/living_lube/voice_of_lube = new
		var/obj/effect/proc_holder/spell/targeted/smoke/living_lube/smoke = new
		var/obj/effect/proc_holder/spell/targeted/living_lube_displace/displacement = new
		lube.AddSpell(knock)
		lube.AddSpell(banana_peel)
		lube.AddSpell(voice_of_lube)
		lube.AddSpell(smoke)
		lube.AddSpell(displacement)
	. = ..()

/datum/antagonist/living_lube/greet()
	var/mob/living/carbon/lube = owner.current

	owner.current.playsound_local(get_turf(owner.current), 'sound/items/bikehorn.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>You are the Living Lube!\nYou are an agent of chaos. Annoy the station as much as possible\n\nYou don't want to hurt anyone, but you must be as much of an annoyance as possible.\n\nHonk!</span>")
	owner.announce_objectives()
	var/decided_name = "Ghost of Honk's Past"
	if(prob(1)) // Henk :)
		decided_name = "Ghost of Pee Pee Peter"
	lube.name = decided_name
	lube.real_name = decided_name

