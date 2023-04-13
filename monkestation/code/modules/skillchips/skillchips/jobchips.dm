/obj/item/skillchip/job/roboticist
	name = "Cyborg C1-RCU-1T skillchip"
	desc = "A roboticist's second best friend."
	auto_traits = list(TRAIT_KNOW_CYBORG_WIRES)
	skill_name = "Cyborg Circuitry"
	skill_description = "Recognise cyborg wire layouts and understand their functionality at a glance."
	skill_icon = "sitemap"
	activate_message = "<span class='notice'>You suddenly comprehend the secrets behind cyborg circuitry.</span>"
	deactivate_message = "<span class='notice'>Cyborg circuitry stops making sense as images of coloured wires fade from your mind.</span>"


/obj/item/skillchip/job/engineer
	name = "Engineering C1-RCU-1T skillchip"
	desc = "Endorsed by Poly."
	auto_traits = list(TRAIT_KNOW_ENGI_WIRES)
	skill_name = "Engineering Circuitry"
	skill_description = "Recognise airlock and APC wire layouts and understand their functionality at a glance."
	skill_icon = "sitemap"
	activate_message = "<span class='notice'>You suddenly comprehend the secrets behind airlock and APC circuitry.</span>"
	deactivate_message = "<span class='notice'>Airlock and APC circuitry stops making sense as images of coloured wires fade from your mind.</span>"

/obj/item/skillchip/job/chemist
	name = "Chemistry D1-5P-3N-5E skillchip"
	desc = "9 out of 10 chemists approve!"
	auto_traits = list(TRAIT_CHEMISTRY)
	skill_name = "Improved Dispensing"
	skill_description = "Improved handling of chemical dispensers lets you dispense at 1 unit increments."
	skill_icon = "flask"
	activate_message = "<span class='notice'>You suddenly comprehend the inner workings of chemical dispensers.</span>"
	deactivate_message = "<span class='notice'>The diagram of the chemical dispenser fades from your mind.</span>"

/obj/item/skillchip/job/bartender
	name = "Bartender B334-B40 skillchip"
	desc = "With this you can get everyone drunk."
	auto_traits = list(TRAIT_CHEMISTRY, TRAIT_BOOZE_SLIDER)
	skill_name = "Improved Bartending"
	skill_description = "Lets you slide beers like in the movies, also lets you dispense in 1 unit increments."
	skill_icon = "beer"
	activate_message = "<span class='notice'>Hours of movies flood into your mind, you feel the ability to slide beers appear in your mind.</span>"
	deactivate_message = "<span class='notice'>You can feel your head go blank, and try as you might you have lost the ability to slide beers.</span>"
