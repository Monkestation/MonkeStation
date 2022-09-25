//Karate, but with deflection when not wielding a sword

/datum/martial_art/karate/cyborg_ninjitsu
	name = "Cyborg Ninjitsu"
	//When holding the katana but not wielding it: 100% deflection.
	//When holding the katana and wielding it: 0% deflection
	deflection_chance = 0
	reroute_deflection = TRUE
	//We don't need ninjas with guns
	no_guns = TRUE
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/ninjitsu_help


//Different proc to explain the katana connection
/mob/living/carbon/human/proc/ninjitsu_help()
	set name = "Recall Training"
	set desc = "Remember your VR training."
	set category = "Ninjitsu"

	to_chat(usr, "<b><i>You try to remember your ninja skills...</i></b>")

	to_chat(usr, "<span class='notice'>While holding your katana but not wielding it in both hands, you are able to deflect enemy projectiles!</span>")
	to_chat(usr, "<span class='notice'>Calf Kick</span>: Harm Grab Disarm. Paralyses one of your opponent's legs.")
	to_chat(usr, "<span class='notice'>Jumping Knee</span>: Harm Disarm Harm. Deals significant stamina damage and knocks your opponent down briefly.")
	to_chat(usr, "<span class='notice'>Karate Chop</span>: Grab Harm Disarm. Very briefly confuses your opponent and blurs their vision.")
	to_chat(usr, "<span class='notice'>Floor Stomp</span>: Harm Grab Harm. Deals brute and stamina damage if your opponent isn't standing up.")
