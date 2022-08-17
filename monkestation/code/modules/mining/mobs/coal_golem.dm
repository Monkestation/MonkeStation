/mob/living/simple_animal/hostile/asteroid/golem/coal
	name = "coal golem"
	desc = "A moving pile of rocks with coal specks in it."

	icon_state = "golem_coal"

	ore_type = /obj/item/stack/sheet/mineral/coal

/mob/living/simple_animal/hostile/asteroid/golem/coal/Life()
	if(on_fire)
		visible_message(span_danger("\The [src] is engulfed by fire and turns into diamond!"))
		new /mob/living/simple_animal/hostile/asteroid/golem/diamond(loc, parent=controller)  // Spawn diamond golem at location
		ore_type = null  // So that the golem does not drop coal ores
		death(FALSE, "no message")
	. = ..()
