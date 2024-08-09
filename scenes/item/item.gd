extends Node2D



func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://sprites/weapon/axe/A3.png")
	else:
		$TextureRect.texture = load("res://sprites/weapon/axe/A2.png")
		



