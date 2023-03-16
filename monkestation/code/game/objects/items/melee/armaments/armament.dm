/obj/item/armament
	name = "armament"
	desc = "a daemon weapon."
	force = 30
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	icon = 'monkestation/icons/obj/items_and_weapons.dmi'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "tore", "ripped", "diced", "cut")
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	sharpness = IS_SHARP
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF | INDESTRUCTIBLE
	var/ability_cooldown = 5 SECONDS
	COOLDOWN_DECLARE(armament_cooldown)

/obj/item/armament/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!COOLDOWN_FINISHED(src,armament_cooldown))
		to_chat(user, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, armament_cooldown)*0.1] seconds to use [src] again!</span>")
		return TRUE
	COOLDOWN_START(src,armament_cooldown,ability_cooldown)


/obj/item/armament/attack_self(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src,armament_cooldown))
		to_chat(user, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, armament_cooldown)*0.1] seconds to use [src] again!</span>")
		return TRUE
	COOLDOWN_START(src,armament_cooldown,ability_cooldown)
