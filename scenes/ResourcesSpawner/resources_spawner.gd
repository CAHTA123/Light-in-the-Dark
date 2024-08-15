extends Node2D

@onready var timer = $Timer

var res_tscn = "res://scenes/Entities/Res/res.tscn"

var islands_resources = []

func _ready():
	timer.start()
	
	# Подготовка структуры с ресурсами для каждого острова, она будет использоваться для
	# отслеживания текущих состояний кулдауна у каждого ресурса.
	for island in Global.islands:
		for resource_id in island.resources:
			var resource = Global.get_resource(resource_id)
			var spawn_cooldown = resource.spawn_cooldown
			var dict = {
				"island_id": island.id,
				"resource": resource,
				"spawn_cooldown": spawn_cooldown
			}
			islands_resources.append(dict)


func _on_timer_timeout():
	for island in Global.islands:
		_spawn_resources(island)


func _spawn_resources(island):
	# Для острова получить тайлмап, и далее работать с ним для спавна
	var path = island.path + "/TileMap"
	var tile_map: TileMap = get_node(path)
	if not tile_map:
		print("[spawner error] can't get node with path: ", path)
		return
	
	# Получить список доступных ресурсов текущего острова, уменьшить кулдаун на единичку,
	# отобрать те ресурсы, которые готовы к спавну
	var spawned_resources = []
	for islands_resource in islands_resources:
		if islands_resource.island_id != island.id:
			continue
		islands_resource.spawn_cooldown -= 1
		if islands_resource.spawn_cooldown <= 0:
			spawned_resources.append(islands_resource.resource)
			islands_resource.spawn_cooldown = islands_resource.resource.spawn_cooldown
	
	if spawned_resources.is_empty():
		return

	# Выбрать один ресурс для спавна если кулдауны сработали у нескольких сразу
	var index = randi_range(0, spawned_resources.size() - 1)
	var spawned_resource = spawned_resources[index]
	#print("Spawn: ", spawned_resource.name)

	# Получить свободные тайлы, если такие есть, выбрать рандомно один из них,
	# получить его координаты на сетке, выбранный тайл заместить на занятый
	var free_tiles = tile_map.get_used_cells_by_id(0, 4)
	if free_tiles.size() <= 0:
		return
	var random_tile = randi_range(0, free_tiles.size() - 1)
	var tile_coord = free_tiles[random_tile]
	tile_map.set_cell(0, tile_coord, 3)
	#print("\t", island.id, ": ", tile_coord, "total ", free_tiles.size())
	
	# Создать сцену с ресурсом, выставить z-ордер, задать текстуру, скалировать, 
	# спрятать полоску здоровья, рандомизировать позицию, слегка сместив от центра
	var res = load(res_tscn).instantiate()
	res.z_index = tile_coord.y + 100
	if spawned_resource.stages.size() == 0:
		print("[spawner error] resource ", spawned_resource.id, " doesn't have any stage")
		return
	var stage1 = spawned_resource.stages[0]
	res.get_node("Skin/Skin").texture = load(stage1.texture_path)
	res.scale = Vector2(stage1.texture_scale, stage1.texture_scale)
	res.get_node("hp_bar").visible = false
	res.position = tile_map.map_to_local(tile_coord) + tile_map.get_parent().position
	res.position.x += randf_range(-100, 100)
	res.position.y += randf_range(-50, 50)
	get_parent().add_child(res)
