extends Node2D

@onready var body = $".."

var can = true

func _process(delta):
	if Input.is_action_just_pressed("dash") and can:
		can = false
		push()

func push():
	body.current_state = body.States.DASH
	
	
	body.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * 1000
	await get_tree().create_timer(0.2).timeout 
	can = true
	
	
	
	body.current_state = body.States.IDLE
