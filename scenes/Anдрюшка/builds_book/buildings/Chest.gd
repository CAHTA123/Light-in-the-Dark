extends StaticBody2D

@onready var press_e = $Press_E
var load_progress 
func _ready():
	load_progress = press_e.get_node("TextureProgressBar")
	press_e.visible = false

func _on_interection_body_entered(body):
	press_e.visible = true
	
func _on_interection_body_exited(body):
	press_e.visible = false
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E and load_progress.value != 100 and press_e.visible:
			load_progress.value += 10
		else:
			if load_progress.value == 100:
				$CanvasLayer/chest_inv.open()
			load_progress.value = 0 
