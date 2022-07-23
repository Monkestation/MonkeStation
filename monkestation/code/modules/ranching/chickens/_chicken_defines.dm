/mob/living/simple_animal/chicken
	///How many eggs can the chicken still lay?
	var/eggs_left = 0
	///can it still lay eggs?
	var/eggs_fertile = TRUE
	///Message you get when it is fed
	var/list/feedMessages = list("It clucks happily.","It clucks happily.")
	///Message that is sent when an egg is layed
	var/list/layMessage = EGG_LAYING_MESSAGES
	//Global amount of chickens
	var/static/chicken_count = 0
	///Type of egg that is layed
	var/egg_type = /obj/item/food/egg
	///How hpapy the chicken is, used on egg hatch to determine if it should branch into a new chicken
	var/happiness = 0
	///The type of chicken it is
	var/mob/living/simple_animal/chicken/chicken_type
	///Consumed food
	var/list/consumed_food = list()
	///All Consumed reagents
	var/list/datum/reagent/consumed_reagents = new/list()
	///ALL possible mutations this chicken can lay
	var/list/mutation_list = list(/datum/ranching/mutation/spicy, /datum/ranching/mutation/brown)
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
	var/age_speed = 5 SECONDS
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

	///Glass Chicken exclusive: reagents for eggs
	var/list/glass_egg_reagents = list()
	///Stone Chicken Exclusive: ore type for eggs
	var/obj/item/stack/ore/production_type = null

/obj/item/food/egg
	///the amount the chicken is grown
	var/amount_grown = 0
	///the type of chicken that layed this egg
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
