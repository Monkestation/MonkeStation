GLOBAL_LIST_EMPTY(objective_computers)

/obj/machinery/computer/objective/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	GLOB.objective_computers += src

/obj/machinery/computer/objective/Destroy()
	GLOB.objective_computers -= src
	. = ..()

/obj/machinery/computer/objective/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/objective/ui_static_data(mob/user)
	var/list/data = list()
	data["possible_objectives"] = list()
	for(var/datum/orbital_objective/objective in SSorbits.possible_objectives)
		data["possible_objectives"] += list(list(
			"name" = objective.name,
			"id" = objective.id,
			"payout" = objective.payout,
			"description" = objective.get_text()
		))
	data["selected_objective"] = null
	if(SSorbits.current_objective)
		data["selected_objective"] = list(
			"name" = SSorbits.current_objective.name,
			"id" = SSorbits.current_objective.id,
			"payout" = SSorbits.current_objective.payout,
			"description" = SSorbits.current_objective.get_text()
		)
	return data

/obj/machinery/computer/objective/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action != "assign")
		return
