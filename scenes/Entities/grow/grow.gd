extends Node2D

@export var texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = texture
