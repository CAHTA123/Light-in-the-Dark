extends Node

@export var enabled: bool = true
@export var cooldown: float = 1
@onready var timer = $Timer

var ISLANDS = []
var islands_resources = []

const DIR = "res://data/islands/"

func _ready():
	# Загружаем из папки все TRES
	for file in DirAccess.get_files_at(DIR):
		ISLANDS.append(load(DIR.path_join(file)))
	if enabled:
		timer.wait_time = cooldown
		timer.start()
	
	# Подготовка структуры с ресурсами для каждого острова, она будет использоваться для
	# отслеживания текущих состояний кулдауна у каждого ресурса.
	for island in ISLANDS:
		for grow in island.grows:
			var dict = {
				"island": island,
				"grow": grow,
				"spawn_cooldown": grow.spawn_cooldown
			}
			islands_resources.append(dict)

func _on_timer_timeout():
	for island in ISLANDS:
		_spawn_resources(island)

func _spawn_resources(island):
	# Для острова получить тайлмап, и далее работать с ним для спавна
	var path = island.node_path + "/TileMap"
	var tile_map: TileMap = get_node(path)
	if not tile_map:
		print("[spawner error] can't get node with path: ", path)
		return
	
	# Получить список доступных ресурсов текущего острова, уменьшить кулдаун на единичку,
	# отобрать те ресурсы, которые готовы к спавну
	var spawned_grows = []
	for islands_resource in islands_resources:
		if islands_resource.island != island:
			continue
		islands_resource.spawn_cooldown -= 1
		if islands_resource.spawn_cooldown <= 0:
			spawned_grows.append(islands_resource.grow)
			islands_resource.spawn_cooldown = islands_resource.grow.spawn_cooldown

	if spawned_grows.is_empty():
		return

	# Выбрать один ресурс для спавна если кулдауны сработали у нескольких сразу
	var index = randi_range(0, spawned_grows.size() - 1)
	var spawned_grow = spawned_grows[index]
	#print("Spawn: ", spawned_grow.name)
	
	# Получить свободные тайлы, если такие есть, выбрать рандомно один из них,
	# получить его координаты на сетке, выбранный тайл заместить на занятый
	var free_tiles = tile_map.get_used_cells_by_id(0, 4)
	if free_tiles.size() <= 0:
		return
	var random_tile = randi_range(0, free_tiles.size() - 1)
	var tile_coord = free_tiles[random_tile]
	tile_map.set_cell(0, tile_coord, 3)
	#print("\t", island.name, ": ", tile_coord, "total ", free_tiles.size())
	
	# Создать сцену с ресурсом, выставить z-ордер, задать текстуру, скалировать, 
	# спрятать полоску здоровья, рандомизировать позицию, слегка сместив от центра
	var grow = spawned_grow.scene.instantiate()
	grow.texture = spawned_grow.texture
	grow.z_index = tile_coord.y + 100
	grow.position = tile_map.map_to_local(tile_coord) + tile_map.get_parent().position
	grow.position.x += randf_range(-100, 100)
	grow.position.y += randf_range(-50, 50)
	get_parent().add_child(grow)
