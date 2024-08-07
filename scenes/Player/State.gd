extends Node2D

@onready var body = $"../../Body"

func _ready():
	body.current_state = body.States.IDLE

func _process(delta):
	match (body.current_state):
		body.States.IDLE:
			body.velocity = Vector2(0,0)
			body.isBlocking = false
		body.States.MOVE:
			pass
		body.States.DASH:
			body.velocity *= 1.15
		body.States.ATTACK:
			pass
		body.States.BLOCK:
			body.isBlocking = true
		body.States.TAKEDAMAGE:
			body.isBlocking = true
