extends Node2D

func _on_exit_pressed():
	$"../AnimationPlayer".play("light")
	await $"../AnimationPlayer".animation_finished
	$"../AnimationPlayer".play("h")
	await $"../AnimationPlayer".animation_finished	
	#print("Button was pressed!")
	get_tree().quit()
