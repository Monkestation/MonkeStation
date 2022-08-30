//Baseline smoke particle edit this for objects that need the smoke
/particles/fire_smoke
    width = 500
    height = 1000
    count = 3000
    spawning = 3
    lifespan = 40
    fade = 40
    velocity = list(0, 2)
    position = list(0, 8)
    gravity = list(0, 1)

    friction = 0.1
    drift = generator("vector", list(-0.16, -0.2), list(0.16, 0.2))
    color = "white"
