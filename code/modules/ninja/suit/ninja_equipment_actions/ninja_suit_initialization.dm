#define NINJA_LOCK_PHASE 1
#define NINJA_COLOR_CHOICE 3
#define NINJA_COMPLETE_PHASE 6
#define NINJA_DEINIT_LOGOFF_PHASE 1
#define NINJA_DEINIT_STEALTH_PHASE 5

#define NINJA_INITIALIZE_MESSAGES list("Now initializing...","Securing external locking mechanism...\nNeural-net established.","Extending neural-net interface...\nNow monitoring brain wave pattern...","Linking neural-net interface...\nPattern <b class='nicegreen'>GREEN</b>, continuing operation.","VOID-shift device status: <B>ONLINE</B>.\nCLOAK-tech device status: <B>ONLINE</B>.","Primary system status: <B>ONLINE</B>.\nBackup system status: <B>ONLINE</B>.\nCurrent energy capacity: ","All systems operational. Welcome to <B>SpiderOS</B>")
#define NINJA_DEINITALIZE_MESSAGES list("Now de-initializing...","Shutting down <B>SpiderOS</B>.","Primary system status: <B>OFFLINE</B>.\nBackup system status: <B>OFFLINE</B>.","VOID-shift device status: <B>OFFLINE</B>.\nCLOAK-tech device status: <B>OFFLINE</B>.","Disconnecting neural-net interface...<b class='nicegreen'>Success</b>.","Disengaging neural-net interface... <b class='nicegreen'>Success</b>.","Unsecuring external locking mechanism...\nNeural-net abolished.\nOperation status: <B>FINISHED</B>.")

/datum/action/item_action/initialize_ninja_suit
	name = "Toggle Ninja Suit"

/**
  * Toggles the ninja suit on/off
  *
  * Attempts to initialize or deinitialize the ninja suit
  */
/obj/item/clothing/suit/space/space_ninja/proc/toggle_on_off()
	. = TRUE
	if(suit_currently_busy)
		to_chat(loc, "<span class='warning'>ERROR</span>: You cannot use this function at this time.")
		return FALSE
	suit_currently_busy = TRUE
	if(suit_initialized)
		deinitialize()
	else
		ninja_initialize()
/**
  * Initializes the ninja suit
  *
  * Initializes the ninja suit through seven phases, each of which calls this proc with an incremented phase
  * Arguments:
  * * delay - The delay between each phase of initialization
  * * ninja - The human who is being affected by the suit
  * * phase - The phase of initialization
  */
/obj/item/clothing/suit/space/space_ninja/proc/ninja_initialize(delay = suit_action_delay, mob/living/carbon/human/ninja = loc, phase = 0)
	if(!ninja || !ninja.mind)
		suit_currently_busy = FALSE
		return
	if (phase > NINJA_LOCK_PHASE && (ninja.stat == DEAD || ninja.health <= 0))
		to_chat(ninja, "<span class='danger'><B>FÄAL ï¿½Rrï¿½R</B>: 344--93#ï¿½&&21 BRï¿½ï¿½N |/|/aVï¿½ PATT$RN <B>RED</B>\nA-A-aBï¿½rTï¿½NG...</span>")
		unlock_suit(ninja)
		suit_currently_busy = FALSE
		return

	var/message = NINJA_INITIALIZE_MESSAGES[phase + 1]
	switch(phase)
		if (NINJA_LOCK_PHASE)
			if(!lock_suit(ninja))//To lock the suit onto wearer.
				suit_currently_busy = FALSE
				return
		if (NINJA_COLOR_CHOICE)
			choose_suit_color(ninja)//Customize suit color
		if (NINJA_COMPLETE_PHASE - 1)
			message += "<B>[display_energy(cell.charge)]</B>."
		if (NINJA_COMPLETE_PHASE)
			message += "[ninja.real_name]."
			suit_initialized = TRUE
			suit_currently_busy = FALSE
			START_PROCESSING(SSobj, src)

	to_chat(ninja, "<span class='notice'>[message]</span>")
	playsound(ninja, 'sound/effects/sparks1.ogg', 10, TRUE)

	if (phase < NINJA_COMPLETE_PHASE)
		addtimer(CALLBACK(src, .proc/ninja_initialize, delay, ninja, phase + 1), delay)

/**
  * Deinitializes the ninja suit
  *
  * Deinitializes the ninja suit through eight phases, each of which calls this proc with an incremented phase
  * Arguments:
  * * delay - The delay between each phase of deinitialization
  * * ninja - The human who is being affected by the suit
  * * phase - The phase of deinitialization
  */
/obj/item/clothing/suit/space/space_ninja/proc/deinitialize(delay = suit_action_delay, mob/living/carbon/human/ninja = affecting == loc ? affecting : null, phase = 0)
	if (!ninja || !ninja.mind)
		suit_currently_busy = FALSE
		return
	if (phase == 0 && alert("Are you certain you wish to remove the suit? This will take time and remove all abilities.",,"Yes","No") == "No")
		suit_currently_busy = FALSE
		return
	var/message = NINJA_DEINITALIZE_MESSAGES[phase + 1]
	switch(phase)
		if(NINJA_DEINIT_LOGOFF_PHASE)
			message = "Logging off, [ninja.real_name]. " + message
		if(NINJA_DEINIT_STEALTH_PHASE)
			cancel_stealth()
			suit_color = "#000000"
			update_suit_color()
			ninja.regenerate_icons()
	to_chat(ninja, "<span class='notice'>[message]</span>")
	playsound(ninja, 'sound/items/deconstruct.ogg', 10, TRUE)

	if (phase < NINJA_COMPLETE_PHASE)
		addtimer(CALLBACK(src, .proc/deinitialize, delay, ninja, phase + 1), delay)
	else
		unlock_suit(ninja)
		ninja.regenerate_icons()
		suit_initialized = FALSE
		suit_currently_busy = FALSE
		STOP_PROCESSING(SSobj, src)
