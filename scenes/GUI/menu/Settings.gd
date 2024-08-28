extends Node2D

func _on_settings_pressed():
	$"../Start/Start".disabled = true
	$"../Exit/Exit".disabled = true
	$"../AnimationPlayer".play("j")

