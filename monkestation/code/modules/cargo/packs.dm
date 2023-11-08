//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Armory //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory/revolver
	name = "Revolver Single-Pack"
	desc = "Contains one revolver, of the sort detectives are known to habitually smuggle on board."
	cost = 1500
	contraband = TRUE
	small_item = TRUE
	contains = list(/obj/item/gun/ballistic/revolver/detective)
	crate_name = "single revolver crate"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Canisters & Materials ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials/random_materials
	name = "Contracted Materials"
	desc = "No miners? We'll contract the work and send you the materials! Contains random processed materials, good luck!"
	cost = 3000
	contains = list()
	crate_name = "contracted materials crate"

/datum/supply_pack/materials/random_materials/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 5)
		var/item = pick(
			prob(200);
				/obj/item/stack/sheet/iron/fifty,
			prob(100);
				/obj/item/stack/sheet/glass/fifty,
			prob(50);
				/obj/item/stack/sheet/plastic/fifty,
			prob(50);
				/obj/item/stack/sheet/mineral/copper/twenty,
			prob(50);
				/obj/item/stack/sheet/mineral/plasma/twenty,
			prob(20);
				/obj/item/stack/sheet/plasteel/twenty,
			prob(20);
				/obj/item/stack/sheet/mineral/titanium/twenty,
			prob(10);
				/obj/item/stack/sheet/mineral/silver/twenty,
			prob(10);
				/obj/item/stack/sheet/mineral/gold/five,
			prob(5);
				/obj/item/stack/sheet/mineral/diamond/five,
			prob(5);
				/obj/item/stack/sheet/mineral/uranium/five,
			prob(5);
				/obj/item/stack/sheet/bluespace_crystal/five
		)
		new item(C)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical/cadaver
	name = "Cadaver Crate"
	desc = "We won't ask why you need it if you don't ask why it's contraband. Contents not guaranteed deceased."
	cost = 700
	contraband = TRUE
	contains = list(/mob/living/carbon/human/)
	crate_name = "cadaver freezer"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/ass
	name = "Ass Crate"
	desc = "What's that smell? Why it's the ass crate of course! For when your coworkers have had prolific posterior pains. Contains abundant assorted asses."
	cost = 800
	contraband = TRUE
	contains = list()
	crate_name = "ass crate"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/ass/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 6)
		var/item = pick(
			prob(200);
				/obj/item/organ/butt,
			prob(20);
				/obj/item/organ/butt/cyber,
			prob(20);
				/obj/item/organ/butt/iron,
			prob(20);
				/obj/item/organ/butt/skeletal,
			prob(10);
				/obj/item/organ/butt/clown,
			prob(10);
				/obj/item/organ/butt/plasma,
			prob(5);
				/obj/item/organ/butt/bluespace,
			prob(5);
				/obj/item/organ/butt/xeno,
			prob(1);
				/obj/item/organ/butt/atomic
		)
		new item(C)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/datum/supply_pack/misc/sticker_set
	name = "Sticker Set"
	desc = "Seven superior selected sticker sets shipped swiftly soon to a station that which you stand. Shaking, shivering, so stimulated! Sticky satisfaction secured, shall someone ship some specialty stickables?"
	cost = 500
	small_item = TRUE
	contains = list(/obj/item/storage/box/stickers)
	crate_name = "Specialty Sticker Set"

/datum/supply_pack/emergency/spatialriftnullifier
	name = "Spatial Rift Nullifier Pack"
	desc = "Everything that the crew needs to take down a rogue Singularity or Tesla."
	cost = 5000
	contains = list(/obj/item/gun/ballistic/SRN_rocketlauncher = 4)
	crate_name = "Spatial Rift Nullifier (SRN)"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/engine/fuel_rod
	name = "Uranium Fuel Rod crate"
	desc = "Two additional fuel rods for use in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 4000
	access = ACCESS_CE
	contains = list(/obj/item/fuel_rod,
					/obj/item/fuel_rod)
	crate_name = "Uranium-235 Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/funny_fuel_rod
	name = "Funny Fuel Rod crate"
	desc = "Two funny fuel rods for use in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 4420
	access = ACCESS_CE
	contains = list(/obj/item/fuel_rod/material/bananium,
					/obj/item/fuel_rod/material/bananium)
	crate_name = "Funny Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/medical/experimental_cloner
	name = "Experimental Cloner Crate"
	desc = "A complete circuitboard set to a Experimental Cloner Pod and Scanner. Caution: Highly Experimental"
	cost = 5000
	access = ACCESS_CARGO
	contains = list(/obj/item/circuitboard/machine/clonepod/experimental,
					/obj/item/circuitboard/machine/clonescanner,
					/obj/item/circuitboard/computer/cloning)
	crate_name = "Experimental Cloner Crate"
	crate_type = /obj/structure/closet/crate/medical
	dangerous = TRUE

/datum/supply_pack/misc/cratecrate
	name = "Crate crate"
	desc = "A crate full of crates. Why? How?"
	cost = 2000
	access = FALSE
	contains = list(/obj/structure/closet/crate,
					/obj/structure/closet/crate,
					/obj/structure/closet/crate)
	crate_name = "Crate Crate"
	crate_type = /obj/structure/closet/crate
