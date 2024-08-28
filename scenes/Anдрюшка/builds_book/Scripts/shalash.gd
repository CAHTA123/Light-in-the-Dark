extends StaticBody2D

@export var materials_scenes: Array[PackedScene]
@onready var press_e = $Press_E
var load_progress
var sleep = false
var is_in_area = false

func _ready():
	load_progress = press_e.get_node("TextureProgressBar")
	press_e.visible = false

func _on_interaction_body_entered(body):
	is_in_area = true
	if !sleep:
		press_e.visible = true
		
func _on_interaction_body_exited(body):
	is_in_area = false
	if !sleep:
		press_e.visible = false

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E and load_progress.value != 100 and !sleep and is_in_area:
			load_progress.value += 5
		else:
			if load_progress.value == 100:
				sleep = true
				Signals.sleep.emit()
				print("you sleep")
				press_e.visible = false
				await get_tree().create_timer(4).timeout
				print("you woke up")
				sleep = false
			load_progress.value = 0 
		
