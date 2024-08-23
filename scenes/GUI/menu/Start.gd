extends Node2D

func _ready():
	$"../AnimationPlayer".play("on")


func _on_start_pressed():
	$"../AnimationPlayer".play("f")
	await $"../AnimationPlayer".animation_finished
	$"../AnimationPlayer".play("light")
	await $"../AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://scenes/Game/game.tscn")
