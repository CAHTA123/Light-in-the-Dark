extends Node2D

@onready var body = $".."

func _process(delta):
	if body.take_push > 0:
		var p = body.take_push
		var push_point = body.center
		body.center = null
		body.take_push = 0
		push(push_point, p)

func push(push_point, p):
	body.current_state = body.States.DASH
	body.velocity = Vector2.ZERO
	
	
	body.velocity = push_point.direction_to(body.global_position).normalized() * -p
	await get_tree().create_timer(body.take_push_time).timeout 
	body.velocity = Vector2.ZERO
	
	
	
	body.current_state = body.States.IDLE
