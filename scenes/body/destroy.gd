extends Node2D

@onready var body = $".."

func _process(delta):
	if body.destroy:
		body.destroy = false
		take()

func take():
	if body.item_drop:
		var i = load("res://scenes/item/item.tscn").instantiate()
		i.global_position = body.global_position
		get_parent().get_parent().add_child(i)
	body.queue_free()
