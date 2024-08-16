extends Area2D


@onready var collision_node = $"../../../Sprite/Island/shape/StaticBody2D/CollisionPolygon2D"


	
func _process(delta: float) -> void:
	pass
func _on_body_entered(body):
	print(1)
	if body.name == "Player":
		
		collision_node.disabled = true

func _on_body_exited(body):
	if body.name == "Player":
		collision_node.disabled = false
		print("82828")


#func _on_shape_body_entered(body):
	#pass # Replace with function body.
