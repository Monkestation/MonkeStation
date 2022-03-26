/obj/item/projectile/bullet/spatialriftnullifier
	name = "Spatial Rift Nullifier Rocket"
	icon_state = "missle"
	damage = 10

/obj/item/projectile/bullet/spatialriftnullifier/on_hit(atom/target, blocked = FALSE)
	if(istype(target))
		var/obj/singularity/S = target
		var/obj/singularity/energy_ball/T = target
		qdel(S)
		qdel(T)
	else
		explosion(target, 0, 0, 2, 4)
	return BULLET_ACT_HIT
