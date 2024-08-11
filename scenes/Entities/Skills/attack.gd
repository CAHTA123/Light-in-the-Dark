extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"

func _process(delta):
	if Input.is_action_just_pressed("block") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.BLOCK
		anim.play("block")

	elif Input.is_action_just_pressed("attack") and (body.current_state == body.States.IDLE or body.current_state == body.States.MOVE):
		body.current_state = body.States.ATTACK
		anim.play("attack")
	
	#if body.current_state != body.States.ATTACK:
		#$"../../Body/Skin/Skin/Weapon".visible = false
		#$"../../Body/Skin/Skin/Weapon/shape".monitoring = false
		#$"../../Body/Skin/Skin/Weapon/shape".monitorable = false
