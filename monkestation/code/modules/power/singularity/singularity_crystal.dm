/obj/item/singularity_shard
	name = "singularity shard"
	desc = "THIS SHOULDN'T EXIST. TELL A CODER HOW YOU GOT THIS."
	icon ='monkestation/icons/obj/singularity.dmi'
	icon_state = "singularity_shard_s1"
	resistance_flags = INDESTRUCTIBLE
	var/all_powerful = FALSE /// will it spawn an actual singularity when someone suicides with it

/obj/item/singularity_shard/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] is trying to break open the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	addtimer(CALLBACK(user, /mob/.proc/gib), 99)
	addtimer(CALLBACK(src, .proc/spawnsing), 100)
	return MANUAL_SUICIDE

/obj/item/singularity_shard/proc/spawnsing()
	var/turf/T = get_turf(src)
	if(all_powerful)
		new /obj/singularity(T, src)
		qdel(src)
	else
		new /obj/item/toy/spinningtoy(T, src)

/obj/item/singularity_shard/stage1
	icon_state = "singularity_shard_s1"
	desc = "A radiant shard of what was once an all-consuming maw of the void. You feel a steady pulse emitting from it."

/obj/item/singularity_shard/stage2
	icon_state = "singularity_shard_s2"
	desc = "A radiant shard of what was once an all-consuming maw of the void. The air around it is strangely warm and distorted."

/obj/item/singularity_shard/stage3
	icon_state = "singularity_shard_s3"
	desc = "A radiant shard of what was once an all-consuming maw of the void. Being around it makes your mind feel strange and warm."

/obj/item/singularity_shard/stage4
	icon_state = "singularity_shard_s4"
	desc = "A radiant shard of what was once an all-consuming maw of the void. It feels like it is forcing you to be closer to it."

/obj/item/singularity_shard/stage5
	icon_state = "singularity_shard_s5"
	desc = "A radiant shard of what was once an all-consuming maw of the void. You feel terror just being near it, but at the same time are drawn to the energy it contains."

/obj/item/singularity_shard/stage6
	icon_state = "singularity_shard_s6"
	desc = "A radiant shard of what was once an all-consuming maw of the void. An unstable energy emits through out the air surrounding the shard, it feels like it could destroy all of reality at any moment."
	all_powerful = TRUE
