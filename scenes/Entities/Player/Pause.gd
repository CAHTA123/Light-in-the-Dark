extends Node2D

func _ready():
	pass




func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		$"../../Pause/Pause".visible = true
