//Food
/// from base of obj/item/reagent_containers/food/snacks/attack(): (mob/living/eater, mob/feeder)
#define COMSIG_FOOD_EATEN "food_eaten"

///from base of datum/component/edible/oncrossed: (mob/crosser, bitecount)
#define COMSIG_FOOD_CROSSED "food_crossed"

#define COMSIG_ITEM_FRIED "item_fried"
	#define COMSIG_FRYING_HANDLED (1<<0)

///from base of Component/edible/On_Consume: (mob/living/eater, mob/living/feeder)
#define COMSIG_FOOD_CONSUMED "food_consumed"
