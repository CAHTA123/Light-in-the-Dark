extends CharacterBody2D
var chase = false
var direction = Vector2.ZERO

func _process(delta):
	direction = (Global.player_pos - self.position)
	print(Global.player_pos - self.position)

	if chase:
		if direction.x < 938:
			position.x -= 1
		elif direction.x >1135:
			position.x += 1
			
			
		
		
		









func _on_area_2d_body_entered(body):
	chase = true


func _on_area_2d_body_exited(body):
	chase = false
