/obj/item/clothing/suit/space/space_ninja/proc/ntick(mob/living/carbon/human/U = affecting)
	//Runs in the background while the suit is initialized.
	//Requires charge or stealth to process.
	spawn while(suit_initialized)
		if(!affecting)
			terminate()//Kills the suit and attached objects.

		else if(cell.charge > 0)
			if(suit_cooldown)
				suit_cooldown--//Checks for ability s_cooldown first.

			cell.charge -= suit_cost//suit_cost is the default energy cost each ntick, usually 5.
			if(stealth_enabled)//If stealth is active.
				cell.charge -= suit_stealth_cost

		else
			cell.charge = 0
			cancel_stealth()

		sleep(10)//Checks every second.
