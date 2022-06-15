#define SMALL_FAIL_CHANCE 5
#define MEDIUM_FAIL_CHANCE 9.5
#define LARGE_FAIL_CHANCE 12.5

#define MEDIUM_INCREASE 2
#define LARGE_INCREASE 3

#define WORKPIECE_PRESENT 1
#define WORKPIECE_INPROGRESS 2
#define WORKPIECE_FINISHED 3
#define WORKPIECE_SLAG 5

#define RECIPE_SMALLPICK "dbp" //draw bend punch
#define RECIPE_LARGEPICK "ddbp" //draw draw bend punch
#define RECIPE_SHOVEL "dfup" //draw fold upset punch
#define RECIPE_HAMMER "sfp" //shrink fold punch


#define RECIPE_SMALLKNIFE "sdd" //shrink draw draw
#define RECIPE_SHORTSWORD "dff" //draw fold fold
#define RECIPE_WAKI "dfsf" //draw  fold shrink fold
#define RECIPE_SCIMITAR "dfb" //draw fold bend
#define RECIPE_SABRE "ddsf" //draw draw shrink fold
#define RECIPE_RAPIER "sdfd" //shrink draw  fold draw
#define RECIPE_BROADSWORD "dfuf" //draw fold upset fold
#define RECIPE_ZWEIHANDER "udfsf" //upset draw fold shrink fold
#define RECIPE_KATANA "fffff" //fold fold fold fold fold


#define RECIPE_SCYTHE "bdf" //bend draw fold
#define RECIPE_COGHEAD "bsf" //bend shrink fold.


#define RECIPE_JAVELIN "dbf" //draw bend fold
#define RECIPE_HALBERD "duffp" //draw upset fold fold punch
#define RECIPE_GLAIVE "usfp" //upset shrink fold punch
#define RECIPE_PIKE "ddbf" //draw draw bend fold

#define RECIPE_ANVILPLATE "ddpdf" //draw draw punch draw fold

/obj/structure/anvil
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	var/workpiece_state = FALSE //the current state of working if there is an ingot on it will be true
	var/datum/material/workpiece_material //The current material that is being worked on
	var/anvilquality = 0 //quality of the anvil, helps determine the end products quality
	var/currentquality = 0 //current quality of the workpiece at any given time
	var/currentsteps = 0 //how many steps have been done to this workpiece used for fail chance and checking recipes
	var/outrightfailchance = 1 //the chance this just fails regardless
	var/stepsdone = "" //the string of steps done to the workpiece used to match recipes
	var/rng = FALSE //if fail chance should be rolled defaulted to on with obtainable anvils
	var/debug = FALSE //vv this if you want an artifact, skips the artifact roll phase
	var/artifactrolled = FALSE //if the workpiece rolled as an artifact
	var/itemqualitymax = 100 //the max quality of any given item produced on an anvil
	var/list/smithrecipes = list(RECIPE_HAMMER = /obj/item/smithing/hammerhead,
	RECIPE_SCYTHE = /obj/item/smithing/scytheblade,
	RECIPE_SHOVEL = /obj/item/smithing/shovelhead,
	RECIPE_COGHEAD = /obj/item/smithing/cogheadclubhead,
	RECIPE_JAVELIN = /obj/item/smithing/javelinhead,
	RECIPE_LARGEPICK = /obj/item/smithing/pickaxehead,
	RECIPE_SMALLPICK = /obj/item/smithing/prospectingpickhead,
	RECIPE_SHORTSWORD = /obj/item/smithing/shortswordblade,
	RECIPE_SCIMITAR = /obj/item/smithing/scimitarblade,
	RECIPE_WAKI = /obj/item/smithing/wakiblade,
	RECIPE_RAPIER = /obj/item/smithing/rapierblade,
	RECIPE_SABRE = /obj/item/smithing/sabreblade,
	RECIPE_SMALLKNIFE = /obj/item/smithing/knifeblade,
	RECIPE_BROADSWORD = /obj/item/smithing/broadblade,
	RECIPE_ZWEIHANDER = /obj/item/smithing/zweiblade,
	RECIPE_KATANA = /obj/item/smithing/katanablade,
	RECIPE_HALBERD = /obj/item/smithing/halberdhead,
	RECIPE_GLAIVE = /obj/item/smithing/glaivehead,
	RECIPE_PIKE = /obj/item/smithing/pikehead,
	RECIPE_ANVILPLATE = /obj/item/smithing/anvilplate)

/obj/structure/anvil/Initialize()
	..()
	currentquality = anvilquality

/obj/structure/anvil/attackby(obj/item/Item, mob/user)
	if(istype(Item, /obj/item/smithing/anvilplate))
		var/obj/item/smithing/update = Item
		var/update_quality = (update.quality * update.blunt_mult) / 20
		anvilquality += update_quality
		itemqualitymax += update_quality
		to_chat(user, "You apply the anvil plate to the anvil increasing its quality by: [update_quality], the current anvil quality is: [anvilquality]")
		qdel(update)
	if(istype(Item, /obj/item/ingot))
		var/obj/item/ingot/working_ingot = Item
		if(workpiece_state)
			to_chat(user, "There's already a workpiece! Finish it or take it off.")
			return FALSE
		if(working_ingot.workability == TRUE)
			workpiece_state = WORKPIECE_PRESENT
			workpiece_material = working_ingot.custom_materials
			to_chat(user, "You place the [working_ingot] on the [src].")
			currentquality = anvilquality
			qdel(working_ingot)
			return
		to_chat(user, "The ingot isn't workable yet!")
		return FALSE

	else if(istype(Item, /obj/item/melee/smith/hammer))
		var/obj/item/melee/smith/hammer/used_hammer = Item
		if(workpiece_state == WORKPIECE_PRESENT || workpiece_state == WORKPIECE_INPROGRESS)
			do_shaping(user, used_hammer.qualitymod)
			return
		to_chat(user, "You can't work an empty anvil!")
		return FALSE
	return ..()

/obj/structure/anvil/wrench_act(mob/living/user, obj/item/Item)
	..()
	default_unfasten_wrench(user, Item, 5)
	return TRUE

/obj/structure/anvil/examine(mob/user)
	. = ..()
	. += "The quality of this anvil is [anvilquality]"

/obj/structure/anvil/proc/do_shaping(mob/user, var/qualitychange)
	currentquality += qualitychange
	///weak/strong/heavy hit affect strength. All the other steps shape.
	var/list/shapingsteps = list("weak hit", "strong hit", "heavy hit", "fold", "draw", "shrink", "bend", "punch", "upset")
	workpiece_state = WORKPIECE_INPROGRESS
	///What step you are choosing
	var/stepdone = input(user, "How would you like to work the metal?") in shapingsteps
	//The duration in deciseconds it takes
	var/steptime = 50
	playsound(src, 'sound/effects/clang.ogg',40, 2)
	if(!do_after(user, steptime, target = src))
		return FALSE
	switch(stepdone)
		if("weak hit")
			currentsteps ++
			outrightfailchance += SMALL_FAIL_CHANCE
			currentquality ++
		if("strong hit")
			currentsteps += MEDIUM_INCREASE
			outrightfailchance += MEDIUM_FAIL_CHANCE
			currentquality += MEDIUM_INCREASE
		if("heavy hit")
			currentsteps += LARGE_INCREASE
			outrightfailchance += LARGE_FAIL_CHANCE
			currentquality += LARGE_INCREASE
		if("fold")
			stepsdone += "f"
			currentsteps ++
			currentquality --
		if("draw")
			stepsdone += "d"
			currentsteps ++
			currentquality --
		if("shrink")
			stepsdone += "s"
			currentsteps ++
			currentquality --
		if("bend")
			stepsdone += "b"
			currentsteps ++
			currentquality --
		if("punch")
			stepsdone += "p"
			currentsteps ++
			currentquality --
		if("upset")
			stepsdone += "u"
			currentsteps ++
			currentquality --
	user.visible_message("<span class='notice'>[user] works the metal on the anvil with their hammer with a loud clang!</span>", \
						"<span class='notice'>You [stepdone] the metal with a loud clang!</span>")
	playsound(src, 'sound/effects/clang.ogg',40, 2)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, 'sound/effects/clang.ogg', 40, 2), 15)
	if(length(stepsdone) >= 3)
		tryfinish(user)

/obj/structure/anvil/proc/tryfinish(mob/user)
	///The chance this ends up as a an artifact
	var/artifactchance = 0
	if(!artifactrolled)
		artifactchance = (1+ rand(1, 25) / 2500)
		artifactrolled = TRUE
	///if the item is an artifact
	var/artifact = debug ? TRUE : prob(artifactchance)
	///fail chance after everything is done
	var/finalfailchance = (outrightfailchance * workpiece_material[1].fail_multipler)
	finalfailchance = max(0, finalfailchance / (1 + anvilquality)) //lv 2 gives 20% less to fail, 3 30%, etc
	if((currentsteps > 10 || (rng && prob(finalfailchance))) && !artifact)
		to_chat(user, "<span class='warning'?You overwork the metal, causing it to turn into useless slag!</span>")
		var/turf/user_location = get_turf(user)
		workpiece_state = FALSE
		new /obj/item/stack/ore/slag(user_location)
		currentquality = anvilquality
		stepsdone = ""
		currentsteps = 0
		outrightfailchance = 1
		artifactrolled = FALSE
	for(var/recipe in smithrecipes)
		if(recipe == stepsdone)
			///the location of the user used to drop the smithed item
			var/turf/user_location = get_turf(user)
			///checking if an item can be created
			var/obj/item/smithing/create = smithrecipes[stepsdone]
			///the finished item that was created
			var/obj/item/smithing/finisheditem = new create(user_location)
			to_chat(user, "You finish your [finisheditem]!")
			if(artifact)
				to_chat(user, "It is an artifact, a creation whose legacy shall live on forevermore.") //todo: SSblackbox
				currentquality = max(currentquality, 2)
				finisheditem.quality = currentquality * 3//this is insane i know it's 1/2500 for most of the time and 0.8% at best
				finisheditem.artifact = TRUE
			else
				finisheditem.quality = min(currentquality, itemqualitymax)
			switch(finisheditem.quality)
				if(-1000 to -7)
					finisheditem.desc =  "It looks to be the most awfully made object you've ever seen."
				if(-8)
					finisheditem.desc =  "It looks to be the second most awfully made object you've ever seen."
				if(-8 to 0)
					finisheditem.desc =  "It looks to be barely passable as... whatever it's trying to pass for."
				if(0)
					finisheditem.desc =  "It looks to be totally average."
				if(0 to INFINITY)
					finisheditem.desc =  "It looks to be better than average."
			workpiece_state = FALSE
			finisheditem.set_custom_materials(workpiece_material)
			finisheditem.set_smithing_vars(workpiece_material)
			currentquality = anvilquality
			stepsdone = ""
			currentsteps = 0
			outrightfailchance = 1
			artifactrolled = FALSE
			break

/obj/structure/anvil/debugsuper
	name = "super ultra epic anvil of debugging."
	desc = "WOW. A DEBUG <del>ITEM</DEL> STRUCTURE. EPIC."
	icon_state = "anvil"
	anvilquality = 10
	itemqualitymax = 9001
	outrightfailchance = 0

/obj/structure/anvil/obtainable
	name = "anvil"
	desc = "Base class of anvil. This shouldn't exist, but is useable."
	anvilquality = 0
	outrightfailchance = 5
	itemqualitymax = 5
	rng = TRUE

/obj/structure/anvil/obtainable/table
	name = "table anvil"
	desc = "A slightly reinforced table. Good luck."
	icon_state = "tablevil"
	anvilquality = -2
	itemqualitymax = 0

/obj/structure/anvil/obtainable/table/do_shaping(mob/user, var/qualitychange)
	if(prob(5))
		to_chat(user, "The [src] breaks under the strain!")
		take_damage(max_integrity)
		return FALSE
	else
		..()

/obj/structure/anvil/obtainable/bronze
	name = "slab of bronze"
	desc = "A big block of bronze. Useable as an anvil."
	custom_materials = list(/datum/material/bronze=8000)
	icon_state = "ratvaranvil"
	anvilquality = -0.5
	obj_integrity = 300
	itemqualitymax = 10


/obj/structure/anvil/obtainable/sandstone
	name = "sandstone brick anvil"
	desc = "A big block of sandstone. Useable as an anvil."
	custom_materials = list(/obj/item/stack/sheet/mineral/sandstone=8000)
	icon_state = "sandvil"
	anvilquality = -1
	itemqualitymax = 3


/obj/structure/anvil/obtainable/basalt
	name = "basalt brick anvil"
	desc = "A big block of basalt. Useable as an anvil, better than sandstone. Igneous!"
	icon_state = "sandvilnoir"
	anvilquality = -0.5
	itemqualitymax = 3


/obj/structure/anvil/obtainable/basic
	name = "anvil"
	desc = "An anvil. It's got wheels bolted to the bottom."
	anvilquality = 0

/obj/structure/anvil/obtainable/ratvar
	name = "brass anvil"
	desc = "A big block of what appears to be brass. Useable as an anvil, if whatever's holding the brass together lets you."
	custom_materials = list(/datum/material/bronze=8000)
	icon_state = "ratvaranvil"
	anvilquality = 1
	max_integrity = 500
	obj_integrity = 500
	itemqualitymax = 10

/obj/structure/anvil/obtainable/ratvar/attackby(obj/item/Item, mob/user)
	if(istype(Item, /obj/item/melee/smith/hammer))
		if(is_servant_of_ratvar(user))
			return ..()
		else
			to_chat(user, "<span class='neovgre'>KNPXWN, QNJCQNW!</span>") //rot13 then rot22 if anyone wants to decode

/obj/structure/anvil/obtainable/narsie
	name = "runic anvil"
	desc = "An anvil made of a strange, runic metal."
	custom_materials = list(/datum/material/runedmetal=8000)
	icon = 'monkestation/icons/obj/smith.dmi'
	icon_state = "evil"
	anvilquality = 1
	max_integrity = 500
	obj_integrity = 500
	itemqualitymax = 10

/obj/structure/anvil/obtainable/narsie/attackby(obj/item/Item, mob/user)
	if(istype(Item, /obj/item/melee/smith/hammer))
		if(iscultist(user))
			return ..()
		else
			to_chat(user, "<span class='narsiesmall'>That is not yours to use!</span>")

#undef WORKPIECE_PRESENT
#undef WORKPIECE_INPROGRESS
#undef WORKPIECE_FINISHED
#undef WORKPIECE_SLAG
