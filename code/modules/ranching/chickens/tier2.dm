/mob/living/simple_animal/chicken/spicy
	breed_name = "Spicy"
	egg_type = /obj/item/food/egg/spicy
	chicken_path = /mob/living/simple_animal/chicken/spicy
	mutation_list = list(/datum/ranching/mutation/phoenix)

/obj/item/food/egg/spicy
	name = "Spicy Egg"

/mob/living/simple_animal/chicken/hostile/raptor
	breed_name = "Raptor"
	breed_name_male = "Tiercel"
	egg_type = /obj/item/food/egg/raptor
	chicken_path = /mob/living/simple_animal/chicken/hostile/raptor

/obj/item/food/egg/raptor
	name = "Raptor Egg"

/mob/living/simple_animal/chicken/cotton_candy
	breed_name = "Cotton Candy"
	egg_type = /obj/item/food/egg/cotton_candy
	chicken_path = /mob/living/simple_animal/chicken/cotton_candy
	mutation_list = list()

/mob/living/simple_animal/chicken/cotton_candy/Life()
	.=..()
	if(prob(0.2))
		visible_message("<span class='warning'>[src] starts to shake seems like they are gonna have a sugar rush!</span>")
		sleep(3)
		src.apply_status_effect(HEN_RUSH)

/obj/item/food/egg/cotton_candy
	name = "Sugary Egg"

/obj/item/food/egg/cotton_candy/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(SUGAR_RUSH)


/datum/status_effect/ranching/hen_rush
	id = "hen_rush"
	duration = 10 SECONDS

/datum/status_effect/ranching/sugar_rush/on_apply()
	owner.add_movespeed_modifier("sugar_rush", update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))
	owner.Move()
	owner.Move()
	owner.Move()
	return ..()

/datum/status_effect/ranching/sugar_rush/on_remove()
	owner.remove_movespeed_modifier("sugar_rush")

/datum/status_effect/ranching/sugar_rush
	id = "sugar_rush"
	duration = 30 SECONDS
	tick_interval = 1 SECONDS

/datum/status_effect/ranching/sugar_rush/on_apply()
	owner.add_movespeed_modifier("sugar_rush", update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))
	return ..()

/datum/status_effect/ranching/sugar_rush/tick()
	var/datum/reagents/owners_reagents = owner.reagents
	if(owners_reagents)
		owners_reagents.add_reagent(/datum/reagent/consumable/sugar, 2)

/datum/status_effect/ranching/sugar_rush/on_remove()
	owner.remove_movespeed_modifier("sugar_rush")


/mob/living/simple_animal/chicken/snowy
	breed_name = "Snow"
	egg_type = /obj/item/food/egg/snowy
	chicken_path = /mob/living/simple_animal/chicken/snowy
	minbodytemp = 0
	maxbodytemp = 40

/obj/item/food/egg/snowy
	name = "Snowy Egg"


/obj/item/food/egg/snowy/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(SNOWY_EGG)

/datum/status_effect/ranching/snowy
	id = "snowy_egg"
	duration = 30 SECONDS
	tick_interval = 2 SECONDS
	///Your alpha at the start of the buff
	var/base_alpha
	///your color at the start of the buff
	var/base_color
	///your temp at the start of the buff
	var/old_temp

/datum/status_effect/ranching/snowy/on_apply()
	old_temp = owner.bodytemperature
	owner.bodytemperature = TCMB
	base_alpha = owner.alpha
	owner.alpha = 155
	base_color = owner.color
	owner.color = "#018eb9"
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/create_ice)
	return ..()

/datum/status_effect/ranching/snowy/tick()
	owner.bodytemperature = TCMB

/datum/status_effect/ranching/snowy/proc/create_ice()
	var/turf/open/owners_location = owner.loc
	if(owners_location)
		owners_location.MakeSlippery(TURF_WET_PERMAFROST, min_wet_time = 10, wet_time_to_add = 5)

/datum/status_effect/ranching/snowy/on_remove()
	owner.bodytemperature = old_temp
	owner.alpha = base_alpha
	owner.color = base_color
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

/mob/living/simple_animal/chicken/pigeon
	breed_name_male = "Pigeon"
	breed_name_female = "Pigeon"
	egg_type = /obj/item/food/egg/pigeon
	chicken_path = /mob/living/simple_animal/chicken/pigeon

	///the radio that is inside the pigeon
	var/obj/item/radio/pigeon/egg_radio = null

/mob/living/simple_animal/chicken/pigeon/Initialize(mapload)
	. = ..()
	egg_radio = new /obj/item/radio/pigeon/egg_radio(src)

/mob/living/simple_animal/chicken/pigeon/Destroy()
	. = ..()
	egg_radio = null

/obj/item/radio/pigeon/egg_radio
	frequency = 1477
	canhear_range = 0
	listening_range = 8
	broadcasting = TRUE

/obj/item/food/egg/pigeon
	name = "Pigeon Egg"


	///the radio inside the egg
	var/obj/item/radio/pigeon/egg_radio = null

/obj/item/food/egg/pigeon/Initialize(mapload)
	.=..()
	egg_radio = new /obj/item/radio/pigeon/egg_radio(src)

/obj/item/food/egg/pigeon/Destroy()
	. = ..()
	egg_radio = null

/obj/item/food/egg/pigeon/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(PIGEON)

/datum/status_effect/ranching/pigeon
	id = "pigeon"
	duration = 600 SECONDS

	///the radio that is put inside you
	var/obj/item/radio/pigeon/egg_radio = null

/datum/status_effect/ranching/pigeon/on_apply()
	egg_radio = new /obj/item/radio/pigeon/egg_radio(owner)
	return ..()

/datum/status_effect/ranching/pigeon/on_remove()
	egg_radio = null

/mob/living/simple_animal/chicken/dream
	breed_name = "Dream"
	egg_type = /obj/item/food/egg/dream
	chicken_type = /mob/living/simple_animal/chicken/dream
	mutation_list = list()

/obj/item/food/egg/dream
	name = "Dream Egg"

/obj/item/food/egg/dream/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(DREAM_STATE)

/datum/status_effect/ranching/dream_state
	id = "dream_state"
	duration = 60 SECONDS

/datum/status_effect/ranching/dream_state/on_apply()
	owner.visible_message("<span class='notice'>[owner] goes into a deep sleep!</span>")
	owner.fakedeath("dream_state") //play dead
	owner.update_stat()
	owner.update_mobility()
	return ..()

/datum/status_effect/ranching/dream_state/on_remove()
	owner.visible_message("<span class='notice'>[owner] awakes from their deep sleep!</span>")
	owner.cure_fakedeath("dream_state")
	owner.revive(full_heal = TRUE)
	owner.regenerate_organs()

/mob/living/simple_animal/chicken/stone
	breed_name = "Stone"
	egg_type = /obj/item/food/egg/stone
	chicken_type = /mob/living/simple_animal/chicken/stone
	mutation_list = list()

/obj/item/food/egg/stone
	name = "Rocky Egg"

/obj/item/food/egg/stone/attackby(obj/item/attacked_item, mob/user, params)
	. = ..()
	if(istype(attacked_item, /obj/item/stack/ore))
		visible_message("<span class='notice'>The [attacked_item] starts to melt into the [src]!</span>")
		production_type = attacked_item
		qdel(attacked_item)
	if(attacked_item.force > 10 && production_type)
		visible_message("<span class='notice'>[src] is cracked open revealing [production_type] inside!</span>")

		new production_type.type(src.loc, 1)
		for(var/mob/living/simple_animal/chicken/viewer_chicken in view(3, src))
			visible_message("<span class='notice'>[viewer_chicken] becomes upset from seeing an egg broken near them!</span>")
			viewer_chicken.happiness -= 10
		qdel(src)

/mob/living/simple_animal/chicken/hostile/retaliate/wiznerd //No matter what you say Zanden this is staying as wiznerd
	maxHealth = 150
	melee_damage = 7
	obj_damage = 5

	breed_name_female = "Witchen"
	breed_name_male = "Wizter"
	egg_type = /obj/item/food/egg/wiznerd
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/wiznerd
	mutation_list = list()

	ranged = TRUE
	projectiletype = /obj/item/projectile/magic/magic_missle_weak
	ranged_cooldown = 10 SECONDS

/obj/item/food/egg/wiznerd
	name = "Bewitching Egg"

/obj/item/food/egg/wiznerd/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	eater.apply_status_effect(WIZNERD_EGG)

/datum/status_effect/ranching/wiznerd
	id = "wiznerd_egg"
	duration = 60 SECONDS
	var/obj/effect/proc_holder/spell/power = /obj/effect/proc_holder/spell/aimed/magic_missle_weak

/datum/status_effect/ranching/wiznerd/on_apply()
	power = new power()
	power.action_background_icon_state = "bg_tech_blue_on"
	power.panel = "Spell"
	owner.AddSpell(power)
	return ..()

/datum/status_effect/ranching/wiznerd/on_remove()
	owner.RemoveSpell(power)

/obj/effect/proc_holder/spell/aimed/magic_missle_weak
	name = "Magic Missle"
	desc = "This spell launches a barrage of missles at the target dealing moderate damage."

	clothes_req = FALSE
	range = 20
	charge_max = 20 SECONDS
	action_icon_state = "charge"

	base_icon_state = "projectile"
	active_icon_state = "projectile"

	projectile_amount = 3
	projectile_type = /obj/item/projectile/magic/magic_missle_weak

/obj/item/ammo_casing/magic/magic_missle_weak
	projectile_type = /obj/item/projectile/magic/magic_missle_weak

/obj/item/projectile/magic/magic_missle_weak
	name = "magic missile"
	icon_state = "ion"
	damage = 5
	damage_type = BRUTE


/mob/living/simple_animal/chicken/hostile/retaliate/sword
	maxHealth = 300
	melee_damage = 4 //weak damage but strong health
	obj_damage = 5

	breed_name_female = "Shieldmaidhen"
	breed_name_male = "Fowlcion"
	egg_type = /obj/item/food/egg/sword
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/sword
	mutation_list = list()

/obj/item/food/egg/sword
	name = "Gallant Egg"

/obj/item/food/egg/sword/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	. = ..()
	eater.apply_status_effect(ARMORED_EGG)

/datum/status_effect/ranching/sword_chicken
	id = "sword_egg"
	duration = 60 SECONDS

/datum/status_effect/ranching/sword_chicken/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/buffed_person = owner
		buffed_person.physiology.armor.melee += 30
		buffed_person.physiology.armor.bullet += 30
	return ..()

/datum/status_effect/ranching/sword_chicken/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/buffed_person = owner
		buffed_person.physiology.armor.melee -= 30
		buffed_person.physiology.armor.bullet -= 30

/mob/living/simple_animal/chicken/golden
	breed_name = "Golden"
	egg_type = /obj/item/food/egg/golden
	chicken_type = /mob/living/simple_animal/chicken/golden

/obj/item/food/egg/golden
	name = "Golden Egg"

/obj/item/food/egg/golden/consumed_egg(datum/source, mob/living/eater, mob/living/feeder)
	. = ..()
	eater.apply_status_effect(GOLD_SPARKLE)

/datum/status_effect/ranching/gold_egg
	id = "sparkly_egg"
	duration = 10 MINUTES


/datum/status_effect/ranching/gold_egg/on_apply()
	var/mutable_appearance/sparkle = mutable_appearance('icons/effects/effects.dmi')
	sparkle.icon_state = "blessed"
	owner.add_overlay(sparkle)
	return ..()

/datum/status_effect/ranching/gold_egg/on_remove()
	var/mutable_appearance/sparkle = mutable_appearance('icons/effects/effects.dmi')
	sparkle.icon_state = "blessed"
	owner.cut_overlay(sparkle)

#define inflict_suffering 60 SECONDS
/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad
	breed_name_male = "huOnkHoNkHoeNK"
	breed_name_female = "huOnkHoNkHoeNK"
	temp_min = 0
	retaliates = FALSE

	egg_type = /obj/item/food/egg/clown_sad
	chicken_type = /mob/living/simple_animal/chicken/hostile/retaliate/clown_sad
	mutation_list = list()
	var/mob/living/carbon/human/fuck_this_dude
	COOLDOWN_DECLARE(misery)
	var/invalid_area_typecache = list(/area/space, /area/lavaland, /area/centcom, /area/shuttle/syndicate)
	var/turf/old_loc = null

/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad/Initialize(mapload)
	. = ..()
	var/list/pick_holders = list()
	for(var/mob/living/carbon/human/pickee in GLOB.player_list)
		var/area/pickee_area = get_area(src.loc)
		if(!is_type_in_typecache(pickee_area, invalid_area_typecache))
			pick_holders |= pickee
	if(pick_holders.len)
		fuck_this_dude = pick(pick_holders)

/mob/living/simple_animal/chicken/hostile/retaliate/clown_sad/Life()
	.=..()
	if(COOLDOWN_FINISHED(src, misery) && fuck_this_dude)
		if(!old_loc)
			old_loc = src.loc
		var/atom/target_from = GET_TARGETS_FROM(src)
		if(isturf(target_from.loc) && fuck_this_dude.Adjacent(target_from))
			switch(rand(1,100))
				if(0 to 50)
					fuck_this_dude.slip(50)
					emote("cries")
					COOLDOWN_START(src, misery, inflict_suffering)
					return

				if(51 to 100)
					var/obj/item/food/pie/cream/pie_time = new /obj/item/food/pie/cream()

					pie_time.throw_at(fuck_this_dude, 10 , 3, src, TRUE)
					emote("cries")
					COOLDOWN_START(src, misery, inflict_suffering)
					return
		else

			if(prob(10))
				apply_status_effect(ANGRY_HONK_SPEED)
			Goto(fuck_this_dude, 2, 1)
			return
	else
		Goto(old_loc, 1 , 1)

#undef inflict_suffering

/obj/item/food/egg/clown_sad
	name = "Clown? Egg"

/datum/status_effect/ranching/angry_honk
	id = "pissed_sad_clown"
	duration = 3 SECONDS

/datum/status_effect/ranching/angry_honk/on_apply()
	owner.pass_flags |= PASSMOB
	owner.pass_flags |= PASSDOORS
	owner.pass_flags |= PASSGRILLE
	owner.pass_flags |= PASSGLASS
	owner.pass_flags |= PASSCLOSEDTURF
	return ..()

/datum/status_effect/ranching/angry_honk/on_remove()
	owner.pass_flags -= PASSMOB
	owner.pass_flags -= PASSDOORS
	owner.pass_flags -= PASSGRILLE
	owner.pass_flags -= PASSGLASS
	owner.pass_flags -= PASSCLOSEDTURF
