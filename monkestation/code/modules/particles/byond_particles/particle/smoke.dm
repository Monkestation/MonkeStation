//Baseline smoke particle edit this for objects that need the smoke
/particles/fire_smoke
    width = 500
    height = 500
    count = 3000
    spawning = 3
    bound1 = list(-1000,0,-1000)
    bound2 = list(1000,75,1000)
    lifespan = 20
    fade = 30
    #ifndef SPACEMAN_DMM // Waiting on next release of DreamChecker
    fadein = 5
    #endif
    velocity = list(0, 2)
    position = list(0, 8)
    gravity = list(0, 1)
    icon = 'icons/effects/particles/smoke.dmi'
    icon_state = "smoke_3"
    position = generator("vector", list(-12,8,0), list(12,8,0))
    grow = list(0.3, 0.3)
    friction = 0.2
    drift = generator("vector", list(-0.16, -0.2), list(0.16, 0.2))
    color = "white"
