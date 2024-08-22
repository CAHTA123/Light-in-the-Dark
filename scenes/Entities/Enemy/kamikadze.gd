extends Body
var player = null
var attack = false

func _ready() -> void:
		#item_drop = ""
	#var drop_preload = preload(item_drop)
	var timer = Timer.new()
	add_child(timer)
	timer.name = "HuntTimer"
	timer.connect('timeout', Callable(self, "_on_timer_timeout"))
	timer.set_wait_time(0.01)
	timer.set_one_shot(false)
	timer.stop()
	random_walk()
#Взрыв при ударе игрока по мобу
func _on_hurt_area_entered(area: Area2D) -> void:
	boom()
#Обнаружение игрока в области погони
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()
#Обнаружение выхода игрока из зоны погони
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		player = null
		$HuntTimer.stop()
#Преселдование игрока в зоне
func hunt():
	if hp > 0 and not attack:
		var direction = (player.global_position - global_position)
		if direction.x < 0:
			#$Sprite2D.scale.x = 0.2
			velocity.x = -200
		elif direction.x > 100:
			#$Sprite2D.scale.x = -0.2
			velocity.x = 200
		if direction.y < 0:
			velocity.y = -200
		elif direction.y > 100:
			velocity.y = 200
		move_and_slide()
func _on_timer_timeout():
	if player != null:
		hunt()
#Случайная ходьба в разные стороны
func random_walk():
	while true:
		velocity.x = randi_range(-50, 50)
		#if velocity.x > 0:
			#$"Body_Skin#Skin#Skin/Skin".scale.x = 1
		#else:
			#$"Body_Skin#Skin#Skin/Skin".scale.x = -1
		velocity.y = randi_range(-50, 50)
		await get_tree().create_timer(5).timeout
#Взрыв включает коллизию нанемения урона через время(Указано в _on_boom_direction_body_entered)
func boom():
	$Skills/Boom/Boom_area/CollisionShape2D.disabled = false
func _on_boom_area_body_entered(body: Node2D) -> void:
	
	print(1)
	body.hp -= 5
	queue_free()
func _on_boom_direction_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.1).timeout
	boom()
