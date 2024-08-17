extends Camera2D


func _process(delta):
	if Input.is_action_pressed("ui_page_up"):
		zoom += Vector2(0.5 * delta, 0.5 * delta)
	if Input.is_action_pressed("ui_page_down"):
		zoom -= Vector2(0.5 * delta, 0.5 * delta)
