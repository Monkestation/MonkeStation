//Wakes the user so they are able to do their thing. Also injects a decent dose of radium.
//Movement impairing would indicate drugs and the like.

/datum/action/item_action/ninjaboost
	check_flags = NONE
	name = "Adrenaline Boost"
	desc = "Inject a secret chemical that will counteract all movement-impairing effect."
	button_icon_state = "repulse"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'

/**
  * Proc called to activate space ninja's adrenaline.
  *
  * Proc called to use space ninja's adrenaline.  Gets the ninja out of almost any stun.
  * Also makes them shout MGS references when used.  After a bit, it injects the user with
  * radium by calling a different proc.
  */
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost()
	if(ninja_cost(0,N_ADRENALINE))
		return
	var/mob/living/carbon/human/ninja = affecting
	ninja.SetUnconscious(0)
	ninja.SetStun(0)
	ninja.SetKnockdown(0)
	ninja.SetImmobilized(0)
	ninja.SetParalyzed(0)
	ninja.adjustStaminaLoss(-200)
	ninja.stuttering = 0
	ninja.reagents.add_reagent(/datum/reagent/medicine/stabilizing_nanites, 10)
	ninja.reagents.add_reagent(/datum/reagent/medicine/pumpup, 15)
	ninja.say(pick("A CORNERED FOX IS MORE DANGEROUS THAN A JACKAL!","HURT ME MOOORRREEE!","IMPRESSIVE!", "SHOW ME A GOOD TIME, JACK!", "HISTORY WILL DECIDE WHO'S RIGHT!", "LETS DANCE!", "NOW THIS IS A FIGHT!"), forced = "ninjaboost")
	adrenaline_available = FALSE
	to_chat(ninja, "<span class='notice'>You have used your adrenaline boost. Refill your suit with Radium.</span>")
	suit_cooldown = 6
	addtimer(CALLBACK(src, .proc/ninjaboost_after), 7 SECONDS)

/**
  * Proc called to inject the ninja with radium.
  *
  * Used after 7 seconds of using the ninja's adrenaline.
  * Injects the user with how much radium the suit needs to refill an adrenaline boost.
  */
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost_after()
	var/mob/living/carbon/human/ninja = affecting
	ninja.reagents.add_reagent(/datum/reagent/uranium/radium, suit_radium_injected)
	suit_radium_injected += 1 //Affects you more the longer you use it. From 6u to 13u
	to_chat(ninja, "<span class='danger'>You are beginning to feel the after-effect of the injection.</span>")
