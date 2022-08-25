/obj/item/chemical_cartridge
	name = "Chemical Cartridge"
	desc = "A cartridge filled with chemicals used in the chemical assembler."
	//need new sprites
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"

	var/chemical_volume = 3000

/obj/item/chemical_cartridge/examine(mob/user)
	. = ..()
	. += span_notice("The cartridge currently has [chemical_volume] out of [initial(chemical_volume)] units left.")


/obj/item/chemical_cartridge/large
	name = "Large Chemical Cartridge"
	chemical_volume = 6000
