/mob/living/var/lastclienttime = 0
/obj/effect/decal/ssd_indicator
		name = ""
		mouse_opacity = FALSE
		icon = 'monkestation/icons/mob/ssd_indicator.dmi'
		icon_state = "default0"
		layer = FLY_LAYER

/mob/living/var/obj/effect/decal/ssd_indicator/indicator

/mob/living/proc/set_ssd_indicator(var/state)
	if(!indicator)
		indicator = new /obj/effect/decal/ssd_indicator
	indicator.invisibility = invisibility
	if(state && stat != DEAD)
		vis_contents += indicator
	else
		vis_contents -= indicator
	return state

//This proc should stop mobs from having the overlay when someone keeps jumping control of mobs, unfortunately it causes Aghosts to have their character without the SSD overlay, I wasn't able to find a better proc unfortunately
/mob/living/transfer_ckey(mob/new_mob, send_signal = TRUE)
	..()
	set_ssd_indicator(FALSE)
