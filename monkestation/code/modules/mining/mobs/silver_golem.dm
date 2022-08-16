/mob/living/simple_animal/hostile/asteroid/golem/silver
	name = "silver golem"
	desc = "A moving pile of rocks with silver specks in it."

	icon_state = "golem_silver"

	maxHealth = 150
	health = 150

	melee_damage = 6
	obj_damage = 6

	ore_type = /obj/item/stack/ore/silver

/mob/living/simple_animal/hostile/asteroid/golem/silver/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(I.force > 5)
		visible_message(span_danger("\The [src] reflects \the [I.name]!"))
		user.adjustBruteLoss(I.force * 0.2)
