extends Area2D

#@export var collision_node_path ="../../shape/StaticBody2D/CollisionPolygon2D"   # Путь к узлу с коллизией
#@onready var collision_node = get_node(collision_node_path)

@onready var collision_node = $"../../../Sprite/Island/shape/StaticBody2D/CollisionPolygon2D"

func _ready():
	set_process_input(true)


func _on_Area2D_body_entered(body):
	if body.has_method("get_name") and body.get_name() == "Player":
		collision_node.set_deferred("disabled", true)


func _on_Area2D_body_exited(body):
	if body.has_method("get_name") and body.get_name() == "Player":
		collision_node.set_deferred("disabled", false)
