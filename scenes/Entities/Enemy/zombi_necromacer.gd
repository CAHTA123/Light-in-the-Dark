extends Body

var player = null
var zombi_dead = 1

func _process(delta):
	
	if player:

		var direction = (player.global_position - global_position)
		
		if direction.x < 0:
			$Sprite2D.scale.x = 0.2
			$Hurt_area.global_position.x + 100
			velocity.x = -100
		elif direction.x > 0:
			$Sprite2D.scale.x = -0.2
			$Hurt_area.global_position.x - 100
			velocity.x = 100
		if direction.y < 0:
			velocity.y = -100
		elif direction.y > 0:
			velocity.y = 100
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
		
func drop():
	pass
	
	
	
func _on_hurt_area_area_entered(area):
	
	#Signals.emit_signal('zombi_died', zombi_dead)
	drop()
	queue_free()
