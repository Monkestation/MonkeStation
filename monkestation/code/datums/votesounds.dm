/datum/votesounds
	var/list/restart = list('monkestation/sound/voice/vote/restartvote1.ogg')
	var/list/gamemode = list('monkestation/sound/voice/vote/gamemodevote1.ogg')
	var/list/mapvote = list('monkestation/sound/voice/vote/mapvote1.ogg')
	var/list/transfer = list('monkestation/sound/voice/vote/transfervote1.ogg')
	var/list/custom = list('monkestation/sound/voice/vote/vote1.ogg')

/datum/votesounds/proc/get_restart_sound()
	return pick(restart)

/datum/votesounds/proc/get_gamemode_sound()
	return pick(gamemode)

/datum/votesounds/proc/get_mapvote_sound()
	return pick(mapvote)

/datum/votesounds/proc/get_transfer_sound()
	return pick(transfer)

/datum/votesounds/proc/get_custom_sound()
	return pick(custom)
