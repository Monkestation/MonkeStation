GLOBAL_LIST_EMPTY(soundtrack_datum_list)

SUBSYSTEM_DEF(soundtrack)
	name = "Soundtrack"
	flags = SS_NO_FIRE

/datum/controller/subsystem/soundtrack/Initialize(timeofday)
	var/list/all_tracks = flist("config/jukebox_music/sounds/")

	for(var/current_track in all_tracks)
		var/datum/soundtrack_song/song = new()
		var/list/song_data = splittext(current_track,"+")
		if(song_data.len != 5)
			continue
		song.title = song_data[1]
		song.artist = song_data[2]
		song.album = song_data[3]
		song.length = text2num(song_data[4])
		song.file = file("config/jukebox_music/sounds/[current_track]")
		song.beat = text2num(song_data[5])

		GLOB.soundtrack_datum_list |= song
	return ..()
