extends Node2D

var isBlocking = false

func _on_shape_body_entered(body):
	body.take_damage = 1


		

