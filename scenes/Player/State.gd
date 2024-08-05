extends Node2D

@onready var body = $"../../Body"

func _ready():
	body.current_state = body.States.IDLE

func _process(delta):
	match (body.current_state):
		body.States.IDLE:
			
			body.velocity = Vector2(0,0)
			body.move = true
		body.States.MOVE:
			body.move = true
		body.States.DASH:
			body.move = false
			body.velocity *= 1.005
		body.States.ATTACK:
			body.move = false
		body.States.BLOCK:
			body.move = false
			
