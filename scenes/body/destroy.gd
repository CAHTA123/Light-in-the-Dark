extends Node2D

@onready var body = $".."

func _process(delta):
	if body.destroy:
		take()

func take():
	body.queue_free()
