/**
  * # High Frequency Blade
  *
  * The space ninja's weapon.
  *
  * The blade that only the space ninja spawns with.  Comes with 14 base force and 15 throwforce, along with a signature special jaunting system.
  * Allows the user to dash to a location and deflect attacks so long as the user is holding it in one hand.
  * The blade has 3 dashes stored at maximum, recharging one every 20 seconds.
  * Striking a sapient target increases the "fuel cell charge" which, when full, allows the ninja to heal and regain some power cell charge
  * It also has a special feature where if it is tossed at a space ninja who owns it (determined by the ninja suit), the ninja will catch the katana instead of being hit by it.
  *
  */

 #define HF_BLADE_BASE_DAMAGE 14

/obj/item/high_frequency_blade
	name = "high frequency blade"
	desc = "A sword reinforced by a powerful alternating current and resonating at extremely high vibration frequencies. \
		This oscillation weakens the molecular bonds of anything it cuts, thereby increasing its cutting ability."
	worn_icon = 'monkestation/icons/mob/ninja.dmi'
	worn_icon_state = "hf_blade_worn"
	greyscale_config = /datum/greyscale_config/high_frequency_blade
	icon_state = "high_frequency_blade"
	greyscale_config_inhand_left = /datum/greyscale_config/high_frequency_blade/left_hand
	greyscale_config_inhand_right = /datum/greyscale_config/high_frequency_blade/right_hand
	greyscale_colors = COLOR_BLUE_GRAY
	hitsound = 'sound/weapons/bladeslice.ogg'
	pickup_sound = 'sound/items/unsheath.ogg'
	equip_sound = 'sound/items/sheath.ogg'
	//Damage starts at 24, with the multiiplier going up to 2.5x.
	//This means that an accurate player can do up to 45 damage a hit if they land their clicks perfectly.
	//It's a Speed VS Accuracy challenge, should make ninjas fairly skill-based.
	force = 0
	throwforce = 15
	throw_speed = 3
	embedding = list("embed_chance" = 100)
	block_level = 1
	block_upgrade_walk = 1
	block_flags = BLOCKING_NASTY | BLOCKING_PROJECTILE
	sharpness = IS_SHARP_ACCURATE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK

	/// Wielding status.
	var/wielded = FALSE
	/// The color of the slash we create
	var/slash_color = COLOR_BLUE
	/// Previous x position of where we clicked on the target's icon
	var/previous_x
	/// Previous y position of where we clicked on the target's icon
	var/previous_y
	/// The previous target we attacked
	var/datum/weakref/previous_target
	// Katana spark system
	var/datum/effect_system/spark_spread/spark_system
	// Jaunting when not wielded
	var/datum/action/innate/dash/ninja/jaunt
	// Fuel cell recharge progress, for the ninja's healing ability
	// Increases with every hit on a living target
	// Restores Repair Nanopaste as well as part of the ninja's power cell with every full charge
	var/fuel_cell_percentage = 0
	// The Ninja Suit linked to this sword, for cell and nanopaste recharge
	var/obj/item/clothing/suit/space/space_ninja/linked_suit



//Prepares two-hand component, jaunt teleportation, sparks.
/obj/item/high_frequency_blade/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)
	jaunt = new(src)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/high_frequency_blade/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed,force_wielded = 10,force_unwielded = 0,block_power_unwielded = 25, unwield_on_swap = TRUE)

/obj/item/high_frequency_blade/Destroy()
	QDEL_NULL(spark_system)
	QDEL_NULL(jaunt)
	linked_suit = null
	return ..()

//Ninja only. You are not weeb enough to actually use this sword.
/obj/item/high_frequency_blade/attack_self(mob/user)
	if(IS_SPACE_NINJA(user))
		. = ..()
	else
		balloon_alert(user, "You can't wield it!")

/obj/item/high_frequency_blade/pickup(mob/user)
	. = ..()
	if(user && IS_SPACE_NINJA(user))
		jaunt.owner = user
		user?.mind?.martial_art.deflection_chance = 100

/obj/item/high_frequency_blade/dropped(mob/user, silent)
	. = ..()
	wielded = FALSE
	if(user && IS_SPACE_NINJA(user))
		user?.mind?.martial_art.deflection_chance = 0

/obj/item/high_frequency_blade/equipped(mob/user, slot, initial)
	. = ..()
	wielded = FALSE
	if(user && IS_SPACE_NINJA(user))
		if(slot == ITEM_SLOT_HANDS)
			user?.mind?.martial_art.deflection_chance = 100
			return
		user?.mind?.martial_art.deflection_chance = 0



//Returns parent if the target isn't the ninja, otherwise the ninja catches the sword.
/obj/item/high_frequency_blade/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/hit_human = hit_atom
		if(istype(hit_human.wear_suit, /obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/ninja_suit = hit_human.wear_suit
			if(ninja_suit.zandatsu == src)
				returnToOwner(hit_human, doSpark = FALSE, caught = TRUE)
				return

	..()

/obj/item/high_frequency_blade/proc/returnToOwner(mob/living/carbon/human/user, doSpark = TRUE, caught = FALSE)
	if(!istype(user))
		return
	forceMove(get_turf(user))

	if(doSpark)
		spark_system.start()
		playsound(get_turf(src), "sparks", 50, 1)

	var/msg = ""

	if(user.put_in_hands(src))
		msg = "Your High Frequency Blade teleports into your hand!"
	else if(user.equip_to_slot_if_possible(src, ITEM_SLOT_BELT, 0, 1, 1))
		msg = "Your High Frequency Blade teleports back to you, sheathing itself as it does so!"
	else
		msg = "Your High Frequency Blade teleports to your location!"

	if(caught)
		if(loc == user)
			msg = "You catch your High Frequency Blade!"
		else
			msg = "Your High Frequency Blade lands at your feet!"

	if(msg)
		to_chat(user, "<span class='notice'>[msg]</span>")

/obj/item/high_frequency_blade/attack(atom/movable/target, mob/living/user, params)
	if(!IS_SPACE_NINJA(user))
		to_chat(user,"<span class='notice'>You can't wield this!</span>")
		return
	if(linked_suit.stealth_enabled)
		linked_suit.cancel_stealth()
	. = ..()

/obj/item/high_frequency_blade/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!IS_SPACE_NINJA(user))
		to_chat(user,"<span class='notice'>You can't wield this!</span>")
		return
	if(wielded && proximity_flag)
		if(isclosedturf(target) || ismachinery(target) || isstructure(target) || ismob(target))
			slash(target, user, click_parameters)
		if(ismachinery(target) || isstructure(target))
			user.changeNext_move(0.3 SECONDS)
			spark_system.start()
			playsound(user, "sparks", 30, TRUE)
			playsound(user, 'sound/weapons/blade1.ogg', 30, TRUE)
			target.emag_act(user)
	if(!wielded && !proximity_flag && !target.density)
		jaunt.teleport(user, target)
		return

/// triggered on wield of two handed item
/obj/item/high_frequency_blade/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = TRUE
	if(user && IS_SPACE_NINJA(user))
		user?.mind?.martial_art.deflection_chance = 0


/// triggered on unwield of two handed item
/obj/item/high_frequency_blade/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = FALSE
	if(user && IS_SPACE_NINJA(user))
		user?.mind?.martial_art.deflection_chance = 100


/obj/item/high_frequency_blade/proc/slash(atom/target, mob/living/user, params)
	var/list/modifiers = params2list(params)
	user.changeNext_move(0.25 SECONDS)
	user.do_attack_animation(target, "nothing")

	//in case we arent called by a client
	var/x_slashed = text2num(modifiers[ICON_X]) || world.icon_size/2
	var/y_slashed = text2num(modifiers[ICON_Y]) || world.icon_size/2

	//MGR style slash effect
	new /obj/effect/temp_visual/slash(get_turf(target), target, x_slashed, y_slashed, slash_color) //Convert to particle effect?

	var/damage_mod = 1.0
	//if the same target, we calculate a damage multiplier if you swing your mouse around
	if(target == previous_target?.resolve())
		var/x_mod = (previous_x - x_slashed) / 2
		var/y_mod = (previous_y - y_slashed) / 2
		//Between 1x and 2.46x (rounded to 2.5x) with a clamp to ensure that strangely shaped sprites won't break the system.
		damage_mod = clamp(round((abs(x_mod) + abs(y_mod) / 13), 0.1), 1, 2.5)
	//Final damage is the base damage multiplied by the distance modifier, with a reduction for damage already dealt from the attack itself.
	var/final_damage = HF_BLADE_BASE_DAMAGE*damage_mod

	previous_target = WEAKREF(target)
	previous_x = x_slashed
	previous_y = y_slashed
	playsound(src, 'sound/weapons/bladeslice.ogg', 75, vary = TRUE)
	playsound(src, 'sound/weapons/zapbang.ogg', 30, vary = TRUE)
	if(isliving(target))
		var/mob/living/living_target = target
		var/def_check = living_target.getarmor(type = "melee")


		//Applies equal to 14 * the multiplier from pixel distance
		living_target.apply_damage(damage = final_damage-force, damagetype = BRUTE, blocked = def_check, def_zone = user.zone_selected)
		log_combat(user, living_target, "slashed", src)

		//Chance to gib a dead target with repeated strikes
		if(living_target.stat == DEAD && prob(final_damage))
			living_target.visible_message(span_danger("[living_target] explodes in a shower of gore!"), blind_message = span_hear("You hear organic matter ripping and tearing!"))
			living_target.gib()
			log_combat(user, living_target, "gibbed", src)

			//Target must have been sentient to recharge the fuel cell.
			if(ishuman(living_target))
				var/mob/living/carbon/human/recharge_check
				if(recharge_check?.last_mind)
					fuel_cell_percentage += 25
					if(prob(25))
						user.say(pick("BULLSEYE!", "DEAD ON!", "*laugh", "Playtime's over!", "*flip"), forced = "ninjaboost")
		//Recharge the fuel cell so long as the target is still fighting back
		else if(living_target.mind && living_target.stat == CONSCIOUS)
			//Between 7.5 and 18.75 a hit. Designed to take 2 kills to fully recharge a fuel cell.
			fuel_cell_percentage += final_damage / 2

	else if(iswallturf(target) && prob(final_damage*0.5))
		var/turf/closed/wall/wall_target = target
		wall_target.dismantle_wall()
	else if(ismineralturf(target) && prob(final_damage))
		var/turf/closed/mineral/mineral_target = target
		mineral_target.gets_drilled()
	else if(ismachinery(target) && prob(final_damage*0.5))
		var/obj/machinery/machinery_target = target
		machinery_target.deconstruct()


	//Recharge the ninja's power cell and repair nanopaste ability
	if(fuel_cell_percentage >= 100)
		balloon_alert(user, "Nanopaste restored!")
		to_chat(user, "<span class='notice'>Your power cell and Nanopaste have been restored!</span>")
		linked_suit.nanopaste_available = TRUE
		//20% of charge from a full fuel cell.
		//A ninja locked into combat can stay fighting without too much worry
		//And yes, this CAN take you above max charge deliberately.
		linked_suit.cell.charge += 2000
		fuel_cell_percentage = 0


/obj/effect/temp_visual/slash
	icon = 'monkestation/icons/mob/ninja.dmi'
	icon_state = "high_freq_slash"
	alpha = 150
	duration = 0.5 SECONDS
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/slash/Initialize(mapload, atom/target, x_slashed, y_slashed, slash_color)
	. = ..()
	if(!target)
		return
	var/matrix/new_transform = matrix()
	new_transform.Turn(rand(1, 360)) // Random slash angle
	var/datum/decompose_matrix/decomp = target.transform.decompose()
	new_transform.Translate((x_slashed - world.icon_size/2) * decomp.scale_x, (y_slashed - world.icon_size/2) * decomp.scale_y) // Move to where we clicked
	//Follow target's transform while ignoring scaling
	new_transform.Turn(decomp.rotation)
	new_transform.Translate(decomp.shift_x, decomp.shift_y)
	new_transform.Translate(target.pixel_x, target.pixel_y) // Follow target's pixel offsets
	transform = new_transform
	//Double the scale of the matrix by doubling the 2x2 part without touching the translation part
	var/matrix/scaled_transform = new_transform + matrix(new_transform.a, new_transform.b, 0, new_transform.d, new_transform.e, 0)
	animate(src, duration*0.5, color = slash_color, transform = scaled_transform, alpha = 255)

/datum/action/innate/dash/ninja
	current_charges = 3
	max_charges = 3
	charge_rate = 20 SECONDS
	recharge_sound = null
