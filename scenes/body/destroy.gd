extends Node2D

@onready var body = $".."

func _process(delta):
	if body.destroy:
		take()

func take():
	if body.item_drop:
		var i = load(body.item_drop).instantiate()
		i.global_position = body.global_position
		get_parent().get_parent().add_child(i)
	else:
		body.queue_free()
