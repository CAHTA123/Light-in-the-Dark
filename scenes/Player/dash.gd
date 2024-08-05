extends Node2D

@onready var anim = $"../../Animations/Animation"
@onready var body = $"../../Body"

func _process(delta):
	if Input.is_action_just_pressed("dash"):
		body.current_state = body.States.DASH
		anim.play("dash")
