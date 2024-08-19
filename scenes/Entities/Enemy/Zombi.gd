extends Body

var player = null
var zombi_dead_count = 1
var zombi_dead

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.name = "HuntTimer"
	timer.connect('timeout', Callable(self, "_on_timer_timeout"))
	timer.set_wait_time(0.01)
	timer.set_one_shot(false)
	timer.stop()
	
func hunt():
	var direction = (player.global_position - global_position)
	if direction.x < 0:
		$Sprite2D.scale.x = 0.2
		velocity.x = -100
	elif direction.x > 0:
		$Sprite2D.scale.x = -0.2
		velocity.x = 100
	if direction.y < 0:
		velocity.y = -100
	elif direction.y > 0:
		velocity.y = 100
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
		$HuntTimer.stop()
func check_other_bodies():
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		await get_tree().create_timer(1).timeout
		if overlap_body.get_name() == "Player":
			overlap_body.hp -= damage
			
func drop():
	pass
	
func _on_hurt_area_area_entered(area):
	if hp <= player.damage:
		if $"../Necromancer":
			$"../Necromancer".zombi_die(zombi_dead_count)
		drop()
		queue_free()
	else:
		hp -= player.damage
		
func _on_hit_area_body_entered(body: Node2D) -> void:
		if body.get_name() == "Player":
			body.hp -= damage
			check_other_bodies()
func _on_timer_timeout():
	if player != null:
		hunt()
