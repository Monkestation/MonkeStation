/mob/living/simple_animal/hostile/retaliate/trader/clown
	name = "Clown Merchant"
	desc = "Honk! Clown have wares, if you have coin."
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	faction = list("clown")
	attack_sound = 'sound/items/bikehorn.ogg'
	loot = list(/obj/effect/mob_spawn/human/clown/corpse)
	//This merchant sells "clown fan club gear".
	products = list(
		/obj/item/clothing/under/color/rainbow = 50,
		/obj/item/clothing/under/color/jumpskirt/rainbow = 50,
		/obj/item/bedsheet/clown = 75,
		/obj/item/clothing/mask/gas/clown_hat = 100,
		/obj/item/reagent_containers/spray/waterflower = 150,
	)
	//This merchant seeks the staff of the honkmother.
	wanted_items = list(
		/obj/item/gun/magic/staff/honk = 5000,
	)
	itemrejectphrase = "The only thing I would buy is the staff of the honkmother. I must return it to my people!"
	itemsellcancelphrase = "You insult me, a thousand curses upon your shoelaces!"
	itemsellacceptphrase = "Honk! I'd use the pie of acceptance, but I forgot to bring one."
	interestedphrase = "I-IS THAT IT? THE STAFF OF THE HONKMOTHER? PLEASE, LET ME TAKE IT BACK TO MY PEOPLE! I WILL MAKE YOU RICH!!"
	buyphrase = "Thanks honk, with this I'm one step closer to my own car!"
	nocashphrase = "What a honking joke! Just go steal something of value like those assistants do!"
	lore = list(
		"Hooooonk!",
		"Welcome to clown planet! Or that's what they'll tell you when you visit. Come on by, honk.",
		"The Honkmother giveth, and the Honkmother taketh away. She calls it commerce. HONK!",
		"She honks me, she honks me not...",
		"I'll buy anything from clown planet!! You know, if you have em!",
		"I knew a monthperson once, until their timely demise."
	)

/mob/living/simple_animal/hostile/retaliate/trader/clown/Initialize(mapload)
	. = ..()
	//add rare shop items
	if(prob(10))
		products.Remove(/obj/item/reagent_containers/spray/waterflower)
		products[/obj/item/reagent_containers/spray/waterflower/lube] = 500
