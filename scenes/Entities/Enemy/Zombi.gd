extends Body

var player = null
var zombi_dead_count = 1
var zombi_dead
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
	_patrul()
	process()
func hunt():
	if hp > 0:
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
		regen_hp()

		_patrul()
func check_other_bodies():
	var overlapping_bodies = $Hit_area.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		await get_tree().create_timer(1).timeout
		if overlap_body.get_name() == "Player":
			overlap_body.hp -= damage
			
func drop():
	#var drop = drop_preload.instantiate()
	#drop.position = Vector2(self.position.x, self.position.y)
	#$".".add_child.call_deferred(drop)
	pass
func _on_hurt_area_area_entered(area):
	if hp <= player.damage:
		velocity = Vector2(0, 0)
		hp = 0
		if $"../Necromancer":
			$"../Necromancer".zombi_die(zombi_dead_count)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color( 1, 1, 1 , 0),  5)
		await tween.finished
		drop()
		queue_free()
	else:
		hp -= player.damage
		
func _on_hit_area_body_entered(body: Node2D) -> void:
	if hp > 0:
		if body.get_name() == "Player":
			body.hp -= damage
			check_other_bodies()
func _on_timer_timeout():
	if player != null:
		hunt()
#Регенирация хп
func regen_hp():
	hp += 1
	await get_tree().create_timer(5).timeout
	if not player:
		regen_hp()
#Патрулирование 
func _patrul():
	if hp > 0:
		while true:
			velocity.x = randi_range(-50, 50)
			if velocity.x > 0:
				$Sprite2D.scale.x = -0.2
			else:
				$Sprite2D.scale.x = 0.2
			velocity.y = randi_range(-50, 50)
			await get_tree().create_timer(5).timeout
#Обновление физики
func process():
	while true:
		move_and_slide()
		await get_tree().create_timer(0.02).timeout

func _on_collision_stop_body_entered(body: Node2D) -> void:
	if body.get_name() == "StaticBody2D":
		velocity.x = velocity.x * -1
		velocity.y = velocity.y * -1
		if velocity.x > 0:
			$Sprite2D.scale.x = -0.2
		else:
			$Sprite2D.scale.x = 0.2
