extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"

var can = true

func _process(delta):
	if Input.is_action_just_pressed("dash") and can:
		can = false
		body.current_state = body.States.DASH
		anim.play("dash")
		await get_tree().create_timer(2.0).timeout 
		can = true
