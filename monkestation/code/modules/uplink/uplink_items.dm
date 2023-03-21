/datum/uplink_item/role_restricted/boom_boots
	name = "Boom Boots"
	desc = "The pinnacle of clown footwear technology.  Fit for only the loudest and proudest! \
			Fully functional hydraulic clown shoes with anti-slip technology.  Anyone who tries \
			to remove these from your person will be in for an explosive surprise, to boot. "
	item = /obj/item/clothing/shoes/magboots/boomboots
	cost = 20
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/psycho_scroll
	name = "The Rants of the Debtor"
	desc = "This roll of toilet paper has writings on it that will allow you to master the art of the Psychotic Brawl, but beware the cost to your own sanity."
	item = /obj/item/book/granter/martial/psychotic_brawl
	cost = 8
	restricted_roles = list("Debtor")
	surplus = 0

/datum/uplink_item/role_restricted/arcane_beacon
	name = "Beacon of Magical Items"
	desc = "This beacon allows you to choose a rare magitech item that will make your performance truly unforgettable."
	item = /obj/item/choice_beacon/magic
	cost = 5
	restricted_roles = list("Stage Magician")
	surplus = 0

/datum/uplink_item/implants/hardlight
	name = "Hardlight Spear Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will summon a spear \
			made out of hardlight that the user can use to wreak havoc."
	item = /obj/item/storage/box/syndie_kit/imp_hard_spear
	cost = 10

/datum/uplink_item/device_tools/bearserum
	name = "Werebear Serum"
	desc = "This serum made by BEAR Co (A group of very wealthy bears) will give other species the chance to be bear."
	item = /obj/item/bearserum
	cost = 12

//Species Specific Items

/datum/uplink_item/race_restricted/monkey_barrel
	name = "Angry Monkey Barrel"
	desc = "Expert Syndicate Scientists put pissed a couple monkeys off and put them in a barrel. It isn't that complicated, but it's very effective"
	cost = 7
	item = /obj/item/grenade/monkey_barrel
	restricted_species = list("simian")

/datum/uplink_item/race_restricted/monkey_ball
	name = "Monkey Ball"
	desc = "Stolen experimental MonkeTech designed to bring a monkey's speed to dangerous levels."
	cost = 12
	item = /obj/vehicle/ridden/monkey_ball
	restricted_species = list("simian")

/datum/uplink_item/dangerous/lever_action
	name = "Lever Action Shotgun"
	desc = "A western lever action shotgun we found on a planet in the frontier, fits in your backpack unlike most shotguns, and can be levered with one hand. Fits five shells."
	item = /obj/item/gun/ballistic/shotgun/lever_action
	cost = 9

//NEW TOT SHOTGUN AMMO BOXES
/datum/uplink_item/ammo/trickshot
	name = "Trickshot Shell Box"
	desc = "A box with 10 trickshot shells, capable of bouncing up to five times, they are made for the most talented trickshooters around."
	cost = 3
	item = /obj/item/storage/box/trickshot

/datum/uplink_item/ammo/uraniumpen
	name = "Uranium Penetrator Box"
	desc = "A box with 10 uranium penetrators, capable to penetrating walls and objects, but not people. Works best with thermals!"
	cost = 4
	item = /obj/item/storage/box/uraniumpen

/datum/uplink_item/ammo/beeshot
	name = "Beeshot Box"
	desc = "A box with 10 Beeshot shells. Creates very angry bees upon impact. Not as strong as buckshot."
	cost = 4
	item = /obj/item/storage/box/beeshot

//END OF NEW TOT SHOTGUN AMMO
