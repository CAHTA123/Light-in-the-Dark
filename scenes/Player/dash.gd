extends Node2D

@onready var body = $".."

func _process(delta):
	if Input.is_action_pressed("dash") and body.move:
		push()

func push():
	body.s = 0
	body.velocity = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized() * 1000 
	await get_tree().create_timer(0.1).timeout 
	body.velocity = Vector2.ZERO
	body.s = body.speed
