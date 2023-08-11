/mob/living/simple_animal/hostile/monkedome_fauna/spore
	name = "spore"
	icon = 'monkestation/icons/mob/monkedome/monkedome_monsters.dmi'
	icon_state = "spore"
	icon_living = "spore"
	icon_dead = "spore_dead"

	environment_smash = ENVIRONMENT_SMASH_NONE

	ranged = TRUE
	projectiletype = /obj/item/projectile/spore_shot

	health = 10
	maxHealth = 10

	melee_damage = 0
	obj_damage = 0

	del_on_death = TRUE

	faction = list("dome","hostile")

	ranged_message = "shoots ooze at"
	ranged_cooldown_time = 5 SECONDS
	retreat_distance = 4
	minimum_distance = 6

	check_friendly_fire = TRUE

	move_to_delay = 0.25 SECONDS

//Projectile

/obj/item/projectile/spore_shot
	name = "rock"
	icon_state = "bullet"
	pass_flags = PASSTABLE
	damage = 2
	flag = "bullet"
	var/list/static/possible_reagents = list(
		/datum/reagent/toxin/acid,
		/datum/reagent/toxin/spore,
		/datum/reagent/drug/space_drugs,
		/datum/reagent/toxin/mushroom_powder,
		/datum/reagent/toxin/bungotoxin,
	)

/obj/item/projectile/spore_shot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target

		var/reagent_amount = rand(15,45)
		var/datum/reagents/spore_reagents = new()
		spore_reagents.my_atom = src
		spore_reagents.add_reagent(pick(possible_reagents), reagent_amount)

		if(human_target.wear_suit && human_target.head && isclothing(human_target.wear_suit) && isclothing(human_target.head))
			var/obj/item/clothing/clothing_suit = human_target.wear_suit
			var/obj/item/clothing/clothing_head = human_target.head
			if (clothing_suit.clothing_flags & clothing_head.clothing_flags & THICKMATERIAL)
				spore_reagents.trans_to(target, reagent_amount, method = TOUCH, transfered_by = src)
				return

			spore_reagents.trans_to(target, reagent_amount, method = INJECT, transfered_by = src)
