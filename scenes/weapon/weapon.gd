extends Node2D

func _on_shape_body_entered(body):
	body.take_damage = 1
