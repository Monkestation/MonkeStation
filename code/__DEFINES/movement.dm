//Diagonal movement is split into two cardinal moves
/// The first step of the diagnonal movement
#define FIRST_DIAG_STEP 1
/// The second step of the diagnonal movement
#define SECOND_DIAG_STEP 2

/// Classic bluespace teleportation, requires a sender but no receiver
#define TELEPORT_CHANNEL_BLUESPACE "bluespace"
/// Quantum-based teleportation, requires both sender and receiver, but is free from normal disruption
#define TELEPORT_CHANNEL_QUANTUM "quantum"
/// Wormhole teleportation, is not disrupted by bluespace fluctuations but tends to be very random or unsafe
#define TELEPORT_CHANNEL_WORMHOLE "wormhole"
/// Magic teleportation, does whatever it wants (unless there's antimagic)
#define TELEPORT_CHANNEL_MAGIC "magic"
/// Cult teleportation, does whatever it wants (unless there's holiness)
#define TELEPORT_CHANNEL_CULT "cult"
/// Anything else
#define TELEPORT_CHANNEL_FREE "free"

//Teleport restriction modes (For areas)
#define TELEPORT_ALLOW_ALL 0
#define TELEPORT_ALLOW_NONE 1
#define TELEPORT_ALLOW_CLOCKWORK 2
#define TELEPORT_ALLOW_ABDUCTORS 3

//Teleport modes
#define TELEPORT_MODE_DEFAULT 0
#define TELEPORT_MODE_CLOCKWORK 2
#define TELEPORT_MODE_ABDUCTORS 3

/// possible bitflag return values of [atom/proc/intercept_zImpact] calls
/// Stops the movable from falling further and crashing on the ground. Example: stairs.
#define FALL_INTERCEPTED (1<<0)
/// Suppresses the "[movable] falls through [old_turf]" message because it'd make little sense in certain contexts like climbing stairs.
#define FALL_NO_MESSAGE (1<<1)
/// Used when the whole intercept_zImpact forvar loop should be stopped. For example: when someone falls into the supermatter and becomes dust.
#define FALL_STOP_INTERCEPTING (1<<2)
//Movement loop priority. Only one loop can run at a time, this dictates that
// Higher numbers beat lower numbers
///Standard, go lower then this if you want to override, higher otherwise
#define MOVEMENT_DEFAULT_PRIORITY 10
///Very few things should override this
#define MOVEMENT_SPACE_PRIORITY 100
///Higher then the heavens
#define MOVEMENT_ABOVE_SPACE_PRIORITY (MOVEMENT_SPACE_PRIORITY + 1)

//Movement loop flags
///Should the loop act immediately following its addition?
#define MOVEMENT_LOOP_START_FAST (1<<0)
///Do we not use the priority system?
#define MOVEMENT_LOOP_IGNORE_PRIORITY (1<<1)

//Index defines for movement bucket data packets
#define MOVEMENT_BUCKET_TIME 1
#define MOVEMENT_BUCKET_LIST 2

//The minimum for glide_size to be clamped to.
#define MIN_GLIDE_SIZE 1
//The maximum for glide_size to be clamped to.
//This shouldn't be higher than the icon size, and generally you shouldn't be changing this, but it's here just in case.
#define MAX_GLIDE_SIZE 32

// Originally a really stupid /tg/ var that sucked and was really bad and caused it to look horrible. Now it's a way of compensating for time dilation
GLOBAL_VAR_INIT(glide_size_multiplier, 1.0)

///Broken down, here's what this does:
/// divides the world icon_size (32) by delay divided by ticklag to get the number of pixels something should be moving each tick.
/// The division result is given a min value of 1 to prevent obscenely slow glide sizes from being set
/// Then that's multiplied by the global glide size multiplier. 1.25 by default feels pretty close to spot on. This is just to try to get byond to behave.
/// The whole result is then clamped to within the range above.
/// Not very readable but it works
#define DELAY_TO_GLIDE_SIZE(delay) (CLAMP(((32 / max((delay) / world.tick_lag, 1)) * GLOB.glide_size_multiplier), MIN_GLIDE_SIZE, MAX_GLIDE_SIZE))
