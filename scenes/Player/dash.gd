extends Node2D

@onready var anim = $"../../Animations/Animation"

func _process(delta):	
	if Input.is_action_just_pressed("dash"):
		anim.play("dash")
