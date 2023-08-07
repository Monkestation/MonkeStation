/datum/action/cooldown/tar_crown_spawn_altar
	name = "Summon tar altar"
	desc = "Summons a tar altar at your current location (MAX 3)"
	cooldown_time = 1 MINUTES
	button_icon = 'monkestation/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "jungle"
	icon_icon = 'monkestation/icons/mob/actions.dmi'
	button_icon_state = "tar_crown_summon"
	var/obj/item/clothing/head/tar_king_crown/crown

/datum/action/cooldown/tar_crown_spawn_altar/New(Target)
	. = ..()
	crown = target
	LAZYINITLIST(crown.actions)
	crown.actions += src

/datum/action/cooldown/tar_crown_spawn_altar/Trigger()
	. = TRUE
	if(!IsAvailable())
		return FALSE
	var/name = input(owner,"Choose name for the tar shrine","Shrine name")
	if(!name)
		return FALSE
	StartCooldown()
	if(crown.max_tar_shrines == crown.current_tar_shrines.len)
		var/key = pick(crown.current_tar_shrines)
		qdel(crown.current_tar_shrines[key])
		crown.current_tar_shrines -= key
	crown.current_tar_shrines[name] = new /obj/structure/tar_shrine(get_turf(owner))

/datum/action/cooldown/tar_crown_teleport
	name = "Teleport to a tar shrine"
	desc = "Teleports you to a chosen tar shrine"
	cooldown_time = 1 MINUTES
	button_icon = 'monkestation/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "jungle"
	icon_icon = 'monkestation/icons/mob/actions.dmi'
	button_icon_state = "tar_crown_teleport"
	var/obj/item/clothing/head/tar_king_crown/crown

/datum/action/cooldown/tar_crown_teleport/New(Target)
	. = ..()
	crown = target
	LAZYINITLIST(crown.actions)
	crown.actions += src

/datum/action/cooldown/tar_crown_teleport/Trigger()
	. = TRUE
	if(!IsAvailable())
		return FALSE
	var/name = input(owner,"Choose the altar to teleport to") as anything in crown.current_tar_shrines
	if(!name)
		return FALSE

	StartCooldown()
	var/location = get_turf(crown.current_tar_shrines[name])
	animate(owner,2.5 SECONDS,owner.color = "#280025")
	if(!do_after(owner,2.5 SECONDS,owner))
		animate(owner,0.5 SECONDS,owner.color = initial(owner.color))
		return
	new /obj/effect/tar_king/orb_in(get_turf(owner),owner,NORTH)
	do_teleport(owner,location)
	animate(owner,0.5 SECONDS,owner.color = initial(owner.color))
