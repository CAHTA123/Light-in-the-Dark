extends Node

var player_pos = Vector2.ZERO
var gold : int

enum ResourcesId {
	TREE,
	ROCK,
}

var resources = [
	{
		"id": ResourcesId.TREE,
		"name": "Дерево",
		"health": 100.0,
		"stages": [
			{ 
				"texture_path": "res://scenes/ResourcesSpawner/assets/tree1.png", 
				"texture_scale": 10.0,
				"stage_cooldown": 10.0 
			},
		],
		"spawn_cooldown": 1
	},
	{
		"id": ResourcesId.ROCK,
		"name": "Камень",
		"health": 100.0,
		"stages": [
			{ 
				"texture_path": "res://scenes/ResourcesSpawner/assets/rock1.png", 
				"texture_scale": 10.0,
				"stage_cooldown": 0.0 
			},
		],
		"spawn_cooldown": 2
	},
]


func get_resource(id: ResourcesId) -> Dictionary:
	for resource in resources:
		if resource.id == id:
			return resource
	return {}
	
	
enum IslandsId {
	ISLAND1,
	ISLAND2,
	ISLAND3,
	ISLAND4,
	ISLAND5,
	ISLAND6,
	ISLAND7,
	ISLAND8,
	ISLAND9,
}
	
var islands = [
	{
		"id": IslandsId.ISLAND1,
		"path": "/root/Game/Islands/Island1",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND2,
		"path": "/root/Game/Islands/Island2",
		"resources": [
			ResourcesId.TREE, 
		]
	},
	{
		"id": IslandsId.ISLAND3,
		"path": "/root/Game/Islands/Island3",
		"resources": [
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND4,
		"path": "/root/Game/Islands/Island4",
		"resources": [
		]
	},
	{
		"id": IslandsId.ISLAND5,
		"path": "/root/Game/Islands/Island5",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND6,
		"path": "/root/Game/Islands/Island6",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND7,
		"path": "/root/Game/Islands/Island7",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND8,
		"path": "/root/Game/Islands/Island8",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
	{
		"id": IslandsId.ISLAND9,
		"path": "/root/Game/Islands/Island9",
		"resources": [
			ResourcesId.TREE, 
			ResourcesId.ROCK,
		]
	},
]


func get_island(id: IslandsId) -> Dictionary:
	for island in islands:
		if island.id == id:
			return island
	return {}
