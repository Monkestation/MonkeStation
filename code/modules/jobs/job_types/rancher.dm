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

	id = /obj/item/card/id/job/serv
	belt = /obj/item/pda/service
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	suit = /obj/item/clothing/suit/apron
	suit_store = /obj/item/chicken_scanner

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd


