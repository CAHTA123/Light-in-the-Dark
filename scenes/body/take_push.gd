extends Node2D

@onready var body = $".."

func _process(delta):
	if body.take_push > 0:
		push()
	
func push():
	body.take_push = 0 
	body.current_state = body.States.DASH
	body.velocity = Vector2.ZERO
	body.velocity = body.center.direction_to(body.global_position).normalized() * -1000
	await get_tree().create_timer(body.take_push_time).timeout 
	body.velocity = Vector2.ZERO
	body.current_state = body.States.IDLE
