extends Node2D

@onready var body = $"../../Body"
@onready var SkinPlayer = $"../../Body/Skin"

func _ready():
	body.s = body.speed

func _process(delta):
	body.move_and_slide()
	if body.move and ["W", "A", "S", "D"].any(Input.is_action_pressed):
		body.current_state = body.States.MOVE
		move()
	elif body.move and body.current_state == body.States.MOVE: 
		body.current_state = body.States.IDLE

func move():
	body.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * body.s
	if body.velocity.x > 0: 
		SkinPlayer.scale.x = -1
	elif body.velocity.x < 0:
		SkinPlayer.scale.x = 1
