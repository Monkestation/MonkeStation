//Baseline smoke particle edit this for objects that need the smoke
/particles/fire_smoke
    width = 500
    height = 1000
    count = 3000
    spawning = 3
    lifespan = 20
    fade = 20
	fadein = 10
    velocity = list(0, 2)
    position = list(0, 8)
    gravity = list(0, 1)

	icon = 'icons/effects/particles/particle.dmi'
	icon_state = "smoke_3"

	position = generator("vector", list(-12,10,0), list(12,10,0))
	grow = list(0.2, 0.2)

    friction = 0.1
    drift = generator("vector", list(-0.16, -0.2), list(0.16, 0.2))
    color = "white"
