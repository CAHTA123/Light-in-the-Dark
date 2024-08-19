extends Body
var take_damage_ = false
var player = null
#Создание таймера для охоты на игрока через код
func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.name = "HuntTimer"
	timer.connect('timeout', Callable(self, "_on_timer_timeout"))
	timer.set_wait_time(0.01)
	timer.set_one_shot(false)
	timer.stop()
	move_and_slide()
	random_walk()
	max_hp = 10
	item_drop = ""
#Перемещение к игроку
func hunt():
	if player and take_damage_:
		
		var direction = (player.global_position - global_position)
		
		if direction.x < 0:
			$"Body_Skin#Skin#Skin/Skin".scale.x = 1
			velocity.x = 200
		elif direction.x > 50:
			$"Body_Skin#Skin#Skin/Skin".scale.x = -1
			velocity.x = -200
		if direction.y < 0:
			velocity.y = 200
		elif direction.y > 50:
			velocity.y = -200
	move_and_slide()
	
#Обнаружение игрока
func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()
		
#Обнаружение того, что игрок вышел из радиуса обнаружения
func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
		$HuntTimer.stop()
		random_walk()
		
func drop():
	pass
	
func _on_timer_timeout():
	if player != null:
		hunt()
#Получение урона и смерть, если урона достаточно
func _on_hurt_area_entered(area):
	if hp <= take_damage:
		drop()
		queue_free()
	else:
		take_damage_ = true
		hp -= player.damage
	
#Ходьба свиньи в случайном направлении
func random_walk():
	while true and not take_damage_:
		velocity.x = randi_range(-50, 50)
		if velocity.x > 0:
			$"Body_Skin#Skin#Skin/Skin".scale.x = 1
		else:
			$"Body_Skin#Skin#Skin/Skin".scale.x = -1
		velocity.y = randi_range(-50, 50)
		await get_tree().create_timer(5).timeout
