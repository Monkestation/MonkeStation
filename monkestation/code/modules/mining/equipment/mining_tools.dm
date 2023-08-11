/obj/item/pickaxe/makeshift
	name = "makeshift pickaxe"
	desc = "A pickaxe made with a knife and crowbar taped together, how does it not break?"
	icon = 'monkestation/icons/obj/improvised.dmi'
	icon_state = "pickaxe_makeshift"
	item_state = "pickaxe_makeshift"
	force = 10
	throwforce = 7
	toolspeed = 3 //3 times slower than a normal pickaxe
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=12050) //metal needed for a crowbar and for a knife, why the FUCK does a knife cost 6 metal sheets while a crowbar costs 0.025 sheets? shit makes no sense fuck this
