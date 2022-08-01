/mob/living/simple_animal/hostile/retaliate/trader/mrbones
	name = "Alien Merchant"
	desc = "An alien, seems kinda fishy!"
	icon_state = "abductor"
	icon = 'icons/effects/landmarks_static.dmi'
	speak_emote = list("rattles")
	speech_span = SPAN_SANS
	sell_sound = 'sound/voice/hiss2.ogg'
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	products = list(
		/obj/item/organ/heart/gland/chem = 2000,
		/obj/item/organ/heart/gland/electric = 1500,
		/obj/item/organ/heart/gland/ventcrawling = 2500,
		/obj/item/organ/heart/gland/slime = 700,
		/obj/item/organ/heart/gland/heals = 4000,
	)
	wanted_items = list(
		/obj/item/organ/heart = 200,
		/obj/item/organ/lungs = 150,
		/obj/item/organ/stomach = 150,
		/obj/item/organ/liver = 150,
		/obj/item/organ/eyes = 300,
		/obj/item/organ/ears = 100,
		/obj/item/organ/lungs/plasmaman = 300,
	)
	buyphrase = "..."
	gender = PLURAL
	loot = list(/obj/effect/mob_spawn/human/abductor)
	lore = list(
	)
