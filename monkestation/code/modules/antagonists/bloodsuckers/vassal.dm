#define VASSAL_SCAN_MIN_DISTANCE 5
#define VASSAL_SCAN_MAX_DISTANCE 500
/// 2s update time.
#define VASSAL_SCAN_PING_TIME (2 SECONDS)

/datum/antagonist/vassal
	name = "\improper Vassal"
	roundend_category = "vassals"
	antagpanel_category = "Bloodsucker"
	job_rank = ROLE_BLOODSUCKER
	show_in_roundend = FALSE

	/// The Master Bloodsucker's antag datum.
	var/datum/antagonist/bloodsucker/master
	var/datum/game_mode/blooodsucker
	/// List of all Purchased Powers, like Bloodsuckers.
	var/list/datum/action/powers = list()
	/// The favorite vassal gets unique features.
	var/favorite_vassal = FALSE
	/// Bloodsucker levels, but for Vassals.
	var/vassal_level
	/// Am I protected from getting my antag removed if I get Mindshielded?
	var/protected_from_mindshielding = FALSE
	/// Tremere Vassals only - Have I been mutated?
	var/mutilated = FALSE

/datum/antagonist/vassal/antag_panel_data()
	return "Master : [master.owner.name]"

/datum/antagonist/vassal/apply_innate_effects(mob/living/mob_override)
	var/mob/living/current_mob = mob_override || owner.current
	current_mob.apply_status_effect(/datum/status_effect/agent_pinpointer/vassal_edition)

/datum/antagonist/vassal/remove_innate_effects(mob/living/mob_override)
	var/mob/living/current_mob = mob_override || owner.current
	current_mob.remove_status_effect(/datum/status_effect/agent_pinpointer/vassal_edition)

/datum/antagonist/vassal/on_gain()
	/// Enslave them to their Master
	if(master)
		var/datum/antagonist/bloodsucker/bloodsuckerdatum = master.owner.has_antag_datum(/datum/antagonist/bloodsucker)
		if(bloodsuckerdatum)
			bloodsuckerdatum.vassals |= src
		owner.enslave_mind_to_creator(master.owner.current)
		/// Is my Master part of Tremere?
		if(bloodsuckerdatum.my_clan == CLAN_TREMERE)
			protected_from_mindshielding = TRUE
	owner.current.log_message("has been vassalized by [master.owner.current]!", LOG_ATTACK, color="#960000")
	/// Give Recuperate Power
	BuyPower(new /datum/action/bloodsucker/recuperate)
	/// Give Objectives
	var/datum/objective/bloodsucker/vassal/vassal_objective = new
	vassal_objective.owner = owner
	objectives += vassal_objective
	/// Give Vampire Language & Hud
	owner.current.grant_all_languages(FALSE, FALSE, TRUE)
	owner.current.grant_language(/datum/language/vampiric)
	update_vassal_icons_added(owner.current)
	. = ..()

/datum/antagonist/vassal/on_removal()
	//Free them from their Master
	if(master && master.owner)
		master.vassals -= src
		owner.enslaved_to = null
	for(var/all_status_traits in owner.current.status_traits)
		REMOVE_TRAIT(owner.current, all_status_traits, BLOODSUCKER_TRAIT)
	//Remove Recuperate Power
	while(powers.len)
		var/datum/action/bloodsucker/power = pick(powers)
		powers -= power
		power.Remove(owner.current)
	//Remove Language & Hud
	owner.current.remove_language(/datum/language/vampiric)
	update_vassal_icons_removed(owner.current)
	UnregisterSignal(master, COMSIG_BLOODSUCKER_RANKS_SPENT)
	return ..()

/datum/antagonist/vassal/on_body_transfer(mob/living/old_body, mob/living/new_body)
	. = ..()
	for(var/datum/action/bloodsucker/all_powers as anything in powers)
		all_powers.Remove(old_body)
		all_powers.Grant(new_body)


/datum/antagonist/vassal/proc/add_objective(datum/objective/added_objective)
	objectives += added_objective

/datum/antagonist/vassal/proc/remove_objectives(datum/objective/removed_objective)
	objectives -= removed_objective

/datum/antagonist/vassal/greet()
	. = ..()
	to_chat(owner, span_userdanger("You are now the mortal servant of [master.owner.current], a Bloodsucker!"))
	to_chat(owner, span_boldannounce("The power of [master.owner.current.p_their()] immortal blood compels you to obey [master.owner.current.p_them()] in all things, even offering your own life to prolong theirs.\n\
		You are not required to obey any other Bloodsucker, for only [master.owner.current] is your master. The laws of Nanotrasen do not apply to you now; only your vampiric master's word must be obeyed."))
	owner.current.playsound_local(null, 'sound/magic/mutate.ogg', 100, FALSE, pressure_affected = FALSE)
	antag_memory += "You have been vassalized, becoming the mortal servant of <b>[master.owner.current]</b>, a bloodsucking vampire!<br>"
	/// Message told to your Master.
	to_chat(master.owner, span_userdanger("[owner.current] has become addicted to your immortal blood. [owner.current.p_they(TRUE)] [owner.current.p_are()] now your undying servant!"))
	master.owner.current.playsound_local(null, 'sound/magic/mutate.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/vassal/farewell()
	owner.current.visible_message(
		span_deconversion_message("[owner.current]'s eyes dart feverishly from side to side, and then stop. [owner.current.p_they(TRUE)] seem[owner.current.p_s()] calm, \
		like [owner.current.p_they()] [owner.current.p_have()] regained some lost part of [owner.current.p_them()]self."),
	)
	to_chat(owner, span_deconversion_message("With a snap, you are no longer enslaved to [master.owner]! You breathe in heavily, having regained your free will."))
	owner.current.playsound_local(null, 'sound/magic/mutate.ogg', 100, FALSE, pressure_affected = FALSE)
	/// Message told to your (former) Master.
	if(master && master.owner)
		to_chat(master.owner, span_cultbold("You feel the bond with your vassal [owner.current] has somehow been broken!"))

/// Called when we are made into the Favorite Vassal
/datum/antagonist/vassal/proc/make_favorite(mob/living/master)
	// Default stuff for all
	favorite_vassal = TRUE
	set_antag_hud(owner.current, "vassal6")
	to_chat(master, span_danger("You have turned [owner.current] into your Favorite Vassal! They will no longer be deconverted upon Mindshielding!"))
	to_chat(owner, span_notice("As Blood drips over your body, you feel closer to your Master... You are now the Favorite Vassal!"))
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = master.mind.has_antag_datum(/datum/antagonist/bloodsucker)
	var/mob/living/carbon/human/vassal = owner.current
	switch(bloodsuckerdatum.my_clan)
		if(CLAN_GANGREL)
			var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/batform = new
			owner.AddSpell(batform)
		if(CLAN_LASOMBRA)
			if(ishuman(owner.current))
				vassal.see_in_dark = 8
				vassal.eye_color = "f00"
			var/list/powers = list(new /obj/effect/proc_holder/spell/targeted/lesser_glare, new /obj/effect/proc_holder/spell/targeted/shadowwalk)
			for(var/obj/effect/proc_holder/spell/targeted/power in powers)
				owner.AddSpell(power)
		if(CLAN_TZIMISCE)
			if(!do_mob(master, owner.current, 1 SECONDS, TRUE))
				return
			playsound(vassal.loc, 'sound/weapons/slash.ogg', 50, TRUE, -1)
			if(!do_mob(master, owner.current, 1 SECONDS, TRUE))
				return
			playsound(vassal.loc, 'sound/effects/splat.ogg', 50, TRUE)
			vassal.set_species(/datum/species/szlachta)
		if(CLAN_TOREADOR)
			BuyPower(/datum/action/bloodsucker/targeted/mesmerize)
			RegisterSignal(master, COMSIG_BLOODSUCKER_RANKS_SPENT, .proc/toreador_levelup_mesmerize)

/datum/antagonist/vassal/proc/toreador_levelup_mesmerize() //Don't need stupid args
	for(var/datum/action/bloodsucker/targeted/mesmerize/mesmerize_power in powers)
		if(!istype(mesmerize_power))
			continue
		mesmerize_power.level_current = max(master.bloodsucker_level, 1)

/// If we weren't created by a bloodsucker, then we cannot be a vassal (assigned from antag panel)
/datum/antagonist/vassal/can_be_owned(datum/mind/new_owner)
	if(!master)
		return FALSE
	return ..()

/// Used for Admin removing Vassals.
/datum/mind/proc/remove_vassal()
	var/datum/antagonist/vassal/selected_vassal = has_antag_datum(/datum/antagonist/vassal)
	if(selected_vassal)
		remove_antag_datum(/datum/antagonist/vassal)

/// When a Bloodsucker gets FinalDeath, all Vassals are freed - This is a Bloodsucker proc, not a Vassal one.
/datum/antagonist/bloodsucker/proc/FreeAllVassals()
	for(var/datum/antagonist/vassal/all_vassals in vassals)
		// Skip over any Bloodsucker Vassals, they're too far gone to have all their stuff taken away from them
		if(all_vassals.owner.has_antag_datum(/datum/antagonist/bloodsucker))
			continue
		remove_vassal(all_vassals.owner)

/// Called by FreeAllVassals()
/datum/antagonist/bloodsucker/proc/remove_vassal(datum/mind/vassal)
	vassal.remove_antag_datum(/datum/antagonist/vassal)

/// Used when your Master teaches you a new Power.
/datum/antagonist/vassal/proc/BuyPower(datum/action/bloodsucker/power)
	powers += power
	power.Grant(owner.current)

/datum/antagonist/vassal/proc/LevelUpPowers()
	for(var/datum/action/bloodsucker/power in powers)
		power.level_current++

/**
 *	# Vassal Pinpointer
 *
 *	Pinpointer that points to their Master's location at all times.
 *	Unlike the Monster hunter one, this one is permanently active, and has no power needed to activate it.
 */

/obj/screen/alert/status_effect/agent_pinpointer/vassal_edition
	name = "Blood Bond"
	desc = "You always know where your master is."

/datum/status_effect/agent_pinpointer/vassal_edition
	id = "agent_pinpointer"
	alert_type = /obj/screen/alert/status_effect/agent_pinpointer/vassal_edition
	minimum_range = VASSAL_SCAN_MIN_DISTANCE
	tick_interval = VASSAL_SCAN_PING_TIME
	duration = -1
	range_fuzz_factor = 0

/datum/status_effect/agent_pinpointer/vassal_edition/on_creation(mob/living/new_owner, ...)
	..()
	var/datum/antagonist/vassal/antag_datum = new_owner.mind.has_antag_datum(/datum/antagonist/vassal)
	scan_target = antag_datum?.master?.owner?.current

/datum/status_effect/agent_pinpointer/vassal_edition/scan_for_target()
	return

/datum/status_effect/agent_pinpointer/vassal_edition/Destroy()
	if(scan_target)
		to_chat(owner, span_notice("You've lost your master's trail."))
	return ..()

/**
 * # HUD
 */
/datum/antagonist/vassal/proc/update_vassal_icons_added(mob/living/vassal, icontype = "vassal")
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_BLOODSUCKER]
	hud.join_hud(vassal)
	/// Located in icons/mob/hud.dmi
	set_antag_hud(vassal, icontype)
	/// FULP ADDITION! Check prepare_huds in mob.dm to see why.

/datum/antagonist/vassal/proc/update_vassal_icons_removed(mob/living/vassal)
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_BLOODSUCKER]
	hud.leave_hud(vassal)
	set_antag_hud(vassal, null)

/*
 *	# Vassal Feeding
 *
 *	Ventrue's Favorite Vassal can feed once they reach a certain level, this handles that.
 *	This is a direct Copy & Paste from the Bloodsucker version.
 */

/datum/antagonist/vassal/proc/HandleFeeding(mob/living/carbon/target, mult=1)
	var/blood_taken = min(15, target.blood_volume) * mult
	target.blood_volume -= blood_taken
	// Simple Animals lose a LOT of blood, and take damage. This is to keep cats, cows, and so forth from giving you insane amounts of blood.
	if(!ishuman(target))
		target.blood_volume -= (blood_taken / max(target.mob_size, 0.1)) * 3.5 // max() to prevent divide-by-zero
		target.apply_damage_type(blood_taken / 3.5) // Don't do too much damage, or else they die and provide no blood nourishment.
		if(target.blood_volume <= 0)
			target.blood_volume = 0
			target.death(0)
	///////////
	// Shift Body Temp (toward Target's temp, by volume taken)
	owner.current.bodytemperature = ((owner.current.blood_volume * owner.current.bodytemperature) + (blood_taken * target.bodytemperature)) / (owner.current.blood_volume + blood_taken)
	// our volume * temp, + their volume * temp, / total volume
	///////////
	// Reduce Value Quantity
	if(target.stat == DEAD) // Penalty for Dead Blood
		blood_taken /= 3
	if(!ishuman(target)) // Penalty for Non-Human Blood
		blood_taken /= 2
	//if (!iscarbon(target)) // Penalty for Animals (they're junk food)
	// Apply to Volume
	AddBloodVolume(blood_taken)
	// Reagents (NOT Blood!)
	if(target.reagents && target.reagents.total_volume)
		target.reagents.trans_to(owner.current, INGEST, 1) // Run transfer of 1 unit of reagent from them to me.
	owner.current.playsound_local(null, 'sound/effects/singlebeat.ogg', 40, 1) // Play THIS sound for user only. The "null" is where turf would go if a location was needed. Null puts it right in their head.

/datum/antagonist/vassal/proc/AddBloodVolume(value)
	owner.current.blood_volume = clamp(owner.current.blood_volume + value, 0, 560)




/datum/antagonist/bloodsucker/proc/SpendVassalRank(mob/living/target)
	set waitfor = FALSE

	var/datum/antagonist/vassal/vassaldatum = target.mind.has_antag_datum(/datum/antagonist/vassal)
	/// Purchase Power Prompt
	var/list/options = list()
	for(var/pickedpower in typesof(/datum/action/bloodsucker))
		var/datum/action/bloodsucker/power = pickedpower
		/// Check If I don't own it & I'm allowed to buy it.
		if(!(locate(power) in vassaldatum.powers) && (initial(power.purchase_flags) & VASSAL_CAN_BUY))
			options[initial(power.name)] = power

	/// No powers to purchase? Abort.
	if(options.len >= 1)
		/// Give them the UI to purchase a power.
		var/choice = input(owner.current, "You have the opportunity to level up your Favorite Vassal at the cost of 100 Blood. Select a power you wish them to recieve.", "You feel like a Leader!") as null|anything in options
		/// Safety Check
		if(bloodsucker_level_unspent <= 0)
			return
		/// Did you choose a power? Do you already have it? - Added due to window stacking.
		if(!choice || !options[choice] || (locate(options[choice]) in vassaldatum.powers))
			to_chat(owner.current, "<span class='notice'>You prevent your blood from thickening just yet, but you may try again later.</span>")
			return
		/// Good to go - Buy Power!
		owner.current.blood_volume -= 100
		var/datum/action/bloodsucker/P = options[choice]
		vassaldatum.BuyPower(new P)
		to_chat(owner.current, "<span class='notice'>You taught [target] how to use [initial(P.name)]!</span>")
		to_chat(target, "<span class='notice'>Your master taught you how to use [initial(P.name)]!</span>")

	else
		to_chat(owner.current, "<span class='notice'>You grow more ancient by the night!</span>")

	/* # As we don't level up normally, Bloodsuckers will Rank Up themselves this way.
	*/

	/// Advance your and your Vassal's Powers - Includes the one you just purchased.
	vassaldatum.LevelUpPowers()
	LevelUpPowers()
	/// Bloodsucker-only Stat upgrades
	bloodsucker_regen_rate += 0.05
	max_blood_volume += 100
	/// Misc. Stats Upgrades
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		var/datum/species/S = H.dna.species
		S.punchdamage += 0.5
	owner.current.setMaxHealth(owner.current.maxHealth + 5) // Why is this a thing...

	/// We're almost done - Spend your Rank now.
	vassaldatum.vassal_level++
	bloodsucker_level++
	bloodsucker_level_unspent--

	/// Vassals will turn more into a 'Bloodsucker' overtime
	if(vassaldatum.vassal_level == 2)
		ADD_TRAIT(target, TRAIT_COLDBLOODED, BLOODSUCKER_TRAIT)
		ADD_TRAIT(target, TRAIT_NOBREATH, BLOODSUCKER_TRAIT)
		to_chat(target, "<span class='notice'>Your blood begins you feel cold as you stop breathing...</span>")
	if(vassaldatum.vassal_level == 3)
		ADD_TRAIT(target, TRAIT_SLEEPIMMUNE, BLOODSUCKER_TRAIT)
		ADD_TRAIT(target, TRAIT_VIRUSIMMUNE, BLOODSUCKER_TRAIT)
		to_chat(target, "<span class='notice'>You feel your Master's blood begin to protect you from Diseases.</span>")
	if(vassaldatum.vassal_level == 4)
		ADD_TRAIT(target, TRAIT_NOPULSE, BLOODSUCKER_TRAIT)
		ADD_TRAIT(target, TRAIT_STABLEHEART, BLOODSUCKER_TRAIT)
		to_chat(target, "<span class='notice'>You feel your heart stop pumping for the last time as you begin to thirst for blood, you will no longer naturally regenerate Blood!</span>")
		vassaldatum.BuyPower(new /datum/action/bloodsucker/feed)
