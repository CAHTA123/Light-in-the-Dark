extends Node2D

@onready var body = $".."

func _process(delta):
	if body.take_push > 0:
		push()
	
func push():
	body.s = 0
	body.velocity = body.center.direction_to(body.global_position).normalized() * -1000
	body.take_push = 0  
	print(body.velocity)
	await get_tree().create_timer(0.1).timeout 
	body.velocity = Vector2.ZERO
	body.s = body.speed
