/datum/ranching/mutation/spicy
	chicken_type = /mob/living/simple_animal/chicken/spicy
	food_requirements = list(/obj/item/food/grown/chili)
	needed_temperature = 400
	temperature_variance = 50

/datum/ranching/mutation/raptor
	chicken_type = /mob/living/simple_animal/chicken/hostile/raptor
	happiness = 55
	food_requirements = list(/obj/item/food/meat/slab/monkey)
	reagent_requirements = list(/datum/reagent/blood)

/datum/ranching/mutation/cotton_candy
	chicken_type = /mob/living/simple_animal/chicken/cotton_candy
	reagent_requirements = list(/datum/reagent/consumable/cream, /datum/reagent/consumable/sugar, /datum/reagent/consumable/bluecherryshake)
	happiness = 50

/datum/ranching/mutation/snowy
	chicken_type = /mob/living/simple_animal/chicken/snowy
	temperature_variance = 20
	needed_temperature = 4
	required_atmos = list(GAS_O2 = 30) //No space raising these bad boys

/datum/ranching/mutation/pigeon
	chicken_type = /mob/living/simple_animal/chicken/pigeon
	happiness = 30
	nearby_items = list(/obj/item/radio)
	food_requirements = list(/obj/item/food/grown/corn)

/datum/ranching/mutation/stone
	chicken_type = /mob/living/simple_animal/chicken/stone
	needed_turfs = list(/turf/open/floor/grass/fakebasalt)
	nearby_items = list(/obj/item/pickaxe)
	food_requirements = list(/obj/item/food/grown/cannabis)

/datum/ranching/mutation/wiznerd
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/wiznerd
	food_requirements = list(/obj/item/food/grown/mushroom/amanita)
	nearby_items = list(/obj/item/clothing/head/wizard/fake)

/datum/ranching/mutation/sword
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/sword
	food_requirements = list(/obj/item/food/grown/meatwheat)
	nearby_items = list(/obj/item/grown/log/steel)

/datum/ranching/mutation/gold
	chicken_type = /mob/living/simple_animal/chicken/golden
	happiness = 1000

/datum/ranching/mutation/clown_sad
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown_sad
	happiness = -1000

/datum/ranching/mutation/mime
	chicken_type = /mob/living/simple_animal/chicken/mime
	food_requirements = list(/obj/item/food/baguette)
	reagent_requirements = list(/datum/reagent/consumable/nothing)
