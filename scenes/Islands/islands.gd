extends Node2D

@export var texture: Texture2D

@onready var island: Sprite2D = $Sprite/Island

func _ready():
	island.texture = texture
