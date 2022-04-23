/obj/item/projectile/bullet/SRN_rocket
	name = "SRN rocket"
	icon = 'monkestation/icons/obj/guns/projectiles.dmi'
	icon_state = "srn_rocket"
	hitsound = "sound/effects/meteorimpact.ogg"
	damage = 10
	ricochets_max = 0 //it's a MISSILE

/obj/item/projectile/bullet/SRN_rocket/on_hit(atom/target, mob/user, blocked = FALSE)
	..()
//	if(istype(target, /obj/singularity))
//		var/atom/movable/firer = user
//		user.client.give_award(/datum/award/achievement/misc/singularity_buster, user)
//		message_admins("[firer] nullified the singularity")
//		user.emote("scream")
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		playsound(src.loc, "pierce", 100, 1)
		M.oxyloss = 5
		M.hallucination = 15
		to_chat(M, "<span class='alert'>You are struck by a spatial nullifier! Thankfully it didn't affect you... much.</span>")
		M.emote("scream")
	else
		playsound(src.loc, "sparks", 100, 1)

	return BULLET_ACT_HIT

/obj/item/projectile/bullet/SRN_rocket/Impact(atom/A)
	. = ..()
	if(istype(A, /obj/singularity))
		var/mob/living/user = firer
		firer = user
		user.client.give_award(/datum/award/achievement/misc/singularity_buster, user)
		message_admins("[firer] THIS WORKS")
		user.emote("scream")

		new/obj/singularity/spatial_rift(A.loc)
		qdel(A)

		for(var/mob/M as() in GLOB.player_list)
			if(M.get_virtual_z_level() == get_virtual_z_level())
				SEND_SOUND(M, 'sound/magic/charge.ogg')
				to_chat(M, "<span class='boldannounce'>You feel reality distort for a moment...</span>")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "delam", /datum/mood_event/delam)
				shake_camera(M, 15, 3)
				continue
	return
