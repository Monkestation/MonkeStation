// Chili
/obj/item/seeds/chili
	name = "pack of chili seeds"
	desc = "These seeds grow into chili plants. HOT! HOT! HOT!"
	icon_state = "seed-chili"
	species = "chili"
	plantname = "Chili Plants"
	product = /obj/item/food/grown/chili
	lifespan = 20
	maturation = 5
	production = 5
	harvest_age = 5
	yield = 4
	potency = 20
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "chili-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "chili-dead" // Same for the dead icon
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	possible_mutations = list(/datum/hydroponics/plant_mutation/ghost_chili)
	infusion_mutations = list(/datum/hydroponics/plant_mutation/infusion/chilly_pepper)
	reagents_add = list(/datum/reagent/consumable/capsaicin = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/chili
	seed = /obj/item/seeds/chili
	name = "chili"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	bite_consumption_mod = 2
	foodtypes =  FRUIT
	wine_power = 20

// Ice Chili
/obj/item/seeds/chili/ice
	name = "pack of ice pepper seeds"
	desc = "These seeds grow into ice pepper plants."
	icon_state = "seed-icepepper"
	species = "chiliice"
	plantname = "Ice Pepper Plants"
	product = /obj/item/food/grown/icepepper
	lifespan = 25
	maturation = 4
	production = 4
	harvest_age = 4
	rarity = 20
	possible_mutations = list()
	infusion_mutations = list()
	reagents_add = list(/datum/reagent/consumable/frostoil = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.02)

/obj/item/food/grown/icepepper
	seed = /obj/item/seeds/chili/ice
	name = "ice pepper"
	desc = "It's a mutant strain of chili."
	icon_state = "icepepper"
	bite_consumption_mod = 2
	foodtypes =  FRUIT
	wine_power = 30
	discovery_points = 300

// Ghost Chili
/obj/item/seeds/chili/ghost
	name = "pack of ghost chili seeds"
	desc = "These seeds grow into a chili said to be the hottest in the galaxy."
	icon_state = "seed-chilighost"
	species = "chilighost"
	plantname = "Ghost Chili Plants"
	product = /obj/item/food/grown/ghost_chili
	endurance = 10
	maturation = 10
	production = 10
	harvest_age = 10
	yield = 3
	rarity = 20
	possible_mutations = list()
	infusion_mutations = list()
	reagents_add = list(/datum/reagent/consumable/condensedcapsaicin = 0.3, /datum/reagent/consumable/capsaicin = 0.55, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/ghost_chili
	seed = /obj/item/seeds/chili/ghost
	name = "ghost chili"
	desc = "It seems to be vibrating gently."
	icon_state = "ghostchilipepper"
	var/mob/living/carbon/human/held_mob
	bite_consumption_mod = 4
	foodtypes =  FRUIT
	wine_power = 50
	discovery_points = 300

/obj/item/food/grown/ghost_chili/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if( ismob(loc) )
		held_mob = loc
		START_PROCESSING(SSobj, src)

/obj/item/food/grown/ghost_chili/process(delta_time)
	if(held_mob && loc == held_mob)
		if(held_mob.is_holding(src))
			if(istype(held_mob) && held_mob.gloves)
				return
			held_mob.adjust_bodytemperature(7.5 * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time)
			if(DT_PROB(5, delta_time))
				to_chat(held_mob, "<span class='warning'>Your hand holding [src] burns!</span>")
	else
		held_mob = null
		..()
