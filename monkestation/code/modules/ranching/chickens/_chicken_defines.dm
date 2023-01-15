#define DEFAULT_CHICKEN_ABILITY_COOLDOWN 30 SECONDS

/mob/living/simple_animal
	///the child type of the parent, basically spawns in the baby version instead of the adult version. Used if mutations fail
	var/child_type
	///if they lay eggs the egg type
	var/egg_type
	///ALL possible mutations this simple animal has
	var/list/mutation_list = list()
	///How many eggs can the chicken still lay?
	var/eggs_left = 0
	///can it still lay eggs?
	var/eggs_fertile = TRUE

	///How happy the animal is, used on mutation to see if it can branch
	var/happiness = 0
	///Consumed food
	var/list/consumed_food = list()
	///All Consumed reagents
	var/list/datum/reagent/consumed_reagents = new/list()

/mob/living/simple_animal/chicken

	faction = list("chicken")
	ai_controller = /datum/ai_controller/chicken
	///Message you get when it is fed
	var/list/feedMessages = list("It clucks happily.","It gobbles up the food voraciously.","It noms happily.")
	///Message that is sent when an egg is laid
	var/list/layMessage = EGG_LAYING_MESSAGES
	//Global amount of chickens
	var/static/chicken_count = 0
	///The type of chicken it is
	var/mob/living/simple_animal/chicken/chicken_type
	///Needed cause i can't iterate a new spawn with the ref to a mob
	var/chicken_path = /mob/living/simple_animal/chicken
	///Breed of the chicken needed for naming
	var/breed_name = "White"
	///Do we wanna call the male rooster something different?
	var/breed_name_male
	///Is the hen also different?
	var/breed_name_female
	///Total times eaten
	var/total_times_eaten = 0
	///Current fed level
	var/current_feed_amount = 0
	///List of liked foods
	var/list/liked_foods = list(/obj/item/food/grown/wheat)
	///list of disliked foods
	var/list/disliked_food_types = list(MEAT)
	///Overcrowding amount
	var/overcrowding = 10
	///Age of the chicken
	var/age = 0
	///Cooldown for aging
	COOLDOWN_DECLARE(age_cooldown)
	///Aging Speed
	var/age_speed = 30 SECONDS
	///Nestbox to move to
	var/obj/structure/nestbox/movement_target
	///Ready to lay egg
	var/ready_to_lay = FALSE
	///max generational happiness
	var/max_happiness_per_generation = 100
	///How sad until they die of sadness?
	var/minimum_living_happiness = -200
	///List of happy chems
	var/list/happy_chems = list(
	/datum/reagent/drug/methamphetamine = 1,
	/datum/reagent/toxin/lipolicide = 0.25,
	/datum/reagent/consumable/sugar = 0.5,)

	///unique ability for chicken
	var/unique_ability = null
	///cooldown of ability
	var/cooldown_time = DEFAULT_CHICKEN_ABILITY_COOLDOWN
	/// is it a combat ability?
	var/combat_ability = FALSE
	/// probability for ability
	var/ability_prob = 3
	///what type of projectile do we shoot?
	var/projectile_type = null
	///probabilty of firing a shot on any given attack
	var/shoot_prob = 0

	///Glass Chicken exclusive: reagents for eggs
	var/list/glass_egg_reagents = list()
	///Stone Chicken Exclusive: ore type for eggs
	var/obj/item/stack/ore/production_type = null
	///list of all friends will not attack them and can be ordered around by them if high enough
	var/list/Friends = list()
	/// Last phrase said near it and person who said it
	var/list/speech_buffer = list()
	/// the icon suffix
	var/icon_suffix = ""

#undef DEFAULT_CHICKEN_ABILITY_COOLDOWN

/obj/item/food/egg
	///the amount the chicken is grown
	var/amount_grown = 0
	///the type of chicken that laid this egg
	var/mob/living/simple_animal/chicken/layer_hen_type
	///happiness of the chicken
	var/happiness = 0
	///list of consumed food
	var/list/consumed_food
	///list of consumed reagents
	var/list/consumed_reagents
	///list of all possible mutations
	var/list/mutations = list()
	///eggs ore type
	var/obj/item/stack/ore/production_type = null
	///list of picked mutations should only ever be one
	var/list/possible_mutations = list()
	///list of all friends will not attack them and can be ordered around by them if high enough
	var/list/Friends = list()
