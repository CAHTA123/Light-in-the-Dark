extends Node2D

@onready var b = $"../../.."

func _on_shape_body_entered(body):
	body.take_damage = b.damage
