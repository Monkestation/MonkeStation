/mob/living/simple_animal/hostile/asteroid/golem/silver
	name = "silver golem"
	desc = "A moving pile of rocks with silver specks in it."

	icon_state = "golem_silver"

	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	melee_damage = GOLEM_DMG_MED
	obj_damage = GOLEM_DMG_MED

	move_to_delay = GOLEM_SPEED_MED

	ore_type = /obj/item/stack/ore/silver

/mob/living/simple_animal/hostile/asteroid/golem/silver/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(I.force > 5)
		visible_message(span_danger("\The [src] reflects \the [I.name]!"))
		user.adjustBruteLoss(I.force * 0.2)
