// Uniform slot
/datum/gear/uniform
	subtype_path = /datum/gear/uniform
	slot = ITEM_SLOT_ICLOTHING
	sort_category = "Uniforms and Casual Dress"
	species_blacklist = list("plasmaman") //Envirosuit moment
	cost = 1000

//STANDARD UNIFORM COLORS

/datum/gear/uniform/color
	subtype_path = /datum/gear/uniform/color

/datum/gear/uniform/color/black
	display_name = "black jumpsuit"
	path = /obj/item/clothing/under/color/black

/datum/gear/uniform/color/grey
	display_name = "grey jumpsuit"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/color/blue
	display_name = "blue jumpsuit"
	path = /obj/item/clothing/under/color/blue

/datum/gear/uniform/color/orange
	display_name = "orange jumpsuit"
	path = /obj/item/clothing/under/color/orange

/datum/gear/uniform/color/pink
	display_name = "pink jumpsuit"
	path = /obj/item/clothing/under/color/pink

/datum/gear/uniform/color/red
	display_name = "red jumpsuit"
	path = /obj/item/clothing/under/color/red

/datum/gear/uniform/color/white
	display_name = "white jumpsuit"
	path = /obj/item/clothing/under/color/white

/datum/gear/uniform/color/yellow
	display_name = "yellow jumpsuit"
	path = /obj/item/clothing/under/color/yellow

/datum/gear/uniform/color/darkblue
	display_name = "dark blue jumpsuit"
	path = /obj/item/clothing/under/color/darkblue

/datum/gear/uniform/color/teal
	display_name = "teal jumpsuit"
	path = /obj/item/clothing/under/color/teal

/datum/gear/uniform/color/lightpurple
	display_name = "purple jumpsuit"
	path = /obj/item/clothing/under/color/lightpurple

/datum/gear/uniform/color/darkgreen
	display_name = "dark green jumpsuit"
	path = /obj/item/clothing/under/color/darkgreen

/datum/gear/uniform/color/lightbrown
	display_name = "light brown jumpsuit"
	path = /obj/item/clothing/under/color/lightbrown

/datum/gear/uniform/color/khaki
	display_name = "khaki jumpsuit"
	path = /obj/item/clothing/under/color/khaki

/datum/gear/uniform/color/brown
	display_name = "brown jumpsuit"
	path = /obj/item/clothing/under/color/brown

/datum/gear/uniform/color/maroon
	display_name = "maroon jumpsuit"
	path = /obj/item/clothing/under/color/maroon

//PANTS

/datum/gear/uniform/pants
	subtype_path = /datum/gear/uniform/pants

/datum/gear/uniform/pants/bluejeans
	display_name = "pants, blue jeans"
	path = /obj/item/clothing/under/pants/jeans

/datum/gear/uniform/pants/track
	display_name = "track pants, black"
	path = /obj/item/clothing/under/pants/track

/datum/gear/uniform/pants/camo
	display_name = "pants, camoflauge"
	path = /obj/item/clothing/under/pants/camo

//SKIRTS

/datum/gear/uniform/skirt
	subtype_path = /datum/gear/uniform/skirt
	cost = 2500

//SUITS & SUIT JACKETS

/datum/gear/uniform/suit
	subtype_path = /datum/gear/uniform/suit
	cost = 2500

/datum/gear/uniform/suit/suit_jacket
	subtype_path = /datum/gear/uniform/suit/suit_jacket

/datum/gear/uniform/suit/suit_jacket/black
	display_name = "black suit"
	path = /obj/item/clothing/under/suit/black

/datum/gear/uniform/suit/suit_jacket/really_black
	display_name = "executive suit (male)"
	path = /obj/item/clothing/under/suit/black_really

/datum/gear/uniform/suit/suit_jacket/female
	display_name = "executive suit (female)"
	path = /obj/item/clothing/under/suit/black/female

/datum/gear/uniform/suit/suit_jacket/green
	display_name = "green suit"
	path = /obj/item/clothing/under/suit/green

/datum/gear/uniform/suit/suit_jacket/red
	display_name = "red suit"
	path = /obj/item/clothing/under/suit/red

/datum/gear/uniform/suit/suit_jacket/charcoal
	display_name = "charcoal suit"
	path = /obj/item/clothing/under/suit/charcoal

/datum/gear/uniform/suit/suit_jacket/navy
	display_name = "navy suit"
	path = /obj/item/clothing/under/suit/navy

/datum/gear/uniform/suit/suit_jacket/burgundy
	display_name = "burgundy suit"
	path = /obj/item/clothing/under/suit/burgundy

/datum/gear/uniform/suit/suit_jacket/checkered
	display_name = "checkered suit"
	path = /obj/item/clothing/under/suit/checkered

/datum/gear/uniform/suit/suit_jacket/tan
	display_name = "tan suit"
	path = /obj/item/clothing/under/suit/tan

/datum/gear/uniform/suit/suit_jacket/white
	display_name = "white suit"
	path = /obj/item/clothing/under/suit/white

/datum/gear/uniform/suit/scratch
	display_name = "white and green suit"
	path = /obj/item/clothing/under/suit/white_on_white

/datum/gear/uniform/suit/sl_suit
	display_name = "amish suit"
	path = /obj/item/clothing/under/suit/sl

//MEME & COSTUME ITEMS

/datum/gear/uniform/misc
	subtype_path = /datum/gear/uniform/misc
	cost = 5000

/datum/gear/uniform/misc/jabroni
	display_name = "jabroni leathers"
	path = /obj/item/clothing/under/costume/jabroni
	cost = 20000

/datum/gear/uniform/misc/geisha
	display_name = "geisha suit"
	path = /obj/item/clothing/under/costume/geisha
	cost = 20000

/datum/gear/uniform/misc/soviet
	display_name = "soviet uniform"
	path = /obj/item/clothing/under/costume/soviet

/datum/gear/uniform/misc/pirate
	display_name = "pirate outfit"
	path = /obj/item/clothing/under/costume/pirate

/datum/gear/uniform/misc/sailor
	display_name = "sailor outfit"
	path = /obj/item/clothing/under/costume/sailor

/datum/gear/uniform/misc/perfomer_blue
	display_name = "blue performer's outfit"
	description = "oo-ee-oo"
	path = /obj/item/clothing/under/costume/singer/blue

/datum/gear/uniform/misc/perfomer_yellow
	display_name = "yellow performer's outfit"
	path = /obj/item/clothing/under/costume/singer/yellow

/datum/gear/uniform/misc/maid_costume
	display_name = "maid costume"
	path = /obj/item/clothing/under/costume/maid

/datum/gear/uniform/misc/school_girl_uniform
	display_name = "school girl uniform"
	description = "The perfect outfit for all of your twisted cosplaying needs."
	path = /obj/item/clothing/under/costume/schoolgirl

/datum/gear/uniform/misc/clown_costume
	display_name = "clown costume"
	description = "Dress up just like your hero! The... clown...?"
	path = /obj/item/clothing/under/rank/civilian/clown

/datum/gear/uniform/misc/mime_costume
	display_name = "mime costume"
	description = "..."
	path = /obj/item/clothing/under/rank/civilian/mime

/datum/gear/uniform/misc/swagoutfit
	display_name = "swag outfit"
	path = /obj/item/clothing/under/costume/swagoutfit
	cost = 69000

//RANK SUBTYPE

/datum/gear/uniform/rank
	subtype_path = /datum/gear/uniform/rank
	cost = 2500

//ASSISTANTS FORMALS

/datum/gear/uniform/rank/assistant
	subtype_path = /datum/gear/uniform/rank/assistant
	allowed_roles = list("Assistant")

/datum/gear/uniform/rank/assistant/formal
	display_name = "assistant's formal uniform"
	path = /obj/item/clothing/under/misc/assistantformal

/datum/gear/uniform/rank/assistant/vice
	display_name = "vice officer's jumpsuit"
	path = /obj/item/clothing/under/misc/vice_officer


//COOKING ALT UNI

/datum/gear/uniform/rank/cook
	subtype_path = /datum/gear/uniform/rank/cook
	allowed_roles = list("Cook")

/datum/gear/uniform/rank/cook/red
	display_name = "cook's suit, red"
	path = /obj/item/clothing/under/rank/civilian/altchef

//CARGO ALT UNIS

/datum/gear/uniform/rank/cargo
	subtype_path = /datum/gear/uniform/rank/cargo
	allowed_roles = list("Quartermaster", "Cargo Technician", "Shaft Miner")

/datum/gear/uniform/rank/cargo/overalls
	display_name = "laborer's overalls, light blue"
	path = /obj/item/clothing/under/misc/overalls

/datum/gear/uniform/rank/cargo/mining_classic
	display_name = "miner's overalls, asteroid purple"
	description = "Purple jumpsuit, dirty overalls. Standard Nanotrasen Shaft Miner attire, from when Lavaland had yet to be discovered and exploited for plasma."
	path = /obj/item/clothing/under/rank/cargo/miner
	allowed_roles = list ("Shaft Miner")

//MEDICAL ALT UNIS

/datum/gear/uniform/rank/medical
	subtype_path = /datum/gear/uniform/rank/medical
	allowed_roles = list("Paramedic", "Medical Doctor", "Chief Medical Officer")

/datum/gear/uniform/rank/medical/nurse_dress
	display_name = "medical, nurse's dress"
	path = /obj/item/clothing/under/rank/medical/doctor/nurse

/datum/gear/uniform/rank/medical/emt
	display_name = "medical scrubs, EMT"
	path = /obj/item/clothing/under/rank/medical/emt

/datum/gear/uniform/rank/medical/scrubs_blue
	display_name = "medical scrubs, baby blue"
	path = /obj/item/clothing/under/rank/medical/doctor/blue

/datum/gear/uniform/rank/medical/scrubs_green
	display_name = "medical scrubs, green"
	path = /obj/item/clothing/under/rank/medical/doctor/green

/datum/gear/uniform/rank/medical/scrubs_purple
	display_name = "medical scrubs, purple"
	path = /obj/item/clothing/under/rank/medical/doctor/purple

//ENGINEERING ALT UNIS

/datum/gear/uniform/rank/engineering
	subtype_path = /datum/gear/uniform/rank/engineering
	allowed_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

/datum/gear/uniform/rank/engineering/hazard
	display_name = "engineering jumpsuit, hazard"
	path = /obj/item/clothing/under/rank/engineering/engineer/hazard

/datum/gear/uniform/rank/engineering/overalls
	display_name = "engineering overalls"
	path = /obj/item/clothing/under/misc/overalls

//SECURITY ALT UNIS

/datum/gear/uniform/rank/security
	subtype_path = /datum/gear/uniform/rank/security
	allowed_roles = list("Security Officer")

/datum/gear/uniform/rank/security/white
	display_name = "security jumpsuit, white"
	path = /obj/item/clothing/under/rank/security/officer/white

/datum/gear/uniform/rank/security/skirt
	display_name = "security jumpskirt"
	path = /obj/item/clothing/under/rank/security/officer/skirt

/datum/gear/uniform/rank/security/blueshift
	display_name = "security jumpsuit, blue shirt and tie"
	path = /obj/item/clothing/under/rank/security/officer/blueshirt
	cost = 7500

/datum/gear/uniform/rank/security/blart
	display_name = "security jumpsuit, Nanotrasen mall cop uniform"
	path = /obj/item/clothing/under/rank/security/officer/mallcop
	cost = 7500

/datum/gear/uniform/rank/security/formal
	display_name = "formal security jumpsuit"
	path = /obj/item/clothing/under/rank/security/officer/formal
	cost = 7500

/datum/gear/uniform/rank/security/warden_formal
	display_name = "formal warden jumpsuit"
	path = /obj/item/clothing/under/rank/security/warden/formal
	allowed_roles = list("Warden")
	cost = 7500

/datum/gear/uniform/rank/security/hos_formal
	display_name = "formal head of security jumpsuit"
	path = /obj/item/clothing/under/rank/security/head_of_security/formal
	allowed_roles = list("Head of Security")
	cost = 7500

//ROBOTICIST ALT UNIS

/datum/gear/uniform/rank/roboticist
	subtype_path = /datum/gear/uniform/rank/roboticist
	allowed_roles = list("Roboticist")
	cost = 2500

/datum/gear/uniform/rank/roboticist/red_pilot_suit
	display_name = "red mech pilot suit"
	path = /obj/item/clothing/under/costume/mech_suit

/datum/gear/uniform/rank/roboticist/blue_pilot_suit
	display_name = "blue mech pilot suit"
	path = /obj/item/clothing/under/costume/mech_suit/blue
	description = "Get in the gygax, Captain."

/datum/gear/uniform/rank/roboticist/white_pilot_suit
	display_name = "white mech pilot suit"
	path = /obj/item/clothing/under/costume/mech_suit/white

//CLOWN ALT UNIS

/datum/gear/uniform/rank/clown
	subtype_path = /datum/gear/uniform/rank/clown
	allowed_roles = list("Clown")
	cost = 2500

/datum/gear/uniform/rank/clown/rainbow_clown_suit
	display_name = "rainbow clown suit"
	description = "<b>HONK!!</b>"
	path = /obj/item/clothing/under/rank/civilian/clown/rainbow
