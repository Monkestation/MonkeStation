SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	var/roundstart_paychecks = 5
	var/budget_pool = 25000
	var/list/department_accounts = list(ACCOUNT_CIV = ACCOUNT_CIV_NAME,
										ACCOUNT_ENG = ACCOUNT_ENG_NAME,
										ACCOUNT_SCI = ACCOUNT_SCI_NAME,
										ACCOUNT_MED = ACCOUNT_MED_NAME,
										ACCOUNT_SRV = ACCOUNT_SRV_NAME,
										ACCOUNT_CAR = ACCOUNT_CAR_NAME,
										ACCOUNT_SEC = ACCOUNT_SEC_NAME)
	var/list/generated_accounts = list()
	var/full_ancap = FALSE // Enables extra money charges for things that normally would be free, such as sleepers/cryo/cloning.
							//Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	var/list/bank_accounts = list() //List of normal accounts (not department accounts)
	var/list/dep_cards = list()
	///The modifier multiplied to the value of bounties paid out.
	///Multiplied as they go to all department accounts rather than just cargo.
	var/bounty_modifier = 3

	//Monkestation edit begin
	/**
	  * List of normal (no department ones) accounts' identifiers with associated datum accounts, for big O performance.
	  * A list of sole account datums can be obtained with flatten_list(), another variable would be redundant rn.
	  */
	var/list/bank_accounts_by_id = list()
	/// A var that collects the total amount of credits owned in player accounts on station, reset and recounted on fire()
	var/station_total = 0
	/// A var that tracks how much money is expected to be on station at a given time. If less than station_total prices go up in vendors.
	var/station_target = 1
	/// A passively increasing buffer to help alliviate inflation later into the shift, but to a lesser degree.
	var/station_target_buffer = 0
	/// A var that displays the result of inflation_value for easier debugging and tracking.
	var/inflation_value = 1
	/// How many civilain bounties have been completed so far this shift? Affects civilian budget payout values.
	var/civ_bounty_tracker = 0
	/// Contains the message to send to newscasters about price inflation and earnings, updated on price_update()
	var/earning_report
	///The modifier multiplied to the value of cargo pack prices.
	var/pack_price_modifier = 1
	/// Total value of exported materials.
	var/export_total = 0
	/// Total value of imported goods.
	var/import_total = 0
	//Monkestation edit end

/datum/controller/subsystem/economy/Initialize(timeofday)
	var/budget_to_hand_out = round(budget_pool / department_accounts.len)
	for(var/A in department_accounts)
		new /datum/bank_account/department(A, budget_to_hand_out)
	return ..()

/datum/controller/subsystem/economy/fire(resumed = 0)
	for(var/A in bank_accounts)
		var/datum/bank_account/B = A
		B.payday(1)


/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	for(var/datum/bank_account/department/D in generated_accounts)
		if(D.department_id == dep_id)
			return D

/datum/controller/subsystem/economy/proc/distribute_funds(amount)
	var/datum/bank_account/eng = get_dep_account(ACCOUNT_ENG)
	var/datum/bank_account/sec = get_dep_account(ACCOUNT_SEC)
	var/datum/bank_account/med = get_dep_account(ACCOUNT_MED)
	var/datum/bank_account/srv = get_dep_account(ACCOUNT_SRV)
	var/datum/bank_account/sci = get_dep_account(ACCOUNT_SCI)
	var/datum/bank_account/civ = get_dep_account(ACCOUNT_CIV)
	var/datum/bank_account/car = get_dep_account(ACCOUNT_CAR)

	var/departments = 0

	if(eng)
		departments += 2
	if(sec)
		departments += 2
	if(med)
		departments += 2
	if(srv)
		departments += 1
	if(sci)
		departments += 2
	if(civ)
		departments += 1
	if(car)
		departments += 2

	var/parts = round(amount / departments)

	var/engineering_cash = parts * 2
	var/security_cash = parts * 2
	var/medical_cash = parts * 2
	var/service_cash = parts
	var/science_cash = parts * 2
	var/civilian_cash = parts
	var/cargo_cash = parts * 2

	eng?.adjust_money(engineering_cash)
	sec?.adjust_money(security_cash)
	med?.adjust_money(medical_cash)
	srv?.adjust_money(service_cash)
	sci?.adjust_money(science_cash)
	civ?.adjust_money(civilian_cash)
	car?.adjust_money(cargo_cash)
