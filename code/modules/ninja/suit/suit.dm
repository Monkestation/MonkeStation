/**
  * # Ninja Suit
  *
  * Space ninja's suit.  Provides him with most of his powers.
  *
  * Space ninja's suit.  Gives space ninja all his iconic powers, which are mostly kept in
  * the folder ninja_equipment_actions.  Has a lot of unique stuff going on, so make sure to check
  * the variables.  Check suit_attackby to see radium interaction, disk copying, and cell replacement.
  *
  */
/obj/item/clothing/suit/space/space_ninja
	name = "ninja suit"
	desc = "A unique, vacuum-proof suit of nano-enhanced armor designed specifically for Spider Clan assassins."
	icon_state = "ninja_armor"
	item_state = "s-ninja_suit"
	blocks_shove_knockdown = TRUE
	greyscale_config_worn = /datum/greyscale_config/ninja_outfits
	greyscale_colors = "#000000"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/stock_parts/cell)
	resistance_flags = LAVA_PROOF | ACID_PROOF
	armor = list(MELEE = 40, BULLET = 30, LASER = 20,ENERGY = 30, BOMB = 30, BIO = 30, RAD = 30, FIRE = 100, ACID = 100)
	strip_delay = 12 SECONDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	slowdown = -0.3
	actions_types = list(/datum/action/item_action/initialize_ninja_suit, /datum/action/item_action/ninjastatus, /datum/action/item_action/ninjaboost, /datum/action/item_action/ninjapulse, /datum/action/item_action/ninjastar, /datum/action/item_action/ninja_sword_recall, /datum/action/item_action/ninja_stealth)

	///The person wearing the suit
	var/mob/living/carbon/human/affecting = null
	///The suit's spark system, used for... sparking.
	var/datum/effect_system/spark_spread/spark_system
	///The suit's stored research.  Used for the research objective (see antagonist file)
	var/datum/techweb/stored_research
	///The high frequency blade registered with the suit, used for recalling and catching the sword.  Set when the ninja outfit is created.
	var/obj/item/high_frequency_blade/zandatsu
	//Power cell for the ninja suit, since we're not taking the /tg/ spacesuit changes.
	var/obj/item/stock_parts/cell/ninja/cell = new

	//The custom color for the GAGS component
	var/suit_color
	///The space ninja's hood.
	var/obj/item/clothing/head/helmet/space/space_ninja/n_hood
	///The space ninja's shoes.
	var/obj/item/clothing/shoes/space_ninja/n_shoes
	///The space ninja's gloves.
	var/obj/item/clothing/gloves/space_ninja/n_gloves
	///The space ninja's mask.
	var/obj/item/clothing/mask/gas/space_ninja/n_mask
	///The Space Ninja's jumpsuit
	var/obj/item/clothing/under/syndicate/ninja/n_suit

	///Whether or not the suit is currently booted up.  Starts off.
	var/suit_initialized = FALSE//Suit starts off.
	///The suit's current cooldown.  If not 0, blocks usage of most abilities, and decrements its value by 1 every process
	var/suit_cooldown = 0
	///How much energy the suit expends in a single process
	var/suit_cost = 1
	///Additional energy cost for cloaking per process
	var/suit_stealth_cost = 4
	///How fast the suit is at certain actions, like draining power from things
	var/suit_action_delay = 4 SECONDS
	///Units of radium given to the user with each use of repair nanopaste
	var/suit_radium_injected = 3
	///Whether or not the suit is currently in stealth mode.
	var/stealth_enabled = FALSE//Stealth off.
	///Whether or not the wearer is in the middle of an action, like hacking.
	var/suit_currently_busy = FALSE
	///Whether or not the repair nanopaste ability is available
	var/nanopaste_available = TRUE

/obj/item/clothing/suit/space/space_ninja/Destroy()
	unlock_suit()
	terminate()
	. = ..()


/obj/item/clothing/suit/space/space_ninja/examine(mob/user)
	. = ..()
	if(!suit_initialized)
		return
	if(!user == affecting)
		return
	. += "All systems operational. Current energy capacity: <B>[display_energy(cell.charge)]</B>.\n"+\
	"The CLOAK-tech device is <B>[stealth_enabled?"active":"inactive"]</B>.\n"+\
	"[nanopaste_available?"Repair nanopaste is available to use.":"There is no repair nanopaste available. Use your HF Blade on enemies to restore it."]"

/obj/item/clothing/suit/space/space_ninja/Initialize()
	. = ..()
	//Spark Init
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	//Research Init
	stored_research = new()
	//Begin processing the suit
	START_PROCESSING(SSobj, src)

// Space Suit power usage and suit recharge
/obj/item/clothing/suit/space/space_ninja/process(delta_time)
	var/mob/living/carbon/human/user = src.loc
	if(!user || !ishuman(user) || !(user.wear_suit == src))
		return
	// Check for energy usage
	if(suit_initialized)
		if(!affecting)
			terminate() // Kills the suit and attached objects.
		else if(cell.charge > 0)
			if(suit_cooldown)
				suit_cooldown -= 1 // Checks for ability suit_cooldown first.
			cell.charge -= suit_cost * delta_time // suit_cost is the default energy cost each process tick
			if(stealth_enabled) // If stealth is active.
				cell.charge -= suit_stealth_cost * delta_time
		else
			cell.charge = 0
			cancel_stealth()

	user.adjust_bodytemperature(BODYTEMP_NORMAL - user.bodytemperature)

/obj/item/clothing/suit/space/space_ninja/ui_action_click(mob/user, action)
	if(IS_NINJA_SUIT_INITIALIZATION(action))
		toggle_on_off()
		return TRUE
	if(!suit_initialized)
		to_chat(user, "<span class='warning'><b>ERROR</b>: suit offline. Please activate suit.</span>")
		return FALSE
	if(suit_cooldown > 0)
		to_chat(user, "<span class='warning'><b>ERROR</b>: suit is on cooldown.</span>")
		return FALSE
	if(IS_NINJA_SUIT_STATUS(action))
		ninjastatus()
		return TRUE
	if(IS_NINJA_SUIT_BOOST(action))
		ninjaboost()
		return TRUE
	if(IS_NINJA_SUIT_EMP(action))
		ninjapulse()
		return TRUE
	if(IS_NINJA_SUIT_STAR_CREATION(action))
		ninjastar()
		return TRUE
	if(IS_NINJA_SUIT_SWORD_RECALL(action))
		ninja_sword_recall()
		return TRUE
	if(IS_NINJA_SUIT_STEALTH(action))
		toggle_stealth()
		return TRUE
	return FALSE

/obj/item/clothing/suit/space/space_ninja/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	. = ..()
	if(stealth_enabled)
		cancel_stealth()
		suit_cooldown = 5

/**
  * Proc for changing the suit's appearance upon locking.
  *
  * Proc for when space ninja's suit locks.
  * Gives the user a chance to customize the color of the blade and suit lights. Green may not be your color.
  * Arguments:
  * * ninja - The person wearing the suit.
  */
/obj/item/clothing/suit/space/space_ninja/proc/choose_suit_color(mob/living/carbon/human/ninja)
	suit_color = input(ninja, "Choose suit light color:", "Ninja Suit Color", "#00BB00") as color|null
	if(!suit_color)
		suit_color = "#00BB00"
	update_suit_color()
	ninja.regenerate_icons()

/**
  * Proc for updating the suit color itself after choosing a color and locking.
  * Used for both setting the new color and reverting to an "off" state when disabled.
  * Arguments:
  * * ninja - The person wearing the suit.
  */
/obj/item/clothing/suit/space/space_ninja/proc/update_suit_color()
	n_hood.greyscale_colors = suit_color
	n_hood.update_greyscale()

	n_shoes.greyscale_colors = suit_color
	n_shoes.update_greyscale()

	n_gloves.greyscale_colors = suit_color
	n_gloves.update_greyscale()

	n_suit.greyscale_colors = suit_color
	n_suit.update_greyscale()

	zandatsu.greyscale_colors = suit_color
	zandatsu.slash_color = suit_color
	zandatsu.update_greyscale()

	src.greyscale_colors = suit_color
	src.update_greyscale()

/**
  * Proc called to lock the important gear pieces onto space ninja's body.
  *
  * Called during the suit startup to lock all gear pieces onto space ninja.
  * Terminates if a gear piece is not being worn.  Also gives the ninja the inability to use firearms.
  * If the person in the suit isn't a ninja when this is called, this proc just gibs them instead.
  * Arguments:
  * * ninja - The person wearing the suit.
  * * Returns false if the locking fails due to lack of all suit parts, and true if it succeeds.
  */
/obj/item/clothing/suit/space/space_ninja/proc/lock_suit(mob/living/carbon/human/ninja)
	if(!istype(ninja))
		return FALSE
	if(!IS_SPACE_NINJA(ninja))
		to_chat(ninja, "<span class='danger'><B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAUHORIZED USÈ DETÈCeD\nCoMMÈNCING SUB-R0UIN3 13...\nTÈRMInATING U-U-USÈR...</span>")
		ninja.gib()
		return FALSE
	if(!istype(ninja.head, /obj/item/clothing/head/helmet/space/space_ninja))
		to_chat(ninja, "<span class='userdanger'>ERROR</span>: 100113 UNABLE TO LOCATE HEAD GEAR\nABORTING...")
		return FALSE
	if(!istype(ninja.shoes, /obj/item/clothing/shoes/space_ninja))
		to_chat(ninja, "<span class='userdanger'>ERROR</span>: 122011 UNABLE TO LOCATE FOOT GEAR\nABORTING...")
		return FALSE
	if(!istype(ninja.gloves, /obj/item/clothing/gloves/space_ninja))
		to_chat(ninja, "<span class='userdanger'>ERROR</span>: 110223 UNABLE TO LOCATE HAND GEAR\nABORTING...")
		return FALSE
	if(!istype(ninja.w_uniform, /obj/item/clothing/under/syndicate/ninja))
		to_chat(ninja, "<span class='userdanger'>ERROR</span>: 115242 UNABLE TO LOCATE JUMPSUIT\nABORTING...")
		return FALSE
	affecting = ninja
	ADD_TRAIT(src, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	n_hood = ninja.head
	ADD_TRAIT(n_hood, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	n_shoes = ninja.shoes
	ADD_TRAIT(n_shoes, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	n_gloves = ninja.gloves
	ADD_TRAIT(n_gloves, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	n_suit = ninja.w_uniform
	ADD_TRAIT(n_suit, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	n_mask = ninja.wear_mask

	ADD_TRAIT(ninja, TRAIT_NOGUNS, NINJA_SUIT_TRAIT)
	return TRUE

/**
  * Proc called to unlock all the gear off space ninja's body.
  *
  * Proc which is essentially the opposite of lock_suit.  Lets you take off all the suit parts.
  * Arguments:
  * * ninja - The person wearing the suit.
  */
/obj/item/clothing/suit/space/space_ninja/proc/unlock_suit(mob/living/carbon/human/ninja)
	affecting = null
	REMOVE_TRAIT(src, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	if(n_hood)//Should be attached, might not be attached.
		REMOVE_TRAIT(n_hood, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	if(n_shoes)
		REMOVE_TRAIT(n_shoes, TRAIT_NODROP, NINJA_SUIT_TRAIT)
	if(n_gloves)
		REMOVE_TRAIT(n_gloves, TRAIT_NODROP, NINJA_SUIT_TRAIT)
		n_gloves.candrain = FALSE
		n_gloves.draining = FALSE
	if(n_suit)
		REMOVE_TRAIT(n_suit, TRAIT_NODROP, NINJA_SUIT_TRAIT)

/**
  * Proc used to delete all the attachments and itself.
  *
  * Can be called to entire rid of the suit pieces and the suit itself.
  */
/obj/item/clothing/suit/space/space_ninja/proc/terminate()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(n_hood)
	QDEL_NULL(n_gloves)
	QDEL_NULL(n_shoes)
	QDEL_NULL(zandatsu)
	QDEL_NULL(src)
