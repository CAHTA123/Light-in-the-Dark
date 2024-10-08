extends Body

var can_attack = true
var attack = false
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
#Функция преследования игрока(Обновляется по таймеру)
func hunt():
	if hp > 0 and not attack:
		var direction = (player.global_position - global_position)
		if direction.x < 0:
			$Sprite2D.scale.x = 0.2
			velocity.x = -50
			$Skills/Attack.scale.y = 1
			$Skills/Attack.rotation_degrees = 0
		elif direction.x > 100:
			$Skills/Attack.scale.y = -1
			$Skills/Attack.rotation_degrees = 180
			$Sprite2D.scale.x = -0.2
			velocity.x = 50
		if direction.y < 0:
			velocity.y = -50
		elif direction.y > 100:
			velocity.y = 50
		move_and_slide()
#Обнаружение игрока в зоне преследование
func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()
#Обнаружение выхода игрока из зоны преследование
func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
		$HuntTimer.stop()
		regen_hp()

		_patrul()
func check_other_bodies():
	var overlapping_bodies = $Skills/Attack/Hit_area.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		if overlap_body.get_name() == "Player":
			overlap_body.hp -= damage
func drop():
	#var drop = drop_preload.instantiate()
	#drop.position = Vector2(self.position.x, self.position.y)
	#$".".add_child.call_deferred(drop)
	pass
#Функция полученя урона от игрока
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
#Фунция нанесения урона по игроку
func _on_hit_area_body_entered(body: Node2D) -> void:
	if hp > 0:
		if body.get_name() == "Player":
			body.hp -= damage
			await get_tree().create_timer(1).timeout
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
	if hp > 0 and not attack:
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
#Функция смены направления движения, если моб упёрся в край острова
func _on_collision_stop_body_entered(body: Node2D) -> void:
	if body.get_name() == "StaticBody2D":
		velocity.x = velocity.x * -1
		velocity.y = velocity.y * -1
		if velocity.x > 0:
			$Sprite2D.scale.x = -0.2
		else:
			$Sprite2D.scale.x = 0.2

#Функция атаки моба, если игрок вошёл в нужную зону
func _on_attack_direction_body_entered(body: Node2D) -> void:
	if can_attack:
		attack = true
		var direction = (player.global_position - global_position)
		if body.get_name() == "Player":
			if direction.x < 0:
				$Sprite2D.scale.x = 0.2
				velocity.x = -1000
				await get_tree().create_timer(0.5).timeout
				attack = false
				velocity.x = 0
			elif direction.x > 0:
				$Sprite2D.scale.x = -0.2
				velocity.x = 1000
				await get_tree().create_timer(0.5).timeout
				velocity.x = 0
				attack = false

#Кулдаун атаки моба
func _on_attack_direction_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		can_attack =false
		await get_tree().create_timer(3).timeout
		can_attack =true
