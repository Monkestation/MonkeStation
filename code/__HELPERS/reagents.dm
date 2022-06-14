/proc/reagent_paths_list_to_text(list/reagents, addendum)
	var/list/temp = list()
	for(var/datum/reagent/R as anything in reagents)
		temp |= initial(R.name)
	if(addendum)
		temp += addendum
	return jointext(temp, ", ")

// Returns the name of the mathematical tuple of same length as the number arg (rounded down).
/proc/make_tuple(number)
	var/static/list/units_prefix = list("", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem")
	var/static/list/tens_prefix = list("", "decem", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nongen")
	var/static/list/one_to_nine = list("monuple", "double", "triple", "quadruple", "quintuple", "sextuple", "septuple", "octuple", "nonuple")
	number = round(number)
	switch(number)
		if(0)
			return "empty tuple"
		if(1 to 9)
			return one_to_nine[number]
		if(10 to 19)
			return "[units_prefix[(number%10)+1]]decuple"
		if(20 to 99)
			return "[units_prefix[(number%10)+1]][tens_prefix[round((number % 100)/10)+1]]tuple"
		if(100)
			return "centuple"
		else //It gets too tedious to use latin prefixes from here.
			return "[number]-tuple"

