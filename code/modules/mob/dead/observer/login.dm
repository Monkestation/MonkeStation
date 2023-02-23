/mob/dead/observer/Login()
	..()

	if(IsAdminGhost(src))
		has_unlimited_silicon_privilege = 1

	if(client.prefs.unlock_content)
		ghost_orbit = client.prefs.ghost_orbit

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

