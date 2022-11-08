#define AUXMOS (world.system_type == MS_WINDOWS ? "auxtools/auxmos.dll" : __detect_auxmos())

/proc/__detect_auxmos()
	var/static/auxmos_path
	if(!auxmos_path)
		if (fexists("./libauxmos.so"))
			auxmos_path = "./libauxmos.so"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"))
			auxmos_path = "[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"
		else
			CRASH("Could not find libauxmos.so")
	return auxmos_path
