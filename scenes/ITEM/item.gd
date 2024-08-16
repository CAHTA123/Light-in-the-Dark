extends Resource

class_name Item

@export var stack = true

@export var slot_type = { "weapon": false, "shield": false, "axe": false, "pickaxe": false }

@export var name: String = ""
@export var texture: Texture2D
@export var character: Dictionary = {}

