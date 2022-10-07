//ninja_cost() specificCheck defines
#define N_STEALTH_CANCEL	1
#define N_NANOPASTE		2

//ninjaDrainAct() defines for non numerical returns
#define INVALID_DRAIN			"INVALID" //This one is if the drain proc needs to cancel, eg missing variables, etc, it's important.
#define DRAIN_RD_HACK_FAILED	"RDHACKFAIL"
#define DRAIN_MOB_SHOCK			"MOBSHOCK"
#define DRAIN_MOB_SHOCK_FAILED	"MOBSHOCKFAIL"

//Tells whether or not someone is a space ninja
//Fun fact for future coders: Using the word as the argument in the define makes all uses of the word a variable.
//This meant that having the wrong variable name actually caused IS_SPACE_NINJA(user) to look for /datum/antagonist/user. Pretty funny honestly.
#define IS_SPACE_NINJA(person) (person.mind && person.mind.has_antag_datum(/datum/antagonist/ninja))

//Defines for the suit's unique abilities
#define IS_NINJA_SUIT_INITIALIZATION(X) (istype(X, /datum/action/item_action/initialize_ninja_suit))
#define IS_NINJA_SUIT_STATUS(X) (istype(X, /datum/action/item_action/ninjastatus))
#define IS_NINJA_SUIT_BOOST(X) (istype(X, /datum/action/item_action/ninjaboost))
#define IS_NINJA_SUIT_EMP(X) (istype(X, /datum/action/item_action/ninjapulse))
#define IS_NINJA_SUIT_STAR_CREATION(X) (istype(X, /datum/action/item_action/ninjastar))
#define IS_NINJA_SUIT_NET_CREATION(X) (istype(X, /datum/action/item_action/ninjanet))
#define IS_NINJA_SUIT_SWORD_RECALL(X) (istype(X, /datum/action/item_action/ninja_sword_recall))
#define IS_NINJA_SUIT_STEALTH(X) (istype(X, /datum/action/item_action/ninja_stealth))
