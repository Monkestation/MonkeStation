// 5.56mm (M-90gl Carbine)

/obj/item/projectile/bullet/a556
	name = "5.56mm bullet"
	damage = 35

// 7.62 (Nagant Rifle)

/obj/item/projectile/bullet/a762
	name = "7.62 bullet"
	damage = 60

/obj/item/projectile/bullet/a762_enchanted
	name = "enchanted 7.62 bullet"
	damage = 30

/obj/item/projectile/bullet/a762_enchanted/Impact(atom/A)
	damage_type = pick(BRUTE, BURN, CLONE, TOX, STAMINA, BRAIN)
	..()

