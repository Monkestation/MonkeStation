/mob/living/simple_animal/bot/secbot
	name = "\improper Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "secbot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	damage_coeff = list(BRUTE = 0.5, BURN = 0.7, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	pass_flags = PASSMOB

	maints_access_required = list(ACCESS_SECURITY)
	radio_key = /obj/item/encryptionkey/secbot //AI Priv + Security
	radio_channel = RADIO_CHANNEL_SECURITY //Security channel
	bot_type = SEC_BOT
	bot_mode_flags = ~BOT_MODE_PAI_CONTROLLABLE
	data_hud_type = DATA_HUD_SECURITY_ADVANCED
	hackables = "target identification systems"
	path_image_color = "#FF0000"

	///The type of baton this Secbot will use
	var/baton_type = /obj/item/melee/baton
	///The weapon (from baton_type) that will be used to make arrests.
	var/obj/item/weapon
	///Their current target
	var/mob/living/carbon/target
	///Name of their last target to prevent spamming
	var/oldtarget_name
	///The threat level of the BOT, will arrest anyone at threatlevel 4 or above
	var/threatlevel = 0
	///The last location their target was seen at
	var/target_lastloc
	///Time since last seeing their perpetrator
	var/last_found
	///Flags SecBOTs use on what to check on targets when arresting, and whether they should announce it to security/handcuff their target
	var/security_mode_flags = SECBOT_DECLARE_ARRESTS | SECBOT_CHECK_RECORDS | SECBOT_HANDCUFF_TARGET

	///On arrest, charges the violator this much. If they don't have that much in their account, they will get beaten instead
	var/fair_market_price_arrest = 25
	///Charged each time the violator is stunned on detain
	var/fair_market_price_detain = 5
	/// Force of the harmbaton used on them
	var/weapon_force = 20
	///The department the secbot will deposit collected money into
	var/payment_department = ACCOUNT_SEC

	//	Selections: SECBOT_DECLARE_ARRESTS | SECBOT_CHECK_IDS | SECBOT_CHECK_WEAPONS | SECBOT_CHECK_RECORDS | SECBOT_HANDCUFF_TARGET
	//monkestation edit begin
	var/arrestsounds = "law"
	var/chasesounds = list('sound/voice/beepsky/criminal.ogg', 'sound/voice/beepsky/justice.ogg', 'sound/voice/beepsky/freeze.ogg')
	var/emagsounds = "sec_emag"
	//monkestation edit end

	var/noloot = FALSE
/mob/living/simple_animal/bot/secbot/beepsky
	name = "Officer Beep O'sky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	bot_mode_flags = BOT_MODE_ON | BOT_MODE_AUTOPATROL | BOT_MODE_REMOTE_ENABLED

/mob/living/simple_animal/bot/secbot/beepsky/officer
	name = "Officer Beepsky"
	desc = "It's Officer Beepsky! Powered by a potato and a shot of whiskey, and with a sturdier reinforced chassis, too."
	health = 45

/mob/living/simple_animal/bot/secbot/beepsky/armsky
	name = "Sergeant-At-Armsky"
	health = 45
	bot_mode_flags = ~BOT_MODE_AUTOPATROL
	security_mode_flags = SECBOT_DECLARE_ARRESTS | SECBOT_CHECK_IDS | SECBOT_CHECK_RECORDS

/mob/living/simple_animal/bot/secbot/beepsky/jr
	name = "Officer Pipsqueak"
	desc = "It's Officer Beep O'sky's smaller, just-as aggressive cousin, Pipsqueak."

/mob/living/simple_animal/bot/secbot/beepsky/jr/Initialize(mapload)
	. = ..()
	resize = 0.8
	update_transform()

/mob/living/simple_animal/bot/secbot/genesky
	name = "Officer Genesky"
	desc = "A beefy variant of the standard securitron model."
	health = 50
	faction = list("nanotrasenprivate")
	bot_mode_flags = BOT_MODE_ON
	bot_cover_flags = BOT_COVER_LOCKED | BOT_COVER_EMAGGED

/mob/living/simple_animal/bot/secbot/pingsky
	name = "Officer Pingsky"
	desc = "It's Officer Pingsky! Delegated to satellite guard duty for harbouring anti-human sentiment."
	radio_channel = RADIO_CHANNEL_AI_PRIVATE

/mob/living/simple_animal/bot/secbot/beepsky/explode()
	var/atom/Tsec = drop_location()
	new /obj/item/stock_parts/cell/potato(Tsec)
	var/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/drinking_oil = new(Tsec)
	drinking_oil.reagents.add_reagent(/datum/reagent/consumable/ethanol/whiskey, 15)
	drinking_oil.on_reagent_change(ADD_REAGENT)
	..()

/mob/living/simple_animal/bot/secbot/pingsky
	name = "Officer Pingsky"
	desc = "It's Officer Pingsky! Delegated to satellite guard duty for harbouring anti-human sentiment."
	radio_channel = RADIO_CHANNEL_AI_PRIVATE

/mob/living/simple_animal/bot/secbot/Initialize(mapload)
	. = ..()
	weapon = new baton_type()
	update_appearance(UPDATE_ICON)

	var/datum/job/detective/J = new/datum/job/detective
	access_card.access += J.get_access()
	prev_access = access_card.access

	//SECHUD
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	secsensor.add_hud_to(src)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/mob/living/simple_animal/bot/secbot/update_icon()
	if(mode == BOT_HUNT)
		icon_state = "[initial(icon_state)]-c"
		return
	..()

/mob/living/simple_animal/bot/secbot/turn_off()
	..()
	mode = BOT_IDLE

/mob/living/simple_animal/bot/secbot/bot_reset()
	..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	SSmove_manager.stop_looping(src)
	last_found = world.time

// Variables sent to TGUI
/mob/living/simple_animal/bot/secbot/ui_data(mob/user)
	var/list/data = ..()
	if(!(bot_cover_flags & BOT_COVER_LOCKED) || issilicon(user) || IsAdminGhost(user))
		data["custom_controls"]["check_id"] = security_mode_flags & SECBOT_CHECK_IDS
		data["custom_controls"]["check_weapons"] = security_mode_flags & SECBOT_CHECK_WEAPONS
		data["custom_controls"]["check_warrants"] = security_mode_flags & SECBOT_CHECK_RECORDS
		data["custom_controls"]["handcuff_targets"] = security_mode_flags & SECBOT_HANDCUFF_TARGET
		data["custom_controls"]["arrest_alert"] = security_mode_flags & SECBOT_DECLARE_ARRESTS
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/secbot/ui_act(action, params)
	. = ..()
	if(. || (bot_cover_flags & BOT_COVER_LOCKED && !usr.has_unlimited_silicon_privilege))
		return
	switch(action)
		if("check_id")
			security_mode_flags ^= SECBOT_CHECK_IDS
		if("check_weapons")
			security_mode_flags ^= SECBOT_CHECK_WEAPONS
		if("check_warrants")
			security_mode_flags ^= SECBOT_CHECK_RECORDS
		if("handcuff_targets")
			security_mode_flags ^= SECBOT_HANDCUFF_TARGET
		if("arrest_alert")
			security_mode_flags ^= SECBOT_DECLARE_ARRESTS
	return

/mob/living/simple_animal/bot/secbot/proc/retaliate(mob/living/carbon/human/H)
	var/judgment_criteria = judgment_criteria()
	threatlevel = H.assess_threat(judgment_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))
	threatlevel += 6
	if(threatlevel >= 4)
		target = H
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/proc/judgment_criteria()
	var/final = FALSE
	if(bot_cover_flags & BOT_COVER_EMAGGED)
		final |= JUDGE_EMAGGED
	if(bot_type == ADVANCED_SEC_BOT)
		final |= JUDGE_IGNOREMONKEYS
	if(security_mode_flags & SECBOT_CHECK_IDS)
		final |= JUDGE_IDCHECK
	if(security_mode_flags & SECBOT_CHECK_RECORDS)
		final |= JUDGE_RECORDCHECK
	if(security_mode_flags & SECBOT_CHECK_WEAPONS)
		final |= JUDGE_WEAPONCHECK
	return final

/mob/living/simple_animal/bot/secbot/proc/special_retaliate_after_attack(mob/user) //allows special actions to take place after being attacked.
	return

/mob/living/simple_animal/bot/secbot/attack_hand(mob/living/carbon/human/H)
	if((H.a_intent == INTENT_HARM) || (H.a_intent == INTENT_DISARM))
		retaliate(H)
		if(special_retaliate_after_attack(H))
			return

	return ..()

/mob/living/simple_animal/bot/secbot/attackby(obj/item/W, mob/user, params)
	..()
	if(!(bot_mode_flags & BOT_MODE_ON)) // Bots won't remember if you hit them while they're off.
		return
	if(W.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM) // Any intent but harm will heal, so we shouldn't get angry.
		return
	if(W.tool_behaviour != TOOL_SCREWDRIVER && (W.force) && (!target) && (W.damtype != STAMINA) ) // Added check for welding tool to fix #2432. Welding tool behavior is handled in superclass.
		retaliate(user)
		if(special_retaliate_after_attack(user))
			return

/mob/living/simple_animal/bot/secbot/emag_act(mob/user)
	..()
	if(!(bot_cover_flags & BOT_COVER_EMAGGED))
		return
	if(user)
		to_chat(user, span_danger("You short out [src]'s target assessment circuits."))
		oldtarget_name = user.name
	audible_message(span_danger("[src] buzzes oddly!"))
	security_mode_flags &= ~SECBOT_DECLARE_ARRESTS
	update_appearance()

/mob/living/simple_animal/bot/secbot/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj , /obj/item/projectile/beam)||istype(Proj, /obj/item/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < src.health && ishuman(Proj.firer))
				retaliate(Proj.firer)
	return ..()

/mob/living/simple_animal/bot/secbot/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(!iscarbon(attack_target))
		return ..()
	var/mob/living/carbon/carbon_target = attack_target
	if(!carbon_target.IsParalyzed() || !(security_mode_flags & SECBOT_HANDCUFF_TARGET))
		if(!check_nap_violations())
			stun_attack(attack_target, TRUE)
		else
			stun_attack(attack_target)
	else if(carbon_target.canBeHandcuffed() && !carbon_target.handcuffed)
		start_handcuffing(attack_target)

/mob/living/simple_animal/bot/secbot/hitby(atom/movable/hitting_atom, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(istype(hitting_atom, /obj/item))
		var/obj/item/item_hitby = hitting_atom
		var/mob/thrown_by = item_hitby.thrownby?.resolve()
		if(item_hitby.throwforce < src.health && thrown_by && ishuman(thrown_by))
			var/mob/living/carbon/human/human_throwee = thrown_by
			retaliate(human_throwee)
	..()

/mob/living/simple_animal/bot/secbot/proc/start_handcuffing(mob/living/carbon/C)
	mode = BOT_ARREST
	playsound(src, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
	C.visible_message("<span class='danger'>[src] is trying to put zipties on [C]!</span>",\
						"<span class='userdanger'>[src] is trying to put zipties on you!</span>")
	addtimer(CALLBACK(src, .proc/handcuff_target, C), 60)

/mob/living/simple_animal/bot/secbot/proc/handcuff_target(mob/living/carbon/C)
	if(!(bot_mode_flags & BOT_MODE_ON) || !Adjacent(C) || !isturf(C.loc) ) //if he's in a closet or not adjacent, we cancel cuffing.
		return
	if(!C.handcuffed)
		C.set_handcuffed(new /obj/item/restraints/handcuffs/cable/zipties/used(C))
		C.update_handcuffed()
		if((bot_cover_flags & BOT_COVER_EMAGGED)  && prob(50)) //if it's emagged, there's a chance it'll play a special sound  instead
			playsound(src, emagsounds, 50, 0)
		else
			playsound(src, arrestsounds, 50, 0)//monkestation edit for custom arrest sounds
		back_to_idle()

/mob/living/simple_animal/bot/secbot/proc/stun_attack(mob/living/carbon/C)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.check_shields(src, 0))
			return
	var/judgment_criteria = judgment_criteria()
	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
	icon_state = "[initial(icon_state)]-c"
	addtimer(CALLBACK(src, /atom/.proc/update_icon), 2)
	var/threat = 5
	if(ishuman(C))
		C.stuttering = 5
		C.Paralyze(100)
		var/mob/living/carbon/human/H = C
		threat = H.assess_threat(judgment_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))
	else
		C.Paralyze(100)
		C.stuttering = 5
		threat = C.assess_threat(judgment_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

	log_combat(src,C,"stunned")
	if(security_mode_flags & SECBOT_DECLARE_ARRESTS)
		var/area/location = get_area(src)
		speak("[security_mode_flags & SECBOT_HANDCUFF_TARGET ? "Arresting" : "Detaining"] level [threat] scumbag <b>[C]</b> in [location].", radio_channel)
	C.visible_message("<span class='danger'>[src] has stunned [C]!</span>",\
							"<span class='userdanger'>[src] has stunned you!</span>")

/mob/living/simple_animal/bot/secbot/handle_automated_action()
	. = ..()
	if(!.)
		return

	switch(mode)

		if(BOT_IDLE) // idle
			SSmove_manager.stop_looping(src)
			look_for_perp() // see if any criminals are in range
			if((mode == BOT_IDLE) && bot_mode_flags & BOT_MODE_AUTOPATROL) // didn't start hunting during look_for_perp, and set to patrol
				mode = BOT_START_PATROL // switch to patrol mode

		if(BOT_HUNT) // hunting for perp
			// if can't reach perp for long enough, go idle
			if(frustration >= 8)
				SSmove_manager.stop_looping(src)
				back_to_idle()
				return

			if(!target) // make sure target exists
				back_to_idle()
				return
			if(Adjacent(target) && isturf(target.loc)) // if right next to perp
				if(!check_nap_violations())
					stun_attack(target, TRUE)
				else
					stun_attack(target)

				anchored = TRUE
				return

			// not next to perp
			var/turf/olddist = get_dist(src, target)
			SSmove_manager.move_to(src, target, 1, 4)
			if((get_dist(src, target)) >= (olddist))
				frustration++
			else
				frustration = 0

		if(BOT_PREP_ARREST) // preparing to arrest target
			// see if he got away. If he's no no longer adjacent or inside a closet or about to get up, we hunt again.
			if(!Adjacent(target) || !isturf(target.loc) || !HAS_TRAIT(target, TRAIT_FLOORED))
				back_to_hunt()
				return

			if(!iscarbon(target) || !target.canBeHandcuffed())
				back_to_idle()
				return

			if(security_mode_flags & SECBOT_HANDCUFF_TARGET)
				if(!target.handcuffed) //he's not cuffed? Try to cuff him!
					start_handcuffing(target)
				else
					back_to_idle()
					return

		if(BOT_ARREST)
			if(!target)
				anchored = FALSE
				mode = BOT_IDLE
				last_found = world.time
				frustration = 0
				return

			if(target.handcuffed) //no target or target cuffed? back to idle.
				if(!check_nap_violations())
					stun_attack(target, TRUE)
					return
				back_to_idle()
				return

			if(!Adjacent(target) || !isturf(target.loc) || (target.loc != target_lastloc && !HAS_TRAIT(target, TRAIT_FLOORED))) //if he's changed loc and about to get up or not adjacent or got into a closet, we prep arrest again.
				back_to_hunt()
				return
			else //Try arresting again if the target escapes.
				mode = BOT_PREP_ARREST
				anchored = FALSE

		if(BOT_START_PATROL)
			look_for_perp()
			start_patrol()

		if(BOT_PATROL)
			look_for_perp()
			bot_patrol()

/mob/living/simple_animal/bot/secbot/proc/back_to_idle()
	anchored = FALSE
	mode = BOT_IDLE
	target = null
	last_found = world.time
	frustration = 0
	INVOKE_ASYNC(src, .proc/handle_automated_action)

/mob/living/simple_animal/bot/secbot/proc/back_to_hunt()
	anchored = FALSE
	frustration = 0
	mode = BOT_HUNT
	INVOKE_ASYNC(src, .proc/handle_automated_action)
// look for a criminal in view of the bot

/mob/living/simple_animal/bot/secbot/proc/look_for_perp()
	anchored = FALSE
	var/judgment_criteria = judgment_criteria()
	for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(judgment_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			playsound(loc, pick(chasesounds), 50, FALSE) //monkestation edit for custom chase sounds
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = BOT_HUNT
			INVOKE_ASYNC(src, .proc/handle_automated_action)
			break
		else
			continue

/mob/living/simple_animal/bot/secbot/proc/check_for_weapons(var/obj/item/slot_item)
	if(slot_item && (slot_item.item_flags & NEEDS_PERMIT))
		return TRUE
	return FALSE

/mob/living/simple_animal/bot/secbot/explode()
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/atom/Tsec = drop_location()

	var/obj/item/bot_assembly/secbot/Sa = new (Tsec)
	Sa.build_step = ASSEMBLY_FIRST_STEP
	Sa.add_overlay("hs_hole")
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(Tsec)
	drop_part(baton_type, Tsec)

	do_sparks(3, TRUE, src)

	new /obj/effect/decal/cleanable/oil(loc)
	..()

/mob/living/simple_animal/bot/secbot/attack_alien(var/mob/living/carbon/alien/user as mob)
	..()
	if(!isalien(target))
		target = user
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(has_gravity() && ismob(AM) && target)
		var/mob/living/carbon/C = AM
		if(!istype(C) || !C || in_range(src, target))
			return
		knockOver(C)
		return

/mob/living/simple_animal/bot/secbot/proc/check_nap_violations()
	if(!SSeconomy.full_ancap)
		return TRUE
	if(!target)
		return TRUE
	if(!ishuman(target))
		return TRUE
	var/mob/living/carbon/human/human_target = target
	var/obj/item/card/id/target_id = human_target.get_idcard()
	if(!target_id)
		say("Suspect NAP Violation: No ID card found.")
		nap_violation(target)
		return FALSE
	var/datum/bank_account/insurance = target_id.registered_account
	if(!insurance)
		say("Suspect NAP Violation: No bank account found.")
		nap_violation(target)
		return FALSE
	var/fair_market_price = (security_mode_flags & SECBOT_HANDCUFF_TARGET ? fair_market_price_detain : fair_market_price_arrest)
	if(!insurance.adjust_money(-fair_market_price))
		say("Suspect NAP Violation: Unable to pay.")
		nap_violation(target)
		return FALSE
	var/datum/bank_account/beepsky_department_account = SSeconomy.get_dep_account(payment_department)
	say("Thank you for your compliance. Your account been charged [fair_market_price] credits.")
	if(beepsky_department_account)
		beepsky_department_account.adjust_money(fair_market_price)
		return TRUE

/// Does nothing
/mob/living/simple_animal/bot/secbot/proc/nap_violation(mob/violator)
	return
