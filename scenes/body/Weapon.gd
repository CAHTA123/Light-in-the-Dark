extends Node2D

@onready var b = $"../.."
var isBlocking = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_shape_body_entered(body):
	body.take_damage = b.damage


