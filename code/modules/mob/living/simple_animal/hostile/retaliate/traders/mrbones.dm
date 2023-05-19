/mob/living/simple_animal/hostile/retaliate/trader/mrbones
	name = "Mr. Bones"
	desc = "A skeleton merchant, he seems very humerus."
	speak_emote = list("rattles")
	speech_span = SPAN_SANS
	sell_sound = 'sound/voice/hiss2.ogg'
	mob_biotypes = list(MOB_UNDEAD, MOB_HUMANOID)
	products = list(
		/obj/item/clothing/head/helmet/skull = 150,
		/obj/item/clothing/mask/bandana/skull = 50,
		// /obj/item/food/cookie/sugar/spookyskull = 10,
		/obj/item/instrument/trombone/spectral = 10000,
		// /obj/item/shovel/serrated = 150
	)
	wanted_items = list(
		/obj/item/reagent_containers/food/condiment/milk = 1000,
		/obj/item/stack/sheet/bone = 420
	)
	buyphrase = "Bone appetit!"
	icon_state = "mrbones"
	gender = MALE
	loot = list(/obj/effect/decal/remains/human)
	lore = list(
		"Hello, I am Mr. Bones!",
		"The ride never ends!",
		"I'd really like a refreshing carton of milk!",
		"I'm willing to play big prices for BONES! Need materials to make merch, eh?",
		"It's a beautiful day outside. Birds are singing, Flowers are blooming... On days like these, kids like you... Should be buying my wares!"
	)
