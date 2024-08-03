extends Node2D

@onready var body = $".."

var cur

func _ready():
	body.current_state = body.States.IDLE

func _process(delta):
	match (body.current_state):
		body.States.IDLE:
			body.move = true
		body.States.MOVE:
			body.move = true
		body.States.DASH:
			body.move = false
		body.States.ATTACK:
			body.move = false
		body.States.BLOCK:
			body.move = false
