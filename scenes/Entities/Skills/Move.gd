extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"
@onready var SkinPlayer = $"../../Skin"

func _process(delta):
	if ["W", "A", "S", "D"].any(Input.is_action_pressed) and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE): 
		body.current_state = body.States.MOVE
		body.current_state = body.States.MOVE
		move()
	elif body.current_state == body.States.MOVE:
		body.current_state = body.States.IDLE
	body.move_and_slide()

func move():
	body.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * body.speed
	body.last_move = body.velocity
	
	if body.velocity.x > 0: 
		SkinPlayer.scale.x = -1
	elif body.velocity.x < 0:
		SkinPlayer.scale.x = 1
