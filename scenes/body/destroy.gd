extends Node2D

@onready var body = $".."

func _process(delta):
	if body.destroy:
		take()

func take():
	if body.item_drop:
		var i = load("res://scenes/item/item.tscn").instantiate()
		i.global_position = body.global_position
		get_parent().get_parent().add_child(i)
		body.queue_free()
	else:
		body.queue_free()
