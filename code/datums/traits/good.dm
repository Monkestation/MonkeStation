//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Alcohol Tolerance"
	desc = "You become drunk more slowly and suffer fewer drawbacks from alcohol."
	value = 1
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = "<span class='notice'>You feel like you could drink a whole keg!</span>"
	lose_text = "<span class='danger'>You don't feel as resistant to alcohol anymore. Somehow.</span>"

/datum/quirk/apathetic
	name = "Apathetic"
	desc = "You just don't care as much as other people. That's nice to have in a place like this, I guess."
	value = 1
	mood_quirk = TRUE

/datum/quirk/apathetic/add()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier += 0.2

/datum/quirk/drunkhealing
	name = "Drunken Resilience"
	desc = "Nothing like a good drink to make you feel on top of the world. Whenever you're drunk, you slowly recover from injuries."
	value = 2
	mob_trait = TRAIT_DRUNK_HEALING
	gain_text = "<span class='notice'>You feel like a drink would do you good.</span>"
	lose_text = "<span class='danger'>You no longer feel like drinking would ease your pain.</span>"
	medical_record_text = "Patient has unusually efficient liver metabolism and can slowly regenerate wounds by drinking alcoholic beverages."

/datum/quirk/empath
	name = "Empath"
	desc = "Whether it's a sixth sense or careful study of body language, it only takes you a quick glance at someone to understand how they feel."
	value = 2
	mob_trait = TRAIT_EMPATH
	gain_text = "<span class='notice'>You feel in tune with those around you.</span>"
	lose_text = "<span class='danger'>You feel isolated from others.</span>"

/datum/quirk/freerunning
	name = "Freerunning"
	desc = "You're great at quick moves! You can climb tables more quickly."
	value = 2
	mob_trait = TRAIT_FREERUNNING
	gain_text = "<span class='notice'>You feel lithe on your feet!</span>"
	lose_text = "<span class='danger'>You feel clumsy again.</span>"

/datum/quirk/friendly
	name = "Friendly"
	desc = "You give the best hugs, especially when you're in the right mood."
	value = 1
	mob_trait = TRAIT_FRIENDLY
	gain_text = "<span class='notice'>You want to hug someone.</span>"
	lose_text = "<span class='danger'>You no longer feel compelled to hug others.</span>"
	mood_quirk = TRUE

/datum/quirk/jolly
	name = "Jolly"
	desc = "You sometimes just feel happy, for no reason at all."
	value = 1
	mob_trait = TRAIT_JOLLY
	mood_quirk = TRUE
	process = TRUE

/datum/quirk/jolly/on_process(delta_time)
	if(DT_PROB(0.05, delta_time))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "jolly", /datum/mood_event/jolly)

/datum/quirk/light_step
	name = "Light Step"
	desc = "You walk with a gentle step; stepping on sharp objects is quieter, less painful and you won't leave footprints behind you."
	value = 1
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = "<span class='notice'>You walk with a little more litheness.</span>"
	lose_text = "<span class='danger'>You start tromping around like a barbarian.</span>"

/datum/quirk/musician
	name = "Musician"
	desc = "You can tune handheld musical instruments to play melodies that clear certain negative effects and soothe the soul."
	value = 1
	mob_trait = TRAIT_MUSICIAN
	gain_text = "<span class='notice'>You know everything about musical instruments.</span>"
	lose_text = "<span class='danger'>You forget how musical instruments work.</span>"

/datum/quirk/musician/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/choice_beacon/music/B = new(get_turf(H))
	SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_INSERT, B, H, TRUE, TRUE) //insert the item, even if the backpack's full

/datum/quirk/multilingual
	name = "Multilingual"
	desc = "You spent a portion of your life learning to understand an additional language. You may or may not be able to speak it based on your anatomy."
	value = 1
	mob_trait = TRAIT_MULTILINGUAL
	gain_text = "<span class='notice'>You have learned to understand an additional language.</span>"
	lose_text = "<span class='danger'>You have forgotten how to understand a language.</span>"

/datum/quirk/multilingual/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.job == "Curator")
		return
	var/list/languages_possible = typecacheof(list(
		/datum/language/aphasia,
		/datum/language/apidite,
		/datum/language/beachbum,
		/datum/language/buzzwords,
		/datum/language/calcic,
		/datum/language/codespeak,
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/moffic,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/piratespeak,
		/datum/language/ratvar,
		/datum/language/shadowtongue,
		/datum/language/slime,
		/datum/language/sylvan,
		/datum/language/terrum,
		/datum/language/uncommon,
		/datum/language/zoomercant,
		/datum/language/sippins)) //monkestation edit: make multilingual possible for simpletongue species
	languages_possible = languages_possible - typecacheof(/datum/language/codespeak) - typecacheof(/datum/language/narsie) - typecacheof(/datum/language/ratvar)
	languages_possible = languages_possible - H.language_holder.understood_languages
	languages_possible = languages_possible - H.language_holder.spoken_languages
	languages_possible = languages_possible - H.language_holder.blocked_languages
	if(length(languages_possible))
		var/datum/language/random_language = pick(languages_possible)
		var/complextongue = TRUE //monkestation edit: add simian species
		if(issimian(H))
			complextongue = FALSE
		H.grant_language(random_language, TRUE, complextongue, LANGUAGE_MULTILINGUAL)
//Credit To Yowii/Yoworii/Yorii for a much more streamlined method of language library building

/datum/quirk/night_vision
	name = "Night Vision"
	desc = "You can see slightly more clearly in full darkness than most people."
	value = 1
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = "<span class='notice'>The shadows seem a little less dark.</span>"
	lose_text = "<span class='danger'>Everything seems a little darker.</span>"

/datum/quirk/night_vision/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes || eyes.lighting_alpha)
		return
	eyes.Insert(H) //refresh their eyesight and vision

/datum/quirk/photographer
	name = "Photographer"
	desc = "You know how to handle a camera, shortening the delay between each shot."
	value = 1
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = "<span class='notice'>You know everything about photography.</span>"
	lose_text = "<span class='danger'>You forget how photo cameras work.</span>"

/datum/quirk/photographer/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/camera/camera = new(get_turf(H))
	SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_INSERT, camera, H, TRUE, TRUE) //insert the item, even if the backpack's full
	H.regenerate_icons()

/datum/quirk/selfaware
	name = "Self-Aware"
	desc = "You know your body well, and can accurately assess the extent of your wounds."
	value = 2
	mob_trait = TRAIT_SELF_AWARE

/datum/quirk/skittish
	name = "Skittish"
	desc = "You can conceal yourself in danger. Ctrl-shift-click a closed locker to jump into it, as long as you have access."
	value = 2
	mob_trait = TRAIT_SKITTISH

/datum/quirk/spiritual
	name = "Spiritual"
	desc = "You hold a spiritual belief, whether in God, nature or the arcane rules of the universe. You gain comfort from the presence of holy people, and believe that your prayers are more special than others."
	value = 1
	mob_trait = TRAIT_SPIRITUAL
	gain_text = "<span class='notice'>You have faith in a higher power.</span>"
	lose_text = "<span class='danger'>You lose faith!</span>"
	process = TRUE

/datum/quirk/spiritual/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/storage/fancy/candle_box/candles = new(get_turf(H))
	var/obj/item/storage/box/matches/matches = new(get_turf(H))
	SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_INSERT, candles, H, TRUE, TRUE) //insert the item, even if the backpack's full
	SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_INSERT, matches, H, TRUE, TRUE)

/datum/quirk/spiritual/on_process()
	var/comforted = FALSE
	for(var/mob/living/carbon/human/H in oview(5, quirk_holder))
		if(H.mind?.holy_role && H.stat == CONSCIOUS)
			comforted = TRUE
			break
	if(comforted)
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "religious_comfort", /datum/mood_event/religiously_comforted)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "religious_comfort")

/datum/quirk/tagger
	name = "Tagger"
	desc = "You're an experienced artist. While drawing graffiti, you can get twice as many uses out of drawing supplies."
	value = 1
	mob_trait = TRAIT_TAGGER
	gain_text = "<span class='notice'>You know how to tag walls efficiently.</span>"
	lose_text = "<span class='danger'>You forget how to tag walls properly.</span>"

/datum/quirk/tagger/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/toy/crayon/spraycan/spraycan = new(get_turf(H))
	SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_INSERT, spraycan, H, TRUE, TRUE) //insert the item, even if the backpack's full
	H.regenerate_icons()

/datum/quirk/voracious
	name = "Voracious"
	desc = "Nothing gets between you and your food. You eat faster and can binge on junk food! Being fat suits you just fine. Also allows you to have an additional food buff."
	value = 2
	mob_trait = TRAIT_VORACIOUS
	gain_text = "<span class='notice'>You feel HONGRY.</span>"
	lose_text = "<span class='danger'>You no longer feel HONGRY.</span>"

/datum/quirk/voracious/on_spawn()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs ++

/datum/quirk/voracious/remove()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs --

/datum/quirk/gourmand
	name = "Gourmand"
	desc = "You can enjoy the finer things in life. You are able to have one more food buff applied at once."
	value = 2
	mob_trait = TRAIT_GOURMAND
	gain_text = "<span class='notice'>You start to enjoy fine cuisine.</span>"
	lose_text = "<span class='danger'>Those Space Twinkies are starting to look mighty fine.</span>"

/datum/quirk/gourmand/on_spawn()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs ++

/datum/quirk/gourmand/remove()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs --

/datum/quirk/neet
	name = "NEET"
	desc = "For some reason you qualified for social welfare and you don't really care about your own personal hygiene."
	value = 1
	mob_trait = TRAIT_NEET
	gain_text = "<span class='notice'>You feel useless to society.</span>"
	lose_text = "<span class='danger'>You no longer feel useless to society.</span>"
	mood_quirk = TRUE
	process = TRUE

/datum/quirk/neet/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/bank_account/D = H.get_bank_account()
	if(!D) //if their current mob doesn't have a bank account, likely due to them being a special role (ie nuke op)
		return
	D.welfare = TRUE

/datum/quirk/neet/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if (H.hygiene <= HYGIENE_LEVEL_DIRTY)
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "NEET", /datum/mood_event/happy_neet)
	else
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "NEET")
