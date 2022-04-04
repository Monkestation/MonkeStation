/obj/item/projectile/bullet/SRN_rocket
	name = "SRN rocket"
	icon = 'monkestation/icons/obj/guns/projectiles.dmi'
	icon_state = "srn_rocket"
	hitsound = "sound/effects/meteorimpact.ogg"
	damage = 20

/obj/item/projectile/bullet/SRN_rocket/on_hit(atom/target)
	..()
	if(ishuman(target))
		playsound(src.loc, "sparks", 100, 1)
		var/mob/living/carbon/human/M = target
		M.oxyloss = 5
		M.hallucination = 15
		to_chat(M, "<span class='alert'>You are struck by a spatial nullifier! Thankfully it didn't affect you... much.</span>")
		if (!M.stat)
			M.emote("scream")
	return BULLET_ACT_HIT
