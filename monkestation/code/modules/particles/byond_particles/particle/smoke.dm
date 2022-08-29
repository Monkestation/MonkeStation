//Baseline smoke particle edit this for objects that need the smoke

/particles/smoke
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = "smoke_3"
	color = "#2222225A"
	height = 200
	spawning = 1
	count = 30
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	position = generator("vector", list(-3,6,0), list(3,6,0), NORMAL_RAND)
	gravity = list(0, 0.3, 0)
	scale = generator("num", 0.1, 0.1, UNIFORM_RAND)
	rotation = generator("num", -90, 90, NORMAL_RAND)
	spin = generator("num", -5, 5, UNIFORM_RAND)
	grow = generator("num", 0.1, 0.1, UNIFORM_RAND)
	fadein = 0.2 SECONDS
