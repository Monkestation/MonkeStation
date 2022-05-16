/obj/item/melee/smith
	name = "base class obj/item/melee/smith" //tin. handles overlay and quality and shit.
	desc = "cringe"
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	force = 6
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	var/quality
	var/overlay_state = "stick"
	var/mutable_appearance/overlay
	var/wielded_mult = 1
	var/wield_force = 15

/obj/item/melee/smith/Initialize()
	..()
	if(desc == "cringe")
		desc = "A handmade [name]."
	overlay = mutable_appearance(icon, overlay_state)
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0


/obj/item/melee/smith/twohand
	item_flags = NEEDS_PERMIT //it's a bigass sword/spear. beepsky is going to give you shit for it.
	sharpness = IS_SHARP
	force = 10
	wielded_mult = 1.75
	w_class = WEIGHT_CLASS_BULKY

/obj/item/melee/smith/twohand/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.



///////////////////////////
//        Mining         //
///////////////////////////
/obj/item/mining_scanner/prospector
	name = "prospector's pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "minipick" //todo:sprite
	sharpness = IS_SHARP//it doesnt have a blade it has a point

/obj/item/mining_scanner/prospector/Initialize()
	..()
	var/mutable_appearance/overlay
	desc = "A handmade [name]."
	overlay = mutable_appearance(icon, "minihandle")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/pickaxe/smithed
	name = "pickaxe"
	desc = "A pickaxe."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "pickaxe"
	sharpness = IS_SHARP

/obj/item/pickaxe/smithed/Initialize()
	..()
	desc = "A handmade [name]."
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "stick")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/pickaxe/smithed/attack_self(mob/user)
		to_chat(user, "<span class='notice'>Tool does not have a configureable dig range.</span>")

/obj/item/shovel/smithed
	name = "shovel"
	desc = "A shovel."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "shovel"
	sharpness = IS_SHARP //it cuts through the earth

/obj/item/shovel/smithed/Initialize()
	..()
	desc = "A handmade [name]."
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "shovelhandle")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0


///////////////////////////
//        Spears         //
///////////////////////////


/obj/item/melee/smith/twohand/halberd
	name = "halberd"
	icon_state = "halberd"
	w_class = WEIGHT_CLASS_HUGE
	overlay_state = "spearhandle"
	slot_flags = ITEM_SLOT_BACK
	wielded_mult = 2.5

/obj/item/melee/smith/twohand/halberd/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/melee/smith/twohand/javelin
	name = "javelin"
	icon_state = "javelin"
	overlay_state = "longhandle"
	wielded_mult = 1.5
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_SHARP


/obj/item/melee/smith/twohand/javelin/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/melee/smith/twohand/glaive
	name = "glaive"
	icon_state = "glaive"
	overlay_state = "longhandle"
	slot_flags = ITEM_SLOT_BACK
	wielded_mult = 2

/obj/item/melee/smith/twohand/glaive/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)


/obj/item/melee/smith/twohand/pike
	name = "pike"
	icon_state = "pike"
	w_class = WEIGHT_CLASS_HUGE
	overlay_state = "longhandle"
	reach = 2 //yeah ok
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_SHARP

//////////////////////////
//      Other Melee     //
///////////////////////////


/obj/item/melee/smith/hammer//blacksmithing, not warhammer.
	name = "hammer"
	icon_state = "hammer"
	overlay_state = "hammerhandle"
	var/qualitymod = 0

/obj/item/scythe/smithed //we need to inherit scythecode, but that's about it.


/obj/item/melee/smith/cogheadclub
	name = "coghead club"
	icon_state = "coghead"
	item_flags = NEEDS_PERMIT
	overlay_state = "stick"

/obj/item/melee/smith/shortsword
	name = "gladius"
	force = 9
	item_flags = NEEDS_PERMIT
	sharpness = IS_SHARP
	icon_state = "gladius"
	overlay_state = "gladiushilt"

/obj/item/melee/smith/shortsword/scimitar
	name = "scimitar"
	sharpness = IS_SHARP
	icon_state = "scimitar"
	overlay_state = "scimitarhilt"

/obj/item/melee/smith/wakizashi
	name = "wakizashi"
	sharpness = IS_SHARP
	force = 7
	item_flags = NEEDS_PERMIT
	obj_flags = UNIQUE_RENAME
	icon_state = "waki"
	overlay_state = "wakihilt"


/obj/item/melee/smith/twohand/broadsword
	name = "broadsword"
	icon_state = "broadsword"
	overlay_state = "broadhilt"
	wielded_mult = 1.8

/obj/item/melee/smith/twohand/zweihander
	name = "zweihander"
	icon_state = "zwei"
	overlay_state = "zweihilt"
	force = 4
	wielded_mult = 3 //affected more by quality. a -1 is 25% less damage, a +1 is 25% more. These bonuses are tripled when wielded.

/obj/item/melee/smith/twohand/katana
	name = "katana"
	icon_state = "katana"
	overlay_state = "katanahilt"
	force = 7
	wielded_mult = 2
	item_flags = NEEDS_PERMIT //want to name your katana "DEMON BLADE" or some shit? go ahead, idiot.
	obj_flags = UNIQUE_RENAME

/obj/item/melee/smith/sabre
	name = "sabre"
	icon_state = "sabre"
	sharpness = IS_SHARP
	overlay_state = "sabrehilt"
	armour_penetration = 15
	force = 9
	hitsound = 'sound/weapons/rapierhit.ogg'
	item_flags = NEEDS_PERMIT

/obj/item/melee/smith/sabre/rapier
	name = "rapier"
	icon_state = "rapier"
	sharpness = IS_SHARP
	overlay_state = "rapierhilt"
	force = 6 //less force, stronger parry
	sharpness = IS_SHARP
	armour_penetration = 30

//unique hammers
/obj/item/melee/smith/hammer/toolbox
	name = "toolbox hammer"
	desc = "A metal filled toolbox on a stick. Useable as a really shitty hammer."
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "toolbox"
	overlay_state = "hammerhandle"
	qualitymod = -2

/obj/item/melee/smith/hammer/narsie
	name = "runemetal hammer"
	custom_materials = list(/datum/material/runedmetal = 12000)
	desc = "A metal hammer inscribed with geometeric runes."
	qualitymod = 1

/obj/item/melee/smith/hammer/narsie/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.Paralyze(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							 "<span class='cultlarge'>\"You shouldn't be touching tools that aren't yours.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/smith/hammer/ratvar
	name = "brass hammer"
	custom_materials = list(/datum/material/bronze = 12000)
	desc = "A brass hammer inscribed with... writing? You can't read it."
	qualitymod = 1

/obj/item/melee/smith/hammer/ratvar/attack(mob/living/target, mob/living/carbon/human/user)
	if(!is_servant_of_ratvar(user))
		user.Paralyze(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", "<span class='neovgre'>\"You shouldn't be touching tools that aren't yours.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/smith/hammer/debug
	name = "debugging hammer"
	desc = "A DEBUGGING HAMMER!! EPIC!!."
	qualitymod = 10
