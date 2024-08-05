extends Node2D

@onready var body = $"../../Body"
@onready var anim = $"../../Animations/Animation"

func _process(delta):
	if Input.is_action_just_pressed("block") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.BLOCK
		anim.play("block")

	elif Input.is_action_just_pressed("attack") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.ATTACK
		anim.play("attack")
