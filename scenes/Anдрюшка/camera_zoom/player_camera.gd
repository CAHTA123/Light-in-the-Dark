extends Camera2D

var dragging = false
var drag_start_pos = Vector2()
@onready var player_cam_node = $"../Player"
var player_cam_enabled = false
var player_pos = Vector2(0, 0)

func _ready():
	if player_cam_node != null:
		player_cam_enabled = player_cam_node.camera_2d
		player_cam_node.camera_2d = true
		player_pos = player_cam_node.position
		
		
	
func _process(delta):
	if player_cam_node != null:
		player_pos = player_cam_node.position
	if zoom == Vector2(1, 1) and position != player_pos:
		position = position.lerp(Vector2(player_pos), 60.0 * delta)
	elif zoom == Vector2(1, 1):
		player_cam_node.camera_2d = true
		enabled = false
	elif zoom != Vector2(1, 1):
		Signals.change_zoom.emit(self.zoom)
	if Input.is_action_just_pressed("+") and zoom < Vector2(0.9, 0.9):
		if position != Vector2(player_pos):
			if zoom > Vector2(0.075, 0.075):
				position = position.lerp(player_pos, 60.0 * delta)
		if zoom < Vector2(0.09, 0.09):
			zoom += Vector2(0.3 * delta, 0.3 * delta)
		else:
			zoom += Vector2(5 * delta, 5 * delta)
		if zoom != Vector2(1, 1) and zoom > Vector2(0.9, 0.9):
			zoom = Vector2(1, 1)
	if Input.is_action_just_pressed("-") and zoom >= Vector2(0.03, 0.03):
		enabled = true
		player_cam_node.camera_2d = false
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
