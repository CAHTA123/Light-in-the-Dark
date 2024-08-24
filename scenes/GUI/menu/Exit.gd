extends Node2D

func _on_exit_pressed():
	$"../Start/Start".disabled = true
	$"../Settings/Settings".disabled = true
	$"../AnimationPlayer".play("light")
	await $"../AnimationPlayer".animation_finished
	$"../AnimationPlayer".play("h")
	await $"../AnimationPlayer".animation_finished	
	#print("Button was pressed!")
	get_tree().quit()
