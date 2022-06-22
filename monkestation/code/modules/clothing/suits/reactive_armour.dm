/obj/item/clothing/suit/armor/reactive/walter
	name = "reactive walter armor"
	desc = "Your link to the Walterverse."
	var/tele_range = 10

/obj/item/clothing/suit/armor/reactive/walter/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The walter teleporter is still recharging!</span>")
			return 0
		playsound(get_turf(owner),'sound/magic/summonitems_generic.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] summons Walter to block [attack_text]!</span>")
		new /mob/living/simple_animal/pet/dog/bullterrier/walter(src.loc)

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1

/obj/item/clothing/suit/armor/reactive/walter/emp_act()
	if (prob(50)) //Tiny Walter
		var/mob/living/emp_walter = new /mob/living/simple_animal/pet/dog/bullterrier/walter(src.loc)
		emp_walter.resize = 0.5
		emp_walter.maxHealth = 10
		emp_walter.health = 10
	return
