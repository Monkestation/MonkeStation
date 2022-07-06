/obj/effect/proc_holder/spell/targeted/blinkdagger
	name = "Blink Dagger"
	desc = "Teleports behind you"
	invocation = "Nothing personnel, kid."
	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "blink"
	charge_max = 30 SECONDS
	invocation_type = "shout"
	range = 7
	selection_type = "range"
	clothes_req = FALSE
	invocation_time = 10

/obj/effect/proc_holder/spell/targeted/blinkdagger/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, "<span class='notice'>No target found in range.</span>")
		return

	var/mob/living/carbon/target = targets[1]

	if(!(target in oview(range)))
		to_chat(user, "<span class='notice'>[target.p_theyre(TRUE)] too far away!</span>")
		revert_cast()
		return

	user.put_in_hands(new /obj/item/melee/blinkknife(src))

	target.visible_message("<span class='danger'>[target]'s eyes open wide as they realize the mistake they made.</span>", \
						   "<span class='danger'>You feel a gust of wind behind you, That cant be good.</span>")

	target.adjustBruteLoss(40)
	target.Stun(40)

	var/target_loc = get_turf(target)
	blinkdagger_teleport(user, target_loc)

/obj/effect/proc_holder/spell/targeted/blinkdagger/proc/blinkdagger_teleport(mob/living/user, turf/target_mob)

	var/mob/living/U = user
	playsound(user, 'sound/weapons/zapbang.ogg', 50, TRUE)
	playsound(target_mob, 'sound/weapons/zapbang.ogg', 50, TRUE)
	do_teleport(U, target_mob, channel = TELEPORT_CHANNEL_FREE, no_effects = TRUE, teleport_mode = TELEPORT_MODE_DEFAULT)
