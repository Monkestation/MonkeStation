/obj/item/food/cake
	icon = 'icons/obj/food/piecake.dmi'
	slice_path = /obj/item/food/cakeslice/plain
	slices_num = 5
	bitesize = 3
	volume = 80
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 1)
	foodtype = GRAIN | DAIRY

/obj/item/food/cakeslice
	icon = 'icons/obj/food/piecake.dmi'
	trash = /obj/item/trash/plate
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	customfoodfilling = 0 //to avoid infinite cake-ception
	tastes = list("cake" = 1)
	foodtype = GRAIN | DAIRY

/obj/item/food/cake/plain
	name = "plain cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	custom_food_type = /obj/item/reagent_containers/food/snacks/customizable/cake
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("sweetness" = 2,"cake" = 5)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cakeslice/plain
	name = "plain cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	filling_color = "#FFD700"
	customfoodfilling = 1
	tastes = list("sweetness" = 2,"cake" = 5)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/carrot
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/food/cakeslice/carrot
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/oculine = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/medicine/oculine = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 5, "sweetness" = 2, "carrot" = 1)
	foodtype = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cakeslice/carrot
	name = "carrot cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	filling_color = "#FFA500"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/oculine = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cake" = 5, "sweetness" = 2, "carrot" = 1)
	foodtype = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/brain
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/food/cakeslice/brain
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/mannitol = 10, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/medicine/mannitol = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 5, "sweetness" = 2, "brains" = 1)
	foodtype = GRAIN | DAIRY | MEAT | GROSS | SUGAR

/obj/item/food/cakeslice/brain
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	filling_color = "#FF69B4"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/mannitol = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cake" = 5, "sweetness" = 2, "brains" = 1)
	foodtype = GRAIN | DAIRY | MEAT | GROSS | SUGAR

/obj/item/food/cake/cheese
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/food/cakeslice/cheese
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 4, "cream cheese" = 3)
	foodtype = GRAIN | DAIRY

/obj/item/food/cakeslice/cheese
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	filling_color = "#FFFACD"
	tastes = list("cake" = 4, "cream cheese" = 3)
	foodtype = GRAIN | DAIRY

/obj/item/food/cake/orange
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/food/cakeslice/orange
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 5, "sweetness" = 2, "oranges" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/orange
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	filling_color = "#FFA500"
	tastes = list("cake" = 5, "sweetness" = 2, "oranges" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/lime
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/food/cakeslice/lime
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 5, "sweetness" = 2, "unbearable sourness" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/lime
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	filling_color = "#00FF00"
	tastes = list("cake" = 5, "sweetness" = 2, "unbearable sourness" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/lemon
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/food/cakeslice/lemon
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 5, "sweetness" = 2, "sourness" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/lemon
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	filling_color = "#FFEE00"
	tastes = list("cake" = 5, "sweetness" = 2, "sourness" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/chocolate
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/food/cakeslice/chocolate
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 5, "sweetness" = 1, "chocolate" = 4)
	foodtype = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cakeslice/chocolate
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	filling_color = "#A0522D"
	tastes = list("cake" = 5, "sweetness" = 1, "chocolate" = 4)
	foodtype = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday
	name = "birthday cake"
	desc = "Happy Birthday little clown..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/food/cakeslice/birthday
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 5, "sweetness" = 1)
	foodtype = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday/microwave_act(obj/machinery/microwave/M) //super sekrit club
	new /obj/item/clothing/head/hardhat/cakehat(get_turf(src))
	qdel(src)

/obj/item/food/cakeslice/birthday
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	filling_color = "#DC143C"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sprinkles = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cake" = 5, "sweetness" = 1)
	foodtype = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday/energy
	name = "energy cake"
	desc = "Just enough calories for a whole nuclear operative squad."
	icon_state = "energycake"
	force = 5
	hitsound = 'sound/weapons/blade1.ogg'
	slice_path = /obj/item/food/cakeslice/birthday/energy
	list_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/pwr_game = 10, /datum/reagent/consumable/liquidelectricity = 30)
	tastes = list("cake" = 3, "a Vlad's Salad" = 1)

/obj/item/food/cake/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, "<font color='red' size='5'>As you eat the cake, you accidentally hurt yourself on the embedded energy sword!</font>")
	user.apply_damage(30,BRUTE,BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cake/birthday/energy/attack(mob/living/M, mob/living/user)
	. = ..()
	energy_bite(M, user)

/obj/item/food/cake/birthday/energy/microwave_act(obj/machinery/microwave/M)
	new /obj/item/clothing/head/hardhat/cakehat/energycake(get_turf(src))
	qdel(src)

/obj/item/food/cakeslice/birthday/energy
	name = "energy cake slice"
	desc = "For the traitor on the go."
	icon_state = "energycakeslice"
	force = 2
	hitsound = 'sound/weapons/blade1.ogg'
	filling_color = "#00FF00"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sprinkles = 2, /datum/reagent/consumable/nutriment/vitamin = 1,  /datum/reagent/consumable/pwr_game = 2, /datum/reagent/consumable/liquidelectricity = 5)
	tastes = list("cake" = 3, "a Vlad's Salad" = 1)

/obj/item/food/cakeslice/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, "<font color='red' size='5'>As you eat the cake slice, you accidentally hurt yourself on the embedded energy dagger!</font>")
	user.apply_damage(18,BRUTE,BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cakeslice/birthday/energy/attack(mob/living/M, mob/living/user)
	. = ..()
	energy_bite(M, user)

/obj/item/food/cake/apple
	name = "apple cake"
	desc = "A cake centred with Apple."
	icon_state = "applecake"
	slice_path = /obj/item/food/cakeslice/apple
	slices_num = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("cake" = 5, "sweetness" = 1, "apple" = 1)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/apple
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	filling_color = "#FF4500"
	tastes = list("cake" = 5, "sweetness" = 1, "apple" = 1)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/custom
	name = "cake slice"
	icon_state = "plaincake_slice"
	filling_color = "#FFFFFF"
	foodtype = GRAIN | DAIRY

/obj/item/food/cake/slimecake
	name = "Slime cake"
	desc = "A cake made of slimes. Probably not electrified."
	icon_state = "slimecake"
	slice_path = /obj/item/food/cakeslice/slimecake
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cake" = 5, "sweetness" = 1, "slime" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cakeslice/slimecake
	name = "slime cake slice"
	desc = "A slice of slime cake."
	icon_state = "slimecake_slice"
	filling_color = "#00FFFF"
	tastes = list("cake" = 5, "sweetness" = 1, "slime" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pumpkinspice
	name = "pumpkin spice cake"
	desc = "A hollow cake with real pumpkin."
	icon_state = "pumpkinspicecake"
	slice_path = /obj/item/food/cakeslice/pumpkinspice
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 5, "sweetness" = 1, "pumpkin" = 1)
	foodtype = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cakeslice/pumpkinspice
	name = "pumpkin spice cake slice"
	desc = "A spicy slice of pumpkin goodness."
	icon_state = "pumpkinspicecakeslice"
	filling_color = "#FFD700"
	tastes = list("cake" = 5, "sweetness" = 1, "pumpkin" = 1)
	foodtype = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/bsvc // blackberry strawberries vanilla cake
	name = "blackberry and strawberry vanilla cake"
	desc = "A plain cake, filled with assortment of blackberries and strawberries!"
	icon_state = "blackberry_strawberries_cake_vanilla_cake"
	slice_path = /obj/item/food/cakeslice/bsvc
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 14, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("blackberry" = 2, "strawberries" = 2, "vanilla" = 2, "sweetness" = 2, "cake" = 3)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/bsvc
	name = "blackberry and strawberry vanilla cake slice"
	desc = "Just a slice of cake  filled with assortment of blackberries and strawberries!"
	icon_state = "blackberry_strawberries_cake_vanilla_slice"
	filling_color = "#FFD700"
	tastes = list("blackberry" = 2, "strawberries" = 2, "vanilla" = 2, "sweetness" = 2,"cake" = 3)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/bscc // blackberry strawberries chocolate cake
	name = "blackberry and strawberry chocolate cake"
	desc = "A chocolate cake, filled with assortment of blackberries and strawberries!"
	icon_state = "blackberry_strawberries_cake_cocoa_cake"
	slice_path = /obj/item/food/cakeslice/bscc
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 14, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/cocoa = 5)
	tastes = list("blackberry" = 2, "strawberries" = 2, "chocolate" = 2, "sweetness" = 2,"cake" = 3)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/bscc
	name = "blackberry and strawberry chocolate cake slice"
	desc = "Just a slice of cake  filled with assortment of blackberries and strawberries!"
	icon_state = "blackberry_strawberries_cake_cocoa_slice"
	filling_color = "#FFD700"
	tastes = list("blackberry" = 2, "strawberries" = 2, "chocolate" = 2, "sweetness" = 2,"cake" = 3)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/holy_cake
	name = "angel food cake"
	desc = "A cake made for angels and chaplains alike! Contains holy water."
	icon_state = "holy_cake"
	slice_path = /obj/item/food/cakeslice/holy_cake_slice
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/water/holywater = 10)
	tastes = list("cake" = 5, "sweetness" = 1, "clouds" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cakeslice/holy_cake_slice
	name = "angel food cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "holy_cake_slice"
	filling_color = "#00FFFF"
	tastes = list("cake" = 5, "sweetness" = 1, "clouds" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pound_cake
	name = "pound cake"
	desc = "A condensed cake made for filling people up quickly."
	icon_state = "pound_cake"
	slices_num = 7 //Its ment to feed the party
	slice_path = /obj/item/food/cakeslice/pound_cake_slice
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 60)
	tastes = list("cake" = 5, "sweetness" = 1, "batter" = 1)
	foodtype = GRAIN | DAIRY | SUGAR | JUNKFOOD

/obj/item/food/cakeslice/pound_cake_slice
	name = "pound cake slice"
	desc = "A slice of condensed cake made for filling people up quickly."
	icon_state = "pound_cake_slice"
	filling_color = "#00FFFF"
	tastes = list("cake" = 5, "sweetness" = 5, "batter" = 1)
	foodtype = GRAIN | DAIRY | SUGAR | JUNKFOOD

/obj/item/food/cake/hardware_cake
	name = "hardware cake"
	desc = "A quote on quote cake that is made with electronic boards and leaks acid..."
	icon_state = "hardware_cake"
	slice_path = /obj/item/food/cakeslice/hardware_cake_slice
	bonus_reagents = list(/datum/reagent/toxin/acid = 15, /datum/reagent/oil = 15)
	tastes = list("acid" = 3, "metal" = 4, "glass" = 5)
	foodtype = GRAIN | GROSS

/obj/item/food/cakeslice/hardware_cake_slice
	name = "hardware cake slice"
	desc = "A slice of electronic boards and some acid."
	icon_state = "hardware_cake_slice"
	filling_color = "#00FFFF"
	tastes = list("acid" = 3, "metal" = 4, "glass" = 5)
	foodtype = GRAIN | GROSS

/obj/item/food/cake/vanilla_cake
	name = "vanilla cake"
	desc = "A vanilla frosted cake."
	icon_state = "vanillacake"
	slice_path = /obj/item/food/cakeslice/vanilla_slice
	bonus_reagents = list(/datum/reagent/consumable/sugar = 15, /datum/reagent/consumable/vanilla = 15)
	tastes = list("cake" = 1, "sugar" = 1, "vanilla" = 10)
	foodtype = GRAIN | SUGAR | DAIRY

/obj/item/food/cakeslice/vanilla_slice
	name = "vanilla cake slice"
	desc = "A slice of vanilla frosted cake."
	icon_state = "vanillacake_slice"
	filling_color = "#00FFFF"
	tastes = list("cake" = 1, "sugar" = 1, "vanilla" = 10)
	foodtype = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/clown_cake
	name = "clown cake"
	desc = "A funny cake with a clown face on it."
	icon_state = "clowncake"
	slice_path = /obj/item/food/cakeslice/clown_slice
	bonus_reagents = list(/datum/reagent/consumable/sugar = 15)
	tastes = list("cake" = 1, "sugar" = 1, "joy" = 10)
	foodtype = GRAIN | SUGAR | DAIRY

/obj/item/food/cakeslice/clown_slice
	name = "clown cake slice"
	desc = "A slice of bad jokes, and silly props."
	icon_state = "clowncake_slice"
	filling_color = "#00FFFF"
	tastes = list("cake" = 1, "sugar" = 1, "joy" = 10)
	foodtype = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/trumpet
	name = "spaceman's cake"
	desc = "A spaceman's trumpet frosted cake."
	icon_state = "trumpetcake"
	slice_path = /obj/item/food/cakeslice/trumpet
	bonus_reagents = list(/datum/reagent/medicine/polypyr = 15, /datum/reagent/consumable/cream = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/berryjuice = 5)
	filling_color = "#7A3D80"
	tastes = list("cake" = 4, "violets" = 2, "jam" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/trumpet
	name = "spaceman's cake"
	desc = "A spaceman's trumpet frosted cake."
	icon_state = "trumpetcakeslice"
	filling_color = "#7A3D80"
	tastes = list("cake" = 4, "violets" = 2, "jam" = 2)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR
