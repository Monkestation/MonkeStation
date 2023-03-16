//Daemon Mask
/obj/item/clothing/mask/daemon_mask
	name = "daemon mask"
	desc = "A cursed mask recovered from the ruins of an ancient cult, found to summon and house spirits."
	icon = 'monkestation/icons/obj/clothing/masks.dmi'
	worn_icon = 'monkestation/icons/mob/mask.dmi'
	icon_state = "daemon_mask"
	item_state = "daemon_mask"
	clothing_flags = SHOWEROKAY
	resistance_flags = FIRE_PROOF | ACID_PROOF
	//Whether a spirit is in the mask or not
	var/possessed = FALSE
	var/mob/living/simple_animal/shade/spirit = null

	//spells only while you possess someone
	var/list/possession_spells = 	list(/obj/effect/proc_holder/spell/targeted/mask_lunge,
										/obj/effect/proc_holder/spell/self/mask_fear,
										/obj/effect/proc_holder/spell/self/summon_armament)

	//spells only while youre a mask
	var/list/mask_spells = 	list(/obj/effect/proc_holder/spell/self/mask_commune,
								/obj/effect/proc_holder/spell/self/truesight)

	//spells that you always have
	var/list/constant_spells = list(/obj/effect/proc_holder/spell/self/mask_possession)

	var/obj/item/armament
	var/obj/item/summoned_armament

/obj/item/clothing/mask/daemon_mask/Initialize(mapload)
	. = ..()
	armament = pick(subtypesof(/obj/item/armament))

/obj/item/clothing/mask/daemon_mask/attack_self(mob/user)
	if(possessed)
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		to_chat(user, "<span class='notice'>The mask doesn't react, it must be broken!</span>")
		return

	to_chat(user, "[src] starts glowing...")

	possessed = TRUE

	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the spirit of the daemon mask?", ROLE_PAI, null, FALSE, 15 SECONDS, POLL_IGNORE_POSSESSED_BLADE)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/candidate = pick(candidates)
		var/mob/living/simple_animal/shade/new_spirit = new(src)
		spirit = new_spirit
		new_spirit.key = candidate.key
		new_spirit.fully_replace_character_name(null, "The spirit of [src]")
		new_spirit.status_flags |= GODMODE
		new_spirit.mind.assigned_role = "daemon mask"
		new_spirit.set_stat(CONSCIOUS)
		new_spirit.remove_from_dead_mob_list()
		new_spirit.add_to_alive_mob_list()
		grant_all_languages()

		// new_spirit.mind.add_antag_datum(/datum/antagonist/survivalist/daemon_mask)

		for(var/ability in constant_spells) //Constant Spells
			var/obj/effect/proc_holder/spell/spell_to_add = new ability
			new_spirit.mind.AddSpell(spell_to_add)

		enter_mask_mode()

		to_chat(user, "<span class='notice'>[src] shines brighter and it's eyes glow red, a spirit has been summoned!</span>")
		icon_state = "daemon_mask_on"
		item_state = "daemon_mask_on"

	else
		to_chat(user, "<span class='notice'>[src] stops glowing. Maybe you can try again later.</span>")
		possessed = FALSE

/obj/item/clothing/mask/daemon_mask/Destroy()
	. = ..()
	qdel(spirit) //if the mask dies you die
	spirit = null

/obj/item/clothing/mask/daemon_mask/proc/enter_mask_mode()
	if(HAS_TRAIT(src,TRAIT_NODROP))
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	for(var/ability in possession_spells)
		spirit.mind.RemoveSpell(ability)
	for(var/ability in mask_spells)
		var/obj/effect/proc_holder/spell/spell = new ability
		spirit.mind.AddSpell(spell)

/obj/item/clothing/mask/daemon_mask/proc/enter_possession_mode()
	if(!HAS_TRAIT(src,TRAIT_NODROP))
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT) //Can't take the mask off while you are in control
	for(var/ability in mask_spells)
		spirit.mind.RemoveSpell(ability)
	for(var/ability in possession_spells)
		var/obj/effect/proc_holder/spell/spell = new ability
		spirit.mind.AddSpell(spell)

//Daemon Mask - Spells
/obj/effect/proc_holder/spell/self/mask_possession
	name = "Take Control"
	desc = "possess of your wearer for a short time. Possessing your wearer makes them unable to go into crit until possession ends."
	clothes_req = FALSE
	charge_max = 3 MINUTES //1 minute for possession + 2 minutes for the cooldown after
	action_icon = 'monkestation/icons/obj/clothing/masks.dmi'
	action_icon_state = "daemon_mask"
	invocation = "none"
	invocation_type = "none"
	school = "transmutation"

/obj/effect/proc_holder/spell/self/mask_possession/cast(mob/living/user)
	var/obj/item/clothing/mask/daemon_mask/mask = user.loc
	if(!ishuman(mask.loc))
		to_chat(user,"<span class='warning'>No one is wearing you!</span>")
		revert_cast()
		return

	var/mob/living/carbon/wearer = mask.loc

	if(mask != wearer.wear_mask)
		to_chat(user,"<span class='warning'>No one is wearing you!</span>")
		revert_cast()
		return

	if(!wearer.ckey)
		to_chat(user,"<span class='warning'>There's no mind to possess!</span>")
		revert_cast()
		return

	playsound(user, 'sound/spookoween/insane_low_laugh.ogg', 75)

	to_chat(wearer,"<span class='userdanger'>[mask] takes control!</span>")

	var/mob/living/spirit = user

	mask.enter_possession_mode()
	//MIND TRANSFER BEGIN
	var/mob/dead/observer/ghost = wearer.ghostize(0)
	spirit.mind.transfer_to(wearer)

	ghost.mind.transfer_to(spirit)
	if(ghost.key)
		spirit.key = ghost.key
	qdel(ghost)

	//Ends stuns
	wearer.SetAllImmobility(0)
	wearer.adjustStaminaLoss(-100)
	wearer.set_resting(FALSE)

	ADD_TRAIT(wearer, TRAIT_NODEATH, "daemon_mask")
	ADD_TRAIT(wearer, TRAIT_NOSOFTCRIT, "daemon_mask")
	ADD_TRAIT(wearer, TRAIT_NOHARDCRIT, "daemon_mask")

	addtimer(CALLBACK(src, .proc/undo_possession, user, wearer, mask), 60 SECONDS)

/obj/effect/proc_holder/spell/self/mask_possession/proc/undo_possession(mob/living/swapper, mob/living/carbon/victim, obj/item/clothing/mask/daemon_mask/mask)
	if(mask.summoned_armament)
		qdel(mask.summoned_armament)
		mask.summoned_armament = null

	var/mob/dead/observer/ghost = swapper.ghostize(0)
	victim.mind.transfer_to(swapper)

	ghost.mind.transfer_to(victim)
	if(ghost.key)
		victim.key = ghost.key
	qdel(ghost)
	mask.enter_mask_mode()

	to_chat(swapper,"<span class='notice'>Your control wears off.</span>")
	to_chat(victim,"<span class='notice'>You regain control of your body.</span>")

	REMOVE_TRAIT(victim, TRAIT_NODEATH, "daemon_mask")
	REMOVE_TRAIT(victim, TRAIT_NOSOFTCRIT, "daemon_mask")
	REMOVE_TRAIT(victim, TRAIT_NOHARDCRIT, "daemon_mask")

/obj/effect/proc_holder/spell/self/mask_commune
	name = "Commune"
	desc = "Send a message to your wearer."
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "hivemind_link"
	clothes_req = FALSE
	charge_max = 1 SECONDS
	invocation = "none"
	invocation_type = "none"
	school = "transmutation"

/obj/effect/proc_holder/spell/self/mask_commune/cast(mob/living/user)
	var/obj/item/clothing/mask/daemon_mask/mask = user.loc

	if(!ishuman(mask.loc))
		to_chat(user,"<span class='warning'>No one is wearing you!</span>")
		return
	var/input = stripped_input(usr, "Talk to your wielder.", "Voice of the mask", "")
	if(!input)
		return
	if(CHAT_FILTER_CHECK(input))
		to_chat(usr, "<span class='warning'>You cannot send a message that contains a word prohibited in IC chat!</span>")
		return

	var/mob/living/wearer = mask.loc

	to_chat(wearer, "<span class='notice'><b>The Daemon Mask whispers to you:</b> [input]</span>")
	to_chat(user, "<span class='notice'><b>You whisper to your wielder:</b> [input]</span>")
	user.log_talk(input, LOG_SAY, tag="daemon mask")

//Mask Mode Spells

/obj/effect/proc_holder/spell/self/truesight
	name = "Truesight"
	desc = "Gain sight into the unknown for a short time."
	clothes_req = FALSE
	charge_max = 45 SECONDS
	action_icon = 'monkestation/icons/obj/clothing/masks.dmi'
	action_icon_state = "daemon_mask_on"
	invocation = "none"
	invocation_type = "none"
	school = "transmutation"

/obj/effect/proc_holder/spell/self/truesight/cast(mob/living/user)
	to_chat(user,"<span class='notice'>Your eyes glow brighter as you see through walls.</span>")
	user.sight |= SEE_THRU

	addtimer(CALLBACK(src, .proc/undo_cast, user), 10 SECONDS)

/obj/effect/proc_holder/spell/self/truesight/proc/undo_cast(mob/living/user)
	to_chat(user,"<span class='notice'>Your vision fades.</span>")
	user.sight &= ~SEE_THRU

//Possession Spells

/obj/effect/proc_holder/spell/targeted/mask_lunge
	name = "Lunge"
	desc = "Use daemonic power to appear on a person nearby, knocking them down."
	school = "abjuration"
	charge_max = 20 SECONDS
	clothes_req = FALSE
	invocation = "none"
	invocation_type = "none"
	ranged_mousepointer = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "teleport"
	range = 6
	selection_type = "range"

/obj/effect/proc_holder/spell/targeted/mask_lunge/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, "<span class='notice'>No target found in range.</span>")
		revert_cast()
		return

	var/mob/living/carbon/target = targets[1]

	if(!isliving(target))
		revert_cast()
		return

	if(!(target in oview(range)))
		to_chat(user, "<span class='notice'>[target.p_theyre(TRUE)] too far away!</span>")
		revert_cast()
		return


	playsound(get_turf(user), 'sound/magic/blink.ogg', 50, 1)
	target.Knockdown(5 SECONDS)
	target.Stun(3 SECONDS)
	target.visible_message("<span class='danger'>[user] appears above [target], knocking them down!</span>", \
						   "<span class='danger'>You fall violently as [user] appears above you!</span>")
	do_teleport(user, target, channel = TELEPORT_CHANNEL_FREE, no_effects = TRUE, teleport_mode = TELEPORT_MODE_DEFAULT)

/obj/effect/proc_holder/spell/self/mask_fear
	name = "Fear"
	desc = "Strike fear into those who dare challenge your status."
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "resonant_shriek"
	clothes_req = FALSE
	charge_max = 20 SECONDS
	invocation = "none"
	invocation_type = "none"
	school = "transmutation"
	var/list/noises = list('sound/hallucinations/i_see_you2.ogg','sound/hallucinations/look_up1.ogg','sound/hallucinations/look_up2.ogg','sound/hallucinations/behind_you1.ogg')

/obj/effect/proc_holder/spell/self/mask_fear/cast(mob/living/user)
	var/obj/item/clothing/mask/daemon_mask/mask = user.loc
	playsound(get_turf(mask), pick(noises), 200, 1)
	for(var/mob/living/carbon/target in oviewers(7,mask))
		if(HAS_TRAIT(target, TRAIT_FEARLESS))
			return

		if(HAS_TRAIT(target, TRAIT_STUNIMMUNE))
			to_chat(target,"<span class='warning'>A chill runs through your body as you stare into [mask].</span>")
			return

		if(target.mind?.assigned_role == "Chaplain")
			to_chat(target,"<span class='warning'>Your faith protects you as you stare into [mask].</span>")
			return

		to_chat(target,"<span class='warning'>Your joints lock up as you stare into [mask].</span>")
		target.Immobilize(5 SECONDS)

		if(prob(50))
			target.emote("scream")

/obj/effect/proc_holder/spell/self/summon_armament
	name = "Summon Armament"
	desc = "Summon your weapon. Examine it to see what it does."
	action_icon = 'monkestation/icons/obj/items_and_weapons.dmi'
	action_icon_state = "daemon_blade"
	clothes_req = FALSE
	charge_max = 60 SECONDS
	invocation = "none"
	invocation_type = "none"
	school = "transmutation"

/obj/effect/proc_holder/spell/self/summon_armament/cast(mob/living/user)
	var/obj/item/clothing/mask/daemon_mask/mask = user.get_item_by_slot(ITEM_SLOT_MASK)
	if(!istype(mask))
		return

	var/obj/item/armament/new_armament = new mask.armament(loc)
	mask.summoned_armament = new_armament
	user.put_in_hands(new_armament)
