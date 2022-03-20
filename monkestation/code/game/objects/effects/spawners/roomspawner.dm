///RandomEngines - BoxStation Area Spawner
///Controls the engine spawn chance, default is 40% for Particle and 60% for SM
/obj/effect/spawner/room/engine/box
	name = "box engine spawner"
	room_width = 27
	room_height = 21
	loot = list(
				monkestation\_maps\RandomEngines\BoxStation\particle_accelerator.dmm = 40,
				monkestation\_maps\RandomEngines\BoxStation\supermatter.dmm = 60
				)
	lootcount = 1

///RandomEngines - MetaStation Area Spawner
///Controls the engine spawn chance, default is 40% for Particle and 60% for SM
/obj/effect/spawner/room/engine/meta
	name = "meta engine spawner"
	room_width = 25
	room_height = 24
	loot = list(
				monkestation\_maps\RandomEngines\MetaStation\particle_accelerator.dmm = 40,
				monkestation\_maps\RandomEngines\MetaStation\supermatter.dmm = 60
				)
	lootcount = 1
