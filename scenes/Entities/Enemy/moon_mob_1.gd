extends CharacterBody2D

var player = null

func _process(delta):
	if player:
		var direction = (player.global_position - global_position)
		
		
		if direction.x < 0:
			$Sprite2D.scale.x = 1
			velocity.x = 100
		elif direction.x > 0:
			$Sprite2D.scale.x = -1
			velocity.x = 100
		if direction.y < 0:
			velocity.y = 100
		elif direction.y > 0:
			velocity.y = -100
	move_and_slide()



func _on_hunt_area_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$AnimationPlayer.play("run")
		await $AnimationPlayer.animation_finished
		queue_free()
		
		










