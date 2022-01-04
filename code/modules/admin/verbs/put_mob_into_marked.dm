/client/proc/put_mob_into_marked(mob/target_mob in GLOB.mob_list)
	set category = "Fun"
	set desc = "(atom path) Puts a mob into the currently marked obj"
	set name = "Put Mob Into Marked"


	if(!check_rights(R_ADMIN))
		return
	if(!holder)
		return
	var/obj/t = holder.marked_datum

	if(!t)
		return alert(usr, "You need to mark an object first!", null, null, null, null)
	if(!t.loc)
		return alert(usr, "The object you marked ([t]) doesn't have a location!", null, null, null, null)

	t.contents += target_mob
	t.vis_contents += target_mob

	var/obj/cur = t
	while(!isturf(cur))
		cur.important_recursive_contents += list("recursive_contents_hearing_sensitive" = list(target_mob))
		cur = cur.loc

	log_admin("[key_name(usr)] put [target_mob] into [t]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Put Mob Into Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
