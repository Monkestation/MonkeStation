// Soybeans
/obj/item/seeds/soya
	name = "pack of soybean seeds"
	desc = "These seeds grow into soybean plants."
	icon_state = "seed-soybean"
	species = "soybean"
	plantname = "Soybean Plants"
	product = /obj/item/food/grown/soybeans
	maturation = 4
	production = 4
	harvest_age = 80
	potency = 15
	growthstages = 80
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "soybean-grow"
	icon_dead = "soybean-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	possible_mutations = list(/datum/hydroponics/plant_mutation/koi_beans)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/consumable/cooking_oil = 0.03, /datum/reagent/flatulynt = 0.04) //Vegetable oil and Flatulynt!

/obj/item/food/grown/soybeans
	seed = /obj/item/seeds/soya
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	icon_state = "soybeans"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	grind_results = list(/datum/reagent/consumable/soymilk = 0, /datum/reagent/flatulynt = 0)
	tastes = list("soy" = 1)
	wine_power = 20

// Koibean
/obj/item/seeds/soya/koi
	name = "pack of koibean seeds"
	desc = "These seeds grow into koibean plants."
	icon_state = "seed-koibean"
	species = "koibean"
	plantname = "Koibean Plants"
	product = /obj/item/food/grown/koibeans
	potency = 10
	possible_mutations = list()
	reagents_add = list(/datum/reagent/toxin/carpotoxin = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)
	rarity = 20

/obj/item/food/grown/koibeans
	seed = /obj/item/seeds/soya/koi
	name = "koibean"
	desc = "Something about these seems fishy."
	icon_state = "koibeans"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list("koi" = 1)
	wine_power = 40
	discovery_points = 300
