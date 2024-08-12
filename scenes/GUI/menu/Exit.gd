extends Node2D

func _on_exit_pressed():
	print("Button was pressed!")
	get_tree().quit()
