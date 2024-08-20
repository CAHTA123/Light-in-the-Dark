extends Body

var player = null
#var drop_preload

func _ready():
	#item_drop = ""
	#var drop_preload = preload(item_drop)
	var timer = Timer.new()
	add_child(timer)
	timer.name = "HuntTimer"
	timer.connect('timeout', Callable(self, "_on_timer_timeout"))
	timer.set_wait_time(0.01)
	timer.set_one_shot(false)
	timer.stop()
	hp = 5
func hunt():
		var direction = (player.global_position - global_position)
		if direction.x < 0:
			$"Sprite2D".scale.x = 1
			velocity.x = 160
		elif direction.x > 50:
			$"Sprite2D".scale.x = -1
			velocity.x = -160
		if direction.y < 0:
			velocity.y = 160
		elif direction.y > 50:
			velocity.y = -160
		move_and_slide()
	
	
func _on_hunt_area_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$AnimationPlayer.play("run")
		$HuntTimer.start()
		await $AnimationPlayer.animation_finished
		queue_free()

func _on_hurt_area_area_entered(area: Area2D) -> void:
	if hp <= player.damage:
		drop()
		queue_free()
	else:
		hp -= player.damage

func drop():
	#var drop = drop_preload.instantiate()
	#drop.position = Vector2(self.position.x, self.position.y)
	#$".".add_child.call_deferred(drop)
	pass
func _on_timer_timeout():
	if player != null:
		hunt()
