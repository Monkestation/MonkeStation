/obj/item/sealant
	name = "Flexi seal"
	desc = "A neat spray can that can repair torn inflatable segments, and more!"
	icon = 'monkestation/icons/obj/inflatable.dmi'
	icon_state = "sealant"
	w_class = 1

// A temporary manual link until I figure out adding an information database on engine setups for tablets/computers
/datum/config_entry/string/nsv_wikiurl
	config_entry_value = "https://nsv.beestation13.com/wiki/Guide_to_the_Nuclear_Reactor"

/obj/item/book/manual/wiki/rbmk/attack_self(mob/user)
	var/nsv_wikiurl = CONFIG_GET(string/nsv_wikiurl)
	if(!nsv_wikiurl)
		return
	if(alert(user, "This will open the wiki page in your browser. Are you sure?", null, "Yes", "No") != "Yes")
		return
	DIRECT_OUTPUT(user, link("[nsv_wikiurl]"))

/obj/item/book/manual/wiki/rbmk
	name = "\improper Haynes nuclear reactor owner's manual"
	icon_state ="bookEngineering2"
	author = "CogWerk Engineering Reactor Design Department"
	title = "Haynes nuclear reactor owner's manual"
///	page_link = "Guide_to_the_Nuclear_Reactor"  ///Direct linked instead
