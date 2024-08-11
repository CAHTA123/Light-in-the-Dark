extends CharacterBody2D

var player = null

func _process(delta):
	if player:

		var direction = (player.global_position - global_position)
		print(direction)
		velocity = direction 
		if direction.x < 0:
			$AnimatedSprite2D.scale.x = -2
		elif direction.x > 0:
			$AnimatedSprite2D.scale.x = 2
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
