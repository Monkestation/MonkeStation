// Object signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument


// /obj signals
/// from base of obj/deconstruct(): (disassembled)
#define COMSIG_OBJ_DECONSTRUCT "obj_deconstruct"
/// from base of code/game/machinery
#define COMSIG_OBJ_DEFAULT_UNFASTEN_WRENCH "obj_default_unfasten_wrench"
/// called in /obj/structure/setAnchored(): (value)
#define COMSIG_OBJ_SETANCHORED "obj_setanchored"


// /obj/machinery signals
/// Sent from /obj/machinery/open_machine(): (drop)
#define COMSIG_MACHINE_OPEN "machine_open"
/// Sent from /obj/machinery/close_machine(): (atom/movable/target)
#define COMSIG_MACHINE_CLOSE "machine_close"


// /obj/machinery/atmospherics/components/binary/valve signals
/// from /obj/machinery/atmospherics/components/binary/valve/toggle(): (on)
#define COMSIG_VALVE_SET_OPEN "valve_toggled"


// /obj/machinery/door/airlock signals
//from /obj/machinery/door/airlock/open(): (forced)
#define COMSIG_AIRLOCK_OPEN "airlock_open"
//from /obj/machinery/door/airlock/close(): (forced)
#define COMSIG_AIRLOCK_CLOSE "airlock_close"
///from /obj/machinery/door/airlock/set_bolt():
#define COMSIG_AIRLOCK_SET_BOLT "airlock_set_bolt"
///Sent from /obj/machinery/door/airlock when its touched. (mob/user)
#define COMSIG_AIRLOCK_TOUCHED "airlock_touched"
	#define COMPONENT_PREVENT_OPEN 1


// /obj/item signals
/// from base of obj/item/equipped(): (/mob/equipper, slot)
#define COMSIG_ITEM_EQUIPPED "item_equip"
/// from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
/// from base of obj/item/pickup(): (/mob/taker)
#define COMSIG_ITEM_PICKUP "item_pickup"
/// from base of mob/living/carbon/attacked_by(): (mob/living/carbon/target, mob/living/user, hit_zone)
#define COMSIG_ITEM_ATTACK_ZONE "item_attack_zone"
/// return a truthy value to prevent ensouling, checked in /obj/effect/proc_holder/spell/targeted/lichdom/cast(): (mob/user)
#define COMSIG_ITEM_IMBUE_SOUL "item_imbue_soul"
	#define COMPONENT_BLOCK_IMBUE (1 << 0)
/// called before marking an object for retrieval, checked in /obj/effect/proc_holder/spell/targeted/summonitem/cast() : (mob/user)
#define COMSIG_ITEM_MARK_RETRIEVAL "item_mark_retrieval"
	#define COMPONENT_BLOCK_MARK_RETRIEVAL (1<<0)
/// from base of obj/item/hit_reaction(): (list/args)
#define COMSIG_ITEM_HIT_REACT "item_hit_react"
	#define COMPONENT_HIT_REACTION_BLOCK (1<<0)
//called on item when microwaved (): (obj/machinery/microwave/M)
#define COMSIG_ITEM_MICROWAVE_ACT "microwave_act"
/// from base of item/sharpener/attackby(): (amount, max)
#define COMSIG_ITEM_SHARPEN_ACT "sharpen_act"
	#define COMPONENT_BLOCK_SHARPEN_APPLIED (1<<0)
	#define COMPONENT_BLOCK_SHARPEN_BLOCKED (1<<1)
	#define COMPONENT_BLOCK_SHARPEN_ALREADY (1<<2)
	#define COMPONENT_BLOCK_SHARPEN_MAXED (1<<3)
/// from base of obj/item/attack(): (/mob/living/target, /mob/living/user)
#define COMSIG_ITEM_ATTACK "item_attack"
/// from base of obj/item/attack_self(): (/mob)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"
	#define COMPONENT_NO_INTERACT 1
/// from base of obj/item/attack_obj(): (/obj, /mob)
#define COMSIG_ITEM_ATTACK_OBJ "item_attack_obj"
	#define COMPONENT_NO_ATTACK_OBJ 1
/// from base of obj/item/pre_attack(): (atom/target, mob/user, params)
#define COMSIG_ITEM_PRE_ATTACK "item_pre_attack"
	#define COMPONENT_NO_ATTACK 1
/// from base of obj/item/afterattack(): (atom/target, mob/user, params)
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"
/// from [/obj/item/proc/disableEmbedding]:
#define COMSIG_ITEM_DISABLE_EMBED "item_disable_embed"
/// from [/obj/effect/mine/proc/triggermine]:
#define COMSIG_MINE_TRIGGERED "minegoboom"
/// used to check if the item is wielded for special effects
#define COMSIG_ITEM_CHECK_WIELDED "item_check_wielded"
  #define COMPONENT_IS_WIELDED 1


// /obj/item/clothing signals
///from [/mob/living/carbon/human/Move]: ()
#define COMSIG_SHOES_STEP_ACTION "shoes_step_action"


// /obj/item/implant signals
/// from base of /obj/item/implant/proc/activate(): ()
#define COMSIG_IMPLANT_ACTIVATED "implant_activated"
/// from base of /obj/item/implant/proc/implant(): (list/args)
#define COMSIG_IMPLANT_IMPLANTING "implant_implanting"
	#define COMPONENT_STOP_IMPLANTING (1<<0)
/// called on already installed implants when a new one is being added in /obj/item/implant/proc/implant(): (list/args, obj/item/implant/new_implant)
#define COMSIG_IMPLANT_OTHER "implant_other"
	//#define COMPONENT_STOP_IMPLANTING (1<<0) //The name makes sense for both
	#define COMPONENT_DELETE_NEW_IMPLANT (1<<1)
	#define COMPONENT_DELETE_OLD_IMPLANT (1<<2)
/// called on implants, after a successful implantation: (mob/living/target, mob/user, silent, force)
#define COMSIG_IMPLANT_IMPLANTED "implant_implanted"
/// called on implants, after an implant has been removed: (mob/living/source, silent, special)
#define COMSIG_IMPLANT_REMOVED "implant_removed"
/// called once a mindshield is implanted: (mob/user)
#define COMSIG_MINDSHIELD_IMPLANTED "mindshield_implanted"
	/// Are we the reason for deconversion?
	#define COMPONENT_MINDSHIELD_DECONVERTED (1<<0)
///called on implants being implanted into someone with an uplink implant: (datum/component/uplink)
#define COMSIG_IMPLANT_EXISTING_UPLINK "implant_uplink_exists"
	//This uses all return values of COMSIG_IMPLANT_OTHER


// /obj/item/pda signals
///called on pda when the user changes the ringtone: (mob/living/user, new_ringtone)
#define COMSIG_PDA_CHANGE_RINGTONE "pda_change_ringtone"
	#define COMPONENT_STOP_RINGTONE_CHANGE (1<<0)


// /obj/item/radio signals
///called from base of /obj/item/radio/proc/set_frequency(): (list/args)
#define COMSIG_RADIO_NEW_FREQUENCY "radio_new_frequency"


// /obj/item/pen signals
///called after rotation in /obj/item/pen/attack_self(): (rotation, mob/living/carbon/user)
#define COMSIG_PEN_ROTATED "pen_rotated"


// /obj/item/grenade signals
/// called in /obj/item/gun/process_fire (user, target, params, zone_override)
#define COMSIG_GRENADE_PRIME "grenade_prime"
/// called in /obj/item/gun/process_fire (user, target, params, zone_override)
#define COMSIG_GRENADE_ARMED "grenade_armed"


// /obj/projectile signals (sent to the firer)
///from base of /obj/projectile/proc/on_hit(), like COMSIG_PROJECTILE_ON_HIT but on the projectile itself and with the hit limb (if any): (atom/movable/firer, atom/target, Angle, hit_limb)
#define COMSIG_PROJECTILE_SELF_ON_HIT "projectile_self_on_hit"
///from base of /obj/projectile/proc/on_hit(): (atom/movable/firer, atom/target, Angle)
#define COMSIG_PROJECTILE_ON_HIT "projectile_on_hit"
///from base of /obj/projectile/proc/fire(): (obj/projectile, atom/original_target)
#define COMSIG_PROJECTILE_BEFORE_FIRE "projectile_before_fire"
///sent to targets during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_PREHIT "com_proj_prehit"
///sent to targets during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_RANGE_OUT "projectile_range_out"
///from [/obj/item/proc/tryEmbed] sent when trying to force an embed (mainly for projectiles and eating glass)
#define COMSIG_EMBED_TRY_FORCE "item_try_embed"
	#define COMPONENT_EMBED_SUCCESS (1<<1)
///sent to targets during the process_hit proc of projectiles
#define COMSIG_PELLET_CLOUD_INIT "pellet_cloud_init"


// /obj/mecha signals
/// sent from mecha action buttons to the mecha they're linked to
#define COMSIG_MECHA_ACTION_ACTIVATE "mecha_action_activate"


///from /obj/item/assembly/proc/pulsed()
#define COMSIG_ASSEMBLY_PULSED "assembly_pulsed"


///from base of /obj/item/mmi/set_brainmob(): (mob/living/brain/new_brainmob)
#define COMSIG_MMI_SET_BRAINMOB "mmi_set_brainmob"

