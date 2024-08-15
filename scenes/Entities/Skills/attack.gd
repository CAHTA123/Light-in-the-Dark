extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"

func _process(delta):
	if Input.is_action_just_pressed("block") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.BLOCK
		anim.play("block")

	elif Input.is_action_just_pressed("attack") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.ATTACK
		var mouse_pos = get_global_mouse_position()
		var player_pos = body.position  # Или position, если вы используете обычный узел, а не KinematicBody2D или RigidBody2D
		if mouse_pos.x > player_pos.x:
			$"../../Skin".scale.x = -1
		elif mouse_pos.x < player_pos.x:
			$"../../Skin".scale.x = 1
		anim.play("attack")
	
	#if body.current_state != body.States.ATTACK:
		#$"../../Body/Skin/Skin/Weapon".visible = false
		#$"../../Body/Skin/Skin/Weapon/shape".monitoring = false
		#$"../../Body/Skin/Skin/Weapon/shape".monitorable = false
