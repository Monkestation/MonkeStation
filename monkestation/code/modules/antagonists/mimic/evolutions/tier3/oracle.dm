/mob/living/simple_animal/hostile/alien_mimic/tier3/oracle
	name = "oracle mimic"
	real_name = "oracle mimic"
	// icon_state = "oracle"
	// icon_living = "oracle"
	hivemind_modifier = "oracle"
	melee_damage = 8
	playstyle_string = "<span class='big bold'>You are an oracle mimic,</span></b> you can temporarily shed your body to see the truth of the world.<b>"
	mimic_abilities = list(
		/obj/effect/proc_holder/spell/self/mimic/divine
	)

/obj/effect/proc_holder/spell/self/mimic/divine
	name = "Divination"
	desc = "Shed your body and see everything."
	charge_max = 45 SECONDS

	var/mob/living/body = null

/obj/effect/proc_holder/spell/self/mimic/divine/cast(mob/user)
	. = ..()
	if(.)
		return

	body = user
	var/mob/dead/observer/ghost = body.ghostize(1)
	var/datum/action/innate/mimic_hivemind/oracle/ghost_hivemind = new
	ghost_hivemind.body = body
	ghost.color = "purple"
	ghost_hivemind.Grant(ghost)
	while(!QDELETED(body))
		if(body.key)
			break
		if(body.stat -= DEAD)
			break
		sleep(5)
	ghost_hivemind.Remove(ghost)
	body.grab_ghost()
	body = null

/datum/action/innate/mimic_hivemind/oracle //Oracle specific mimic hivemind to use when they is a ghost
	name = "Communicate"
	var/mob/living/body = null

/datum/action/innate/mimic_hivemind/oracle/IsAvailable()
	return TRUE

/datum/action/innate/mimic_hivemind/oracle/Activate()
	var/input = stripped_input(usr, "Send a message to the hivemind.", "Communication", "")
	if(!input || !IsAvailable())
		return
	if(CHAT_FILTER_CHECK(input))
		to_chat(usr, "<span class='warning'>You cannot send a message that contains a word prohibited in IC chat!</span>")
		return
	hivemind_message(usr, input)

/datum/action/innate/mimic_hivemind/oracle/hivemind_message(mob/living/user, message)
	var/my_message
	if(!message)
		return

	var/name_to_use
	var/mob/living/simple_animal/hostile/alien_mimic/mimic_user = body
	name_to_use = mimic_user.real_name

	my_message = "<span class='mimichivemindtitle'><b>Mimic Hivemind</b></span> <span class='mimichivemindbig'><b>[name_to_use] (Spirit Form):</b> [message]</span>"
	for(var/datum/mind/mimic_mind in mimic_user.mimic_team.members)
		var/mob/recipient = mimic_mind.current
		to_chat(recipient, my_message)
	for(var/recipient in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(recipient, user)
		to_chat(recipient, "[link] [my_message]")

	user.log_talk(message, LOG_SAY, tag="mimic hivemind")
