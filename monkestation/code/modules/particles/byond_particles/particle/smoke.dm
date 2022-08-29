//Baseline smoke particle edit this for objects that need the smoke

/particles/smoke
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("smoke_3")
	color = "#2222225A"
	height = 200
	spawning = 0.08
	count = 3
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	position = generator("vector", list(-2,8,0), list(2,8,0), NORMAL_RAND)
	gravity = list(0, 0.3, 0)
	scale = list(0.1, 0.1)
	rotation = generator("num", -90, 90, NORMAL_RAND)
	spin = generator("num", -5, 5, UNIFORM_RAND)
	grow = list(0.05, 0.05)
	fadein = 0.2 SECONDS
