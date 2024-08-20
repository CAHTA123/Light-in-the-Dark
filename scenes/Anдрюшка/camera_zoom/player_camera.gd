extends Camera2D

var dragging = false
var drag_start_pos = Vector2()

func _process(delta):
	if zoom == Vector2(1, 1) and position != Vector2(0, 0):
		position = position.lerp(Vector2(0, 0), 60.0 * delta)
	if Input.is_action_just_pressed("+") and zoom < Vector2(0.9, 0.9):
		if position != Vector2(0, 0):
			if zoom > Vector2(0.075, 0.075):
				position = position.lerp(Vector2(0, 0), 60.0 * delta)
		if zoom < Vector2(0.09, 0.09):
			zoom += Vector2(0.3 * delta, 0.3 * delta)
		else:
			zoom += Vector2(5 * delta, 5 * delta)
		if zoom != Vector2(1, 1) and zoom > Vector2(0.9, 0.9):
			zoom = Vector2(1, 1)
	if Input.is_action_just_pressed("-") and zoom >= Vector2(0.03, 0.03):
		if zoom < Vector2(0.09, 0.09):
			zoom -= Vector2(0.3 * delta, 0.3 * delta)
		else:
			zoom -= Vector2(5 * delta, 5 * delta)

	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and zoom != Vector2(1, 1):
				dragging = true
				drag_start_pos = get_global_mouse_position()
			else:
				dragging = false
	
	if event is InputEventMouseMotion and dragging:
		var delta = get_global_mouse_position() - drag_start_pos
		global_position -= delta
		drag_start_pos = get_global_mouse_position()
