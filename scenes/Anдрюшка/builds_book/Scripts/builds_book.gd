extends Control

var global_mouse
func _ready():
	close()
func _input(event):
	global_mouse = get_global_mouse_position()
	if Input.is_action_just_pressed("B"):
		if !$CanvasLayer.visible:
			open()
		else:
			close()	
			
func open ():
	$CanvasLayer.visible = true
	get_tree().paused = true
	
func close ():
	$CanvasLayer.visible = false
	get_tree().paused = false
