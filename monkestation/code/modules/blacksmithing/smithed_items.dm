/obj/item/basaltblock
	name = "basalt block"
	desc = "A block of basalt."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "sandvilnoir"


/obj/item/smithing
	name = "base class /obj/item/smithing"
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "unfinished"
	///quality. Changed by the smithing process. the quality of the item determines damage and other stats
	var/quality = 0
	///Changed by the smithing process the blunt multipler of the item
	var/blunt_mult = 0
	///Changed by the smithing process the sharp multipler of the item
	var/sharp_mult = 0
	///Changed by the smithing process the wealth multipler of the item
	var/wealth_mult = 0
	///What this item needs to be hit by to create finalitem
	var/obj/item/finishingitem = /obj/item/stick
	///the actual final item
	var/obj/item/finalitem
	/// if its an artifiact
	var/artifact = FALSE
	///If sharp or blunt
	var/sharp_type
	/// the modifer to total damage
	var/divisor = 1
	///the modifer to total throwing damage
	var/throw_divisor = 4
	///if the item is two handable
	var/two_hand = FALSE

/obj/item/ingot
	name = "ingot"
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "ingot"
	var/workability = FALSE //if the ingot is workable heat it in furnace to make it so

/obj/item/ingot/attack_hand(mob/user)
	if(workability = FALSE)
		return ..()
	var/prot = 0
	var/mob/living/carbon/human/Smither
	if(ishuman(user))
		Smither = user
		if(Smither.gloves)
			var/obj/item/clothing/gloves/G = Smither.gloves //check if you have gloves otherwise burn city
			if(G.max_heat_protection_temperature)
				prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1
	if(prot > 0 || HAS_TRAIT(user, TRAIT_RESISTHEAT) || HAS_TRAIT(user, TRAIT_RESISTHEATHANDS))
		to_chat(user, "<span class='notice'>You pick up the [src].</span>")
		return ..()
	else
		to_chat(user, "<span class='warning'>You try to move the [src], but you burn your hand on it!</span>")
	if(Smither)
		var/obj/item/bodypart/affecting = Smither.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
			Smither.update_damage_overlays()

/obj/item/ingot/iron
	name = "Iron Ingot"
	custom_materials = list(/datum/material/iron=12000)

/obj/item/ingot/diamond
	name = "Diamond Ingot"
	custom_materials = list(/datum/material/diamond=12000) //yeah ok

/obj/item/ingot/uranium
	name = "Uranium Ingot"
	custom_materials = list(/datum/material/uranium=12000)

/obj/item/ingot/plasma
	name = "Plasma Ingot"
	custom_materials = list(/datum/material/plasma=12000)//yeah ok

/obj/item/ingot/copper
	name = "Copper Ingot"
	custom_materials = list(/datum/material/copper=12000)//yeah ok

/obj/item/ingot/gold
	name = "Gold Ingot"
	custom_materials = list(/datum/material/gold=12000)

/obj/item/ingot/silver
	name = "Silver Ingot"
	custom_materials = list(/datum/material/silver=12000)

/obj/item/ingot/bananium
	name = "Hilarious Ingot"
	custom_materials = list(/datum/material/bananium=12000)

/obj/item/ingot/titanium
	name = "Titanium Ingot"
	custom_materials = list(/datum/material/titanium=12000)

/obj/item/ingot/adamantine
	name = "Adamant Ingot"
	custom_materials = list(/datum/material/adamantine=12000)

/obj/item/ingot/cult
	name = "Runed-Metal Ingot"
	custom_materials = list(/datum/material/runedmetal=12000)

/obj/item/ingot/bronze
	name = "Bronze Ingot"
	custom_materials = list(/datum/material/bronze=12000)

/obj/item/ingot/bronze/ratvar
	name = "Brass ingot"
	desc = "On closer inspection, what appears to be wholly-unsuitable-for-smithing brass is actually more structurally stable bronze. Ratvar must have transformed the brass into bronze. Somehow."


/obj/item/smithing/attackby(obj/item/Item, mob/user)
	if(istype(Item, finishingitem))
		qdel(Item)
		startfinish()
	else
		return ..()

/obj/item/smithing/proc/startfinish()
	var/obj/item/melee/smith/finished_product = new finalitem
	var/modifer = sharp_mult
	if(sharp_type == "blunt")
		modifer = blunt_mult
	finished_product.force = ((finished_product.force + quality) / divisor) * modifer
	finished_product.throwforce = ((finished_product.force + quality) / (throw_divisor)) * modifer
	if(istype(finished_product, /obj/item/melee/smith/hammer))
		finished_product.qualitymod = quality / 4
	if(istype(finished_product, /obj/item/shovel/smithed) || istype(finished_product, /obj/item/pickaxe/smithed))
		if(quality > 0)
			finalitem.toolspeed = max(0.05, (1 - (quality / 10)))
		else
			finalitem.toolspeed *= max(1, (quality * - 1))
	if(two_hand)
		finished_product.AddComponent(/datum/component/two_handed, force_unwielded=finished_product.force, force_wielded=finished_product.wield_force, icon_wielded="[icon_state]")
	if(finished_product.force > 50)
		finished_product.force = 50
	if(finished_product.throwforce > 50)
		finished_product.throwforce = 50
	finalitem = finished_product
	dofinish()

/obj/item/smithing/proc/dofinish()
	var/quality_name
	switch(quality)
		if(-1000 to -5)
			quality_name = "awful"
		if(-1000 to -2)
			quality_name = "shoddy"
		if(-1000 to -1)
			quality_name =  "poor"
		if(-1 to 1)
			quality_name = "normal"
		if(1 to 3.5)
			quality_name = "above-average"
		if(3.5 to 5.5)
			quality_name = "good"
		if(5.5 to 7.5)
			quality_name = "excellent"
		if(7.5 to 10)
			quality_name = "masterwork"
		if(10 to INFINITY)
			quality_name = "legendary"
	var/datum/material/mat = custom_materials[1]
	finalitem.set_custom_materials(custom_materials)
	mat = mat.name
	if(artifact)
		dwarfyartifact(finalitem, mat)
	else
		finalitem.name = "[quality_name] [mat] [initial(finalitem.name)]"
		finalitem.desc = "A [quality_name] [initial(finalitem.name)]. Its quality is [quality]."
	finalitem.forceMove(get_turf(src))
	qdel(src)


/obj/item/smithing/proc/dwarfyartifact(var/obj/item/finalitem, var/mat)
	var/finaldesc = "A [initial(finalitem.name)] made of [mat], all craftsmanship is of the highest quality. It "
	switch(pick(1,2,3,4,5))
		if(1)
			finaldesc += "is encrusted with [pick("","synthetic ","multi-faceted ","magical ","sparkling ") + pick("rubies","emeralds","jade","opals","lapiz lazuli")]."
		if(2)
			finaldesc += "is laced with studs of [pick("gold","silver","aluminium","titanium")]."
		if(3)
			finaldesc += "is encircled with bands of [pick("durasteel","metallic hydrogen","ferritic-alloy","plasteel","duranium")]."
		if(4)
			finaldesc += "menaces with spikes of [pick("ytterbium","uranium","white pearl","black steel")]."
		if(5)
			finaldesc += "is encrusted with [pick("","synthetic ","multi-faceted ","magical ","sparkling ") + pick("rubies","emeralds","jade","opals","lapis lazuli")],laced with studs of [pick("gold","silver","aluminium","titanium")], encircled with bands of [pick("durasteel","metallic hydrogen","ferritic-alloy","plasteel","duranium")] and menaces with spikes of [pick("ytterbium","uranium","white pearl","black steel")]."
	finalitem.desc = finaldesc
	finalitem.name = pick("Delersibnir", "Nekolangrir", "Zanoreshik","Öntakrítin", "Nogzatan", "Vunomam", "Nazushagsaldôbar", "Sergeb", "Zafaldastot", "Vudnis", "Dostust", "Shotom", "Mugshith", "Angzak", "Oltud", "Deleratîs", "Nökornomal") //one of these is literally BLOOD POOL CREATE.iirc its Nazushagsaldôbar.

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	finalitem = /obj/item/melee/smith/hammer
	icon_state = "hammer"
	divisor = 2
	sharp_type = "blunt"

/obj/item/smithing/scytheblade
	name = "smithed scythe head"
	finalitem = /obj/item/scythe/smithed
	icon_state = "scythe"
	sharp_type = "sharp"


/obj/item/smithing/shovelhead
	name = "smithed shovel head"
	finalitem = /obj/item/shovel/smithed
	icon_state = "shovel"
	sharp_type = "sharp"

/obj/item/smithing/cogheadclubhead
	name = "smithed coghead club head"
	finalitem = /obj/item/melee/smith/cogheadclub
	icon_state = "coghead"
	sharp_type = "blunt"

/obj/item/smithing/javelinhead
	name = "smithed javelin head"
	finalitem = /obj/item/melee/smith/twohand/javelin
	icon_state = "javelin"
	sharp_type = "sharp"
	throw_divisor = 0.5
	two_hand = TRUE

/obj/item/smithing/pikehead
	name = "smithed pike head"
	finalitem = /obj/item/melee/smith/twohand/pike
	icon_state = "pike"
	two_hand = TRUE
	throw_divisor = 10
	sharp_type = "sharp"

/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	finalitem = /obj/item/pickaxe/smithed
	icon_state = "pickaxe"
	sharp_type = "sharp"
	divisor = 2
	throw_divisor = 4

/obj/item/smithing/prospectingpickhead
	name = "smithed prospector's pickaxe head"
	finalitem = /obj/item/mining_scanner/prospector
	icon_state = "minipick"
	sharp_type = "sharp"
	divisor = 2
	throw_divisor = 4

/obj/item/smithing/shortswordblade
	name = "smithed gladius blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword
	icon_state = "gladius"
	sharp_type = "sharp"

/obj/item/smithing/scimitarblade
	name = "smithed scimitar blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword/scimitar
	icon_state = "scimitar"
	sharp_type = "sharp"

/obj/item/smithing/wakiblade
	name = "smithed wakizashi blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/wakizashi
	icon_state = "waki"
	sharp_type = "sharp"

/obj/item/smithing/sabreblade
	name = "smithed sabre blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/sabre
	icon_state = "sabre"
	sharp_type = "sharp"

/obj/item/smithing/rapierblade
	name = "smithed rapier blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/sabre/rapier
	icon_state = "rapier"
	sharp_type = "sharp"

/obj/item/smithing/knifeblade
	name = "smithed knife blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/kitchen/knife
	icon_state = "dagger"
	sharp_type = "sharp"
	divisor = 2
	throw_divisor = 1

/obj/item/smithing/knifeblade/startfinish()
	finalitem.icon = 'monkestation/icons/obj/smith.dmi'
	finalitem.icon_state = "dagger"
	finalitem.name = "dagger"
	finalitem.desc = "A dagger."
	var/mutable_appearance/overlay = mutable_appearance('monkestation/icons/obj/smith.dmi', "daggerhilt")
	overlay.appearance_flags = RESET_COLOR
	finalitem.add_overlay(overlay)
	if(finalitem.force < 0)
		finalitem.force = 0
	..()

/obj/item/smithing/broadblade
	name = "smithed broadsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/broadsword
	icon_state = "broadsword"
	sharp_type = "sharp"
	two_hand = TRUE

/obj/item/smithing/zweiblade
	name = "smithed zweihander blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/zweihander
	icon_state = "zwei"
	sharp_type = "sharp"
	two_hand = TRUE

/obj/item/smithing/halberdhead
	name = "smithed halberd head"
	finalitem = /obj/item/melee/smith/twohand/halberd
	icon_state = "halberd"
	throw_divisor = 3
	sharp_type = "sharp"
	two_hand = TRUE

/obj/item/smithing/glaivehead
	name = "smithed glaive head"
	finalitem = /obj/item/melee/smith/twohand/glaive
	icon_state = "glaive"
	throw_divisor = 1
	sharp_type = "sharp"
	two_hand = TRUE

/obj/item/smithing/katanablade
	name = "smithed katana blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/katana
	icon_state = "katana"
	two_hand = TRUE
	sharp_type = "sharp"

/obj/item/smithing/anvilplate
	name = "smited anvil plating"
	desc = "A forged anvil plating used on an anvil to increase it's quality"
	icon_state = "unfinished" //fix this i don't got me a sprite

/obj/item/stick
	name = "wooden rod"
	desc = "It's a rod, suitable for use of a handle of a tool. Also could serve as a weapon, in a pinch."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "stick"
	force = 7

/obj/item/swordhandle
	name = "sword handle"
	desc = "It's a crudlely shaped wooden sword hilt."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "shorthilt"
