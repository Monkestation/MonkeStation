/obj/item/storage/belt/sabre/twin
	name = "twin sheath"
	desc = "Two sheaths. One is capable of holding a katana (or bokken) and the other a wakizashi. You could put two wakizashis in if you really wanted to. Now you can really roleplay as a samurai."
	icon_state = "twinsheath"
	item_state = "quiver" //this'll do.
	w_class = WEIGHT_CLASS_BULKY
	var/fitting_swords = list(/obj/item/melee/smith/wakizashi, /obj/item/melee/smith/twohand/katana)
/obj/item/storage/belt/sabre/twin/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_BULKY + WEIGHT_CLASS_NORMAL //katana and waki.
