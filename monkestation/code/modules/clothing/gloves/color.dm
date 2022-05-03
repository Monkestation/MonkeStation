/obj/item/clothing/gloves/color/yellow/catgloves
	desc = "95% of workplace accidents are caused by cats"
	name = "cat gloves"
	icon = 'monkestation/icons/obj/clothing/gloves.dmi'
	worn_icon = 'monkestation/icons/mob/gloves.dmi'
	icon_state = "catgloves"
	item_state = "catgloves"
	worn_icon_state = "catgloves"

/obj/item/clothing/gloves/color/yellow/catgloves/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H,TRAIT_NOGUNS,CLOTHING_TRAIT)
		ENABLE_BITFIELD(clothing_flags, NOTDROPPABLE)

/obj/item/clothing/gloves/color/yellow/catgloves/dropped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H,TRAIT_NOGUNS,CLOTHING_TRAIT)

