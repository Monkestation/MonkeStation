/datum/reagent/jungle
	name = "Impossible Jungle Chem"
	description = "A reagent that is impossible to make in the jungle."
	can_synth = FALSE
	taste_description = "jungle"

/datum/reagent/jungle/retrosacharide
	name = "Retrosacharide"
	description = "Sacharide with a twisting structure that resembles the golden spiral. It seeks to achieve stability, but it never seems to stop."
	taste_description = "starch"
	var/delta_healing = 5

/datum/reagent/jungle/retrosacharide/on_mob_life(mob/living/L)
	. = ..()
	var/brute = L.getBruteLoss()
	var/fire = L.getFireLoss()
	var/toxin = L.getToxLoss()

	var/average = (brute + fire + toxin)/3

	if(brute != fire || brute != toxin)
		var/b_offset = clamp(average - brute,-delta_healing,delta_healing)
		var/f_offset = clamp(average - fire,-delta_healing,delta_healing)
		var/t_offset = clamp(average - toxin,-delta_healing,delta_healing)
		L.adjustBruteLoss(b_offset,FALSE)
		L.adjustFireLoss(f_offset,FALSE)
		L.adjustToxLoss(t_offset)
		return

	switch(rand(0,2))
		if(0)
			L.adjustBruteLoss(-0.5)
		if(1)
			L.adjustFireLoss(-0.5)
		if(2)
			L.adjustToxLoss(-0.5)

/datum/reagent/jungle/jungle_scent
	name = "Jungle scent"
	description = "It reeks of the jungle pits, but I wonder if it has any effects do to that?"
	taste_description = "jungle"
	metabolization_rate = REAGENTS_METABOLISM / 2
	var/has_mining = FALSE

/datum/reagent/jungle/jungle_scent/on_mob_metabolize(mob/living/L)
	. = ..()
	if("mining" in L.faction)
		has_mining = TRUE
		return
	L.faction += "mining"

/datum/reagent/jungle/jungle_scent/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(has_mining)
		return
	L.faction -= "mining"

/datum/reagent/jungle/polybycin
	name = "Polybycin"
	description = "An unknown molecule with simmiliar structure to psychodelics found on terra, effects unknown."
	taste_description = "colours"
	metabolization_rate = REAGENTS_METABOLISM / 2

	var/offset = 0;
	var/atom/movable/screen/fullscreen/trip/cached_screen
	var/atom/movable/screen/fullscreen/ftrip/cached_screen_floor
	var/atom/movable/screen/fullscreen/gtrip/cached_screen_game

/datum/reagent/jungle/polybycin/on_mob_metabolize(mob/living/L)
	. = ..()
	add_filters(L)

/datum/reagent/jungle/polybycin/on_mob_life(mob/living/L)
	. = ..()
	update_filters(L)

/datum/reagent/jungle/polybycin/on_mob_end_metabolize(mob/living/L)
	remove_filters(L)
	. = ..()

/atom/movable/screen/plane_master/proc/get_render_target()
	render_target = "[name]_TARGET"
	return render_target

// I seperated these functions from the ones right above this comment for clarity, and because i wanted to seperate visual stuff from effects stuff, makes it easier to understand.
/datum/reagent/jungle/polybycin/proc/add_filters(mob/living/L)
	if(!L.hud_used || !L.client)
		return

	var/atom/movable/screen/plane_master/game_world/game_plane =  L.hud_used.plane_masters["[GAME_PLANE]"]
	var/atom/movable/screen/plane_master/floor/floor_plane  = L.hud_used.plane_masters["[FLOOR_PLANE]"]

	cached_screen = L.overlay_fullscreen("polycybin_trip",/atom/movable/screen/fullscreen/trip)
	cached_screen_floor = L.overlay_fullscreen("polycybin_ftrip",/atom/movable/screen/fullscreen/ftrip)
	cached_screen_game = L.overlay_fullscreen("polycybin_gtrip",/atom/movable/screen/fullscreen/gtrip)

	cached_screen_floor.add_filter("polycybin_ftrip",1,list("type"="alpha","render_source"=floor_plane.get_render_target()))
	cached_screen_game.add_filter("polycybin_gtrip",1,list("type"="alpha","render_source"=game_plane.get_render_target()))

/datum/reagent/jungle/polybycin/proc/remove_filters(mob/living/L)
	if(!L.client)
		return

	cached_screen = null
	cached_screen_floor = null
	cached_screen_game = null

	L.clear_fullscreen("polycybin_trip")
	L.clear_fullscreen("polycybin_ftrip")
	L.clear_fullscreen("polycybin_gtrip")


/datum/reagent/jungle/polybycin/proc/update_filters(mob/living/L)
	if(!L.client)
		return

	if(cached_screen)
		animate(cached_screen, alpha = min(min(current_cycle,volume)/25,1)*255, time = 2 SECONDS)
	if(cached_screen_floor)
		animate(cached_screen_floor, alpha = min(min(current_cycle,volume)/25,1)*255, time = 2 SECONDS)
	if(cached_screen_game)
		animate(cached_screen_game, alpha = min(min(current_cycle,volume)/25,1)*255, time = 2 SECONDS)

/datum/reagent/space_cleaner/sterilizine/primal
	name = "Primal Sterilizine"
	description = "While crude and odorous, it still seems to kill enough bacteria to be usable."

/datum/reagent/toxin/meduracha //try putting this in a blowgun!
	name = "Meduracha Toxin"
	description = "Harvested from Meduracha tentacles, the toxin has quickly decayed into a less deadly form, but still is quite fatal."
	color = "#00ffb3"
	taste_description = "acid"
	toxpwr = 3.5 //slightly more damaging than ground up plasma, and also causes other minor effects

/datum/reagent/toxin/meduracha/on_mob_life(mob/living/carbon/M)
	M.damageoverlaytemp = 60
	M.update_damage_hud()
	M.blur_eyes(3)
	return ..()

/datum/reagent/quinine
	name = "Quinine"
	description = "Dark brown liquid used to treat exotic diseases."
	color =  "#5e3807"
	taste_description = "bitter and sour"

/// jungle recipes---
/datum/chemical_reaction/poultice/alt2
	name = "tribal poultice 2"
	id = "poultice_alt2"
	required_temp = 420
	required_reagents = list(/datum/reagent/ash = 15, /datum/reagent/space_cleaner/sterilizine/primal = 4)
