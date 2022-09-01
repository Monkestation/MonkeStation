/particles/embers
	color = generator("color", "#FF2200", "#FF9933", UNIFORM_RAND)
	spawning = 0.5
	count = 30
	lifespan = 30
	fade = 5
	position = generator("vector", list(-3,6,0), list(3,6,0), NORMAL_RAND)
	gravity = list(0, 0.2, 0)
	color_change = 0
	friction = 0.2
	drift = generator("vector", list(0.25,0,0), list(-0.25,0,0), UNIFORM_RAND)
#ifndef SPACEMAN_DMM
	fadein = 10
#endif




///GENERIC FIRE EFEFCT
/particles/fire
    width = 500
    height = 500
    count = 3000
    spawning = 3
    lifespan = 10
    fade = 10
    velocity = list(0, 0)
    position = generator("vector", list(-9,3,0), list(9,3,0), NORMAL_RAND)
    drift = generator("vector", list(0, -0.2), list(0, 0.2))
    gravity = list(0, 0.65)
    color = "white"

/particles/fire_sparks
    width = 500
    height = 500
    count = 3000
    spawning = 1
    lifespan = 40
    fade = 20
    position = 0
    gravity = list(0, 1)

    friction = 0.25
    drift = generator("sphere", 0, 2)
    gradient = list(0, "yellow", 1, "red")
    color = "yellow"


/particles/flare_sparks
	width = 500
	height = 500
	count = 2000
	spawning = 12
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("vector", list(10,0,0), list(10,0,0), NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.4, COLOR_RED)
	color_change = 0.125
