/datum/job/rancher
	title = "Rancher"
	flag = RANCHER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#bbe291"
	chat_color = "#95DE85"

	outfit = /datum/outfit/job/rancher

	access = list(ACCESS_HYDROPONICS, ACCESS_RANCHER, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_RANCHER, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_RANCHER
	bounty_types = CIV_JOB_GROW
	departments = DEPARTMENT_SERVICE
	rpg_title = "Animal Handler"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/botany
	)
/datum/outfit/job/rancher
	name = "Rancher"
	jobtype = /datum/job/rancher

	head = /obj/item/clothing/head/oldhat
	id = /obj/item/card/id/job/serv
	belt = /obj/item/pda/service
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/rancher
	l_pocket = /obj/item/chicken_scanner
	r_pocket = /obj/item/storage/bag/egg

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd

/datum/job/rancher/after_spawn(mob/living/H, mob/M)
	. = ..()
	var/obj/item/chicken_book/created_book = new
	H.equip_to_slot_or_del(created_book, ITEM_SLOT_BACKPACK)
