/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	attack_weight = 2
	force = 15
	throwforce = 10
	item_state = "pickaxe"
	worn_icon_state = "pickaxe"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	materials = list(/datum/material/iron=2000) //one sheet, but where can you make them?
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb = list("hit", "pierced", "sliced", "attacked")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins digging into [user.p_their()] chest!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] couldn't do it!</span>")
	return SHAME


/obj/item/pickaxe/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/stack/sheet/animalhide/goliath_hide))
		if(toolspeed != 0.1)
			I.use(1)
			toolspeed = max(0.1, toolspeed - 0.1)
			to_chat(user, span_notice("You apply a Goliath Plate to the pickaxe making it sturdier"))
		else
			to_chat(user, span_notice("You can't reinforce the pickaxe anymore!"))
/obj/item/pickaxe/mini
	name = "compact pickaxe"
	desc = "A smaller, compact version of the standard pickaxe."
	icon_state = "minipick"
	force = 10
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=1000)

/obj/item/pickaxe/silver
	name = "silver-plated pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	worn_icon_state = "spickaxe"
	toolspeed = 0.5 //mines faster than a normal pickaxe, bought from mining vendor
	desc = "A silver-plated pickaxe that mines slightly faster than standard-issue."
	force = 17

/obj/item/pickaxe/diamond
	name = "diamond-tipped pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	worn_icon_state = "dpickaxe"
	toolspeed = 0.3
	desc = "A pickaxe with a diamond pick head. Extremely robust at cracking rock walls and digging up dirt."
	force = 19

/obj/item/pickaxe/drill
	name = "mining drill"
	icon_state = "handdrill"
	item_state = "jackhammer"
	worn_icon_state = "jackhammer"
	slot_flags = ITEM_SLOT_BELT
	toolspeed = 0.6 //available from roundstart, faster than a pickaxe.
	usesound = 'sound/weapons/drill.ogg'
	hitsound = 'sound/weapons/drill.ogg'
	desc = "An electric mining drill for the especially scrawny."

/obj/item/pickaxe/drill/cyborg
	name = "cyborg mining drill"
	desc = "An integrated electric mining drill."
	flags_1 = NONE

/obj/item/pickaxe/drill/cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/pickaxe/drill/diamonddrill
	name = "diamond-tipped mining drill"
	icon_state = "diamonddrill"
	toolspeed = 0.2
	desc = "Yours is the drill that will pierce the heavens!"

/obj/item/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "diamond-tipped cyborg mining drill" //To inherit the NODROP_1 flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	toolspeed = 0.2

/obj/item/pickaxe/drill/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	worn_icon_state = "jackhammer"
	toolspeed = 0.1 //the epitome of powertools. extremely fast mining, laughs at puny walls
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	desc = "Cracks rocks with sonic blasts, and doubles as a demolition power tool for smashing walls."

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 8
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	throwforce = 4
	item_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharpness = IS_SHARP

/obj/item/shovel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 150, 40) //it's sharp, so it works, but barely.

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins digging their own grave!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] couldn't do it!</span>")
	return SHAME

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	worn_icon_state = "spade"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
