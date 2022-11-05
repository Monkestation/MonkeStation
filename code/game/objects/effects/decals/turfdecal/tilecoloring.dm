/obj/effect/turf_decal/tile
	name = "tile decal"
	icon_state = "tile_corner"
	layer = TURF_PLATING_DECAL_LAYER
	alpha = 110

/obj/effect/turf_decal/tile/Initialize(mapload)
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS])
		color = "#[random_short_color()]"
	. = ..()

/obj/effect/turf_decal/tile/blue
	name = "blue corner"
	color = "#52B4E9"

/obj/effect/turf_decal/tile/blue/tile_marquee
	name = "blue marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/blue/tile_side
	name = "blue side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/blue/tile_full
	name = "blue tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/green
	name = "green corner"
	color = "#9FED58"

/obj/effect/turf_decal/tile/green/tile_marquee
	name = "green marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/green/tile_side
	name = "green side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/green/tile_full
	name = "green tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/yellow
	name = "yellow corner"
	color = "#EFB341"

/obj/effect/turf_decal/tile/yellow/tile_marquee
	name = "yellow marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/yellow/tile_side
	name = "yellow side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/yellow/tile_full
	name = "yellow tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/red
	name = "red corner"
	color = "#DE3A3A"

/obj/effect/turf_decal/tile/red/tile_marquee
	name = "red marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/red/tile_side
	name = "red side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/red/tile_full
	name = "red tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/bar
	name = "bar corner"
	color = "#791500"
	alpha = 130

/obj/effect/turf_decal/tile/bar/tile_marquee
	name = "bar marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/bar/tile_side
	name = "bar side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/bar/tile_full
	name = "bar tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/purple
	name = "purple corner"
	color = "#D381C9"

/obj/effect/turf_decal/tile/purple/tile_marquee
	name = "purple marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/purple/tile_side
	name = "purple side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/purple/tile_full
	name = "purple tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/brown
	name = "brown corner"
	color = "#A46106"

/obj/effect/turf_decal/tile/brown/tile_marquee
	name = "brown marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/brown/tile_side
	name = "brown side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/brown/tile_full
	name = "brown tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/darkblue
	name = "dark blue corner"
	color = "#334E6D"

/obj/effect/turf_decal/tile/darkblue/tile_marquee
	name = "dark blue marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/darkblue/tile_side
	name = "dark blue side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/darkblue/tile_full
	name = "dark blue tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/neutral
	name = "neutral corner"
	color = "#D4D4D4"
	alpha = 50

/obj/effect/turf_decal/tile/neutral/tile_marquee
	name = "neutral marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/neutral/tile_side
	name = "neutral side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/neutral/tile_full
	name = "neutral tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/random // so many colors
	name = "colorful corner"
	color = "#E300FF" //bright pink as default for mapping

/obj/effect/turf_decal/tile/random/tile_marquee
	name = "colorful marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/random/tile_side
	name = "colorful side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/random/tile_full
	name = "colorful tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/gray
	name = "gray corner"
	color = "#2E2E2E"

/obj/effect/turf_decal/tile/gray/tile_marquee
	name = "gray marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/gray/tile_side
	name = "gray side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/gray/tile_full
	name = "gray tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/dark_purple
	name = "dark purple corner"
	color = "#6C1282"

/obj/effect/turf_decal/tile/dark_purple/tile_marquee
	name = "dark purple marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/dark_purple/tile_side
	name = "dark purple side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/dark_purple/tile_full
	name = "dark purple tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/dark_red
	name = "dark red corner"
	color = "#4F0000"

/obj/effect/turf_decal/tile/dark_red/tile_marquee
	name = "dark red marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/dark_red/tile_side
	name = "dark red side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/dark_red/tile_full
	name = "dark red tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/orange
	name = "orange corner"
	color = "#D15802"

/obj/effect/turf_decal/tile/orange/tile_marquee
	name = "orange marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/orange/tile_side
	name = "orange side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/orange/tile_full
	name = "orange tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/dark_green
	name = "dark green corner"
	color = "#055205"

/obj/effect/turf_decal/tile/dark_green/tile_marquee
	name = "dark green marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/dark_green/tile_side
	name = "dark green side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/dark_green/tile_full
	name = "dark green tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/piss_yellow
	name = "piss yellow corner"
	color = "#BAC700"

/obj/effect/turf_decal/tile/piss_yellow/tile_marquee
	name = "piss yellow marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/piss_yellow/tile_side
	name = "piss yellow side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/piss_yellow/tile_full
	name = "piss yellow tile"
	icon_state = "tile_full"

/obj/effect/turf_decal/tile/hot_pink
	name = "hot pink corner"
	color = "#ff69b4"

/obj/effect/turf_decal/tile/hot_pink/tile_marquee
	name = "hot pink marquee"
	icon_state = "tile_marquee"

/obj/effect/turf_decal/tile/hot_pink/tile_side
	name = "hot pink side"
	icon_state = "tile_side"

/obj/effect/turf_decal/tile/hot_pink/tile_full
	name = "hot pink tile"
	icon_state = "tile_full"


/obj/effect/turf_decal/tile/random/Initialize(mapload)
	color = "#[random_short_color()]"
	. = ..()

/obj/effect/turf_decal/trimline
	layer = TURF_PLATING_DECAL_LAYER
	alpha = 110
	icon_state = "trimline_box"

/obj/effect/turf_decal/trimline/Initialize(mapload)
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS])
		color = "#[random_short_color()]"
	. = ..()

/obj/effect/turf_decal/trimline/white
	color = "#FFFFFF"

/obj/effect/turf_decal/trimline/white/line
	name = "trim decal"
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/white/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/white/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/white/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/white/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/white/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/white/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/white/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/white/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/white/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/white/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/white/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/white/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/white/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/white/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/red
	color = "#DE3A3A"

/obj/effect/turf_decal/trimline/red/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/red/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/red/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/red/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/red/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/red/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/red/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/red/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/red/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/red/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/red/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/red/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/red/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/red/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/red/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/green
	color = "#9FED58"

/obj/effect/turf_decal/trimline/green/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/green/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/green/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/green/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/green/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/green/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/green/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/green/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/green/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/green/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/green/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/green/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/green/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/green/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/green/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/blue
	color = "#52B4E9"

/obj/effect/turf_decal/trimline/blue/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/blue/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/blue/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/blue/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/blue/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/blue/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/blue/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/blue/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/blue/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/blue/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/blue/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/blue/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/blue/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/blue/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/blue/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/yellow
	color = "#EFB341"

/obj/effect/turf_decal/trimline/yellow/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/yellow/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/yellow/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/yellow/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/yellow/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/yellow/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/yellow/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/yellow/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/yellow/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/yellow/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/yellow/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/yellow/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/yellow/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/yellow/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/yellow/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/purple
	color = "#D381C9"

/obj/effect/turf_decal/trimline/purple/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/purple/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/purple/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/purple/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/purple/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/purple/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/purple/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/purple/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/purple/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/purple/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/purple/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/purple/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/purple/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/purple/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/purple/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/brown
	color = "#A46106"

/obj/effect/turf_decal/trimline/brown/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/brown/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/brown/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/brown/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/brown/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/brown/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/brown/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/brown/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/brown/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/brown/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/brown/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/brown/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/brown/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/brown/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/brown/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/darkblue
	color = "#334E6D"
	alpha = 150

/obj/effect/turf_decal/trimline/darkblue/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/darkblue/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/darkblue/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/darkblue/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/darkblue/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/darkblue/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/darkblue/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/darkblue/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/darkblue/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/neutral
	color = "#D4D4D4"
	alpha = 50

/obj/effect/turf_decal/trimline/neutral/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/neutral/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/neutral/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/neutral/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/neutral/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/neutral/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/neutral/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/neutral/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/neutral/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/neutral/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/neutral/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/neutral/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/neutral/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/neutral/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/neutral/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/gray
	color = "#2E2E2E"

/obj/effect/turf_decal/trimline/gray/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/gray/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/gray/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/gray/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/gray/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/gray/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/gray/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/gray/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/gray/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/gray/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/gray/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/gray/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/gray/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/gray/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/gray/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/dark_purple
	color = "#6C1282"
	alpha = 150

/obj/effect/turf_decal/trimline/dark_purple/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/dark_purple/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/dark_purple/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/dark_purple/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/dark_purple/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/dark_purple/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/dark_purple/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/dark_purple/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/dark_purple/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/dark_red
	color = "#4F0000"
	alpha = 150

/obj/effect/turf_decal/trimline/dark_red/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/dark_red/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/dark_red/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/dark_red/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/dark_red/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/dark_red/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/dark_red/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/dark_red/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/dark_red/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/orange
	color = "#D15802"
	alpha = 150

/obj/effect/turf_decal/trimline/orange/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/orange/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/orange/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/orange/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/orange/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/orange/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/orange/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/orange/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/orange/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/orange/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/orange/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/orange/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/orange/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/orange/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/orange/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/dark_green
	color = "#055205"
	alpha = 150

/obj/effect/turf_decal/trimline/dark_green/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/dark_green/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/dark_green/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/dark_green/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/dark_green/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/dark_green/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/dark_green/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/dark_green/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/dark_green/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/piss_yellow
	color = "#BAC700"
	alpha = 150

/obj/effect/turf_decal/trimline/piss_yellow/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/piss_yellow/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/piss_yellow/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/piss_yellow/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/piss_yellow/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/piss_yellow/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/piss_yellow/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/piss_yellow/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/piss_yellow/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"

/obj/effect/turf_decal/trimline/hot_pink
	color = "#ff69b4"
	alpha = 150

/obj/effect/turf_decal/trimline/hot_pink/line
	icon_state = "trimline"

/obj/effect/turf_decal/trimline/hot_pink/corner
	icon_state = "trimline_corner"

/obj/effect/turf_decal/trimline/hot_pink/end
	icon_state = "trimline_end"

/obj/effect/turf_decal/trimline/hot_pink/arrow_cw
	icon_state = "trimline_arrow_cw"

/obj/effect/turf_decal/trimline/hot_pink/arrow_ccw
	icon_state = "trimline_arrow_ccw"

/obj/effect/turf_decal/trimline/hot_pink/warning
	icon_state = "trimline_warn"

/obj/effect/turf_decal/trimline/hot_pink/filled
	icon_state = "trimline_box_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/line
	icon_state = "trimline_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/corner
	icon_state = "trimline_corner_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/end
	icon_state = "trimline_end_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/arrow_cw
	icon_state = "trimline_arrow_cw_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/arrow_ccw
	icon_state = "trimline_arrow_ccw_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/warning
	icon_state = "trimline_warn_fill"

/obj/effect/turf_decal/trimline/hot_pink/filled/shrink_cw
	icon_state = "trimline_shrink_cw"

/obj/effect/turf_decal/trimline/hot_pink/filled/shrink_ccw
	icon_state = "trimline_shrink_ccw"
