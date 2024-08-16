extends Node2D


@onready var collision_node = $Sprite/Island/shape/StaticBody2D/CollisionPolygon2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_shape_body_entered(body: Node2D) -> void:
	
	if body.name == "Player":
		pass
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		collision_node.disabled = true
