extends Area2D

var island = null
var block = false

func _process(delta):
	if island:
		island.disabled = block
		island = null 

func _on_body_entered(body):
	if body.name == "Player":
		block = true
		island = $"../StaticBody2D/CollisionPolygon2D"
		

func _on_body_exited(body):
	if body.name == "Player":
		block = false
		island = $"../StaticBody2D/CollisionPolygon2D"

