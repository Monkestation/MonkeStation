//Monkey defines, placed here so they can be read by other things!

/// below this health value the chickens starts to flee from enemies
#define CHICKEN_FLEE_HEALTH 					5
/// how close an enemy must be to trigger aggression
#define CHICKEN_ENEMY_VISION 				5
/// how close an enemy must be before it triggers flee
#define CHICKEN_FLEE_VISION					2

// Probability per Life tick that the chickens will:

/// probability that chickens will disarm an armed attacker
#define CHICKEN_ATTACK_DISARM_PROB 			50
/// probability that chickens will get recruited when friend is attacked
#define CHICKEN_RECRUIT_PROB 				100


/// probability for the chickens to aggro when attacked
#define CHICKEN_RETALIATE_PROB 90

/// probability for the chickens to aggro when attacked with harm intent
#define CHICKEN_RETALIATE_HARM_PROB 			100

/// amount of aggro to add to an enemy when they attack user
#define CHICKEN_HATRED_AMOUNT 				30
/// amount of aggro to add to an enemy when a chickens is recruited
#define CHICKEN_RECRUIT_HATED_AMOUNT 		30
/// probability of reducing aggro by one when the chickens attacks
#define CHICKEN_HATRED_REDUCTION_PROB 		1

///Monkey recruit cooldown
#define CHICKEN_RECRUIT_COOLDOWN 10 SECONDS
