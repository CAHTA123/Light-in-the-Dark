extends Node


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$"../CanvasLayer/MENU PLAY".visible = true
		get_tree().paused = true
		


