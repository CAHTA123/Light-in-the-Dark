extends Control

func _on_resume_pressed():
		$".".visible = false
		get_tree().paused = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
