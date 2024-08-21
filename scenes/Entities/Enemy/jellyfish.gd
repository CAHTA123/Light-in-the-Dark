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


func drop():
	pass



func _on_hurt_area_entered(area: Area2D) -> void:
	if hp <= player.damage:
		drop()
		queue_free()
	else:
		hp -= player.damage


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		player = null
		$HuntTimer.stop()
		regen_hp()
func regen_hp():
	hp += 1
	await get_tree().create_timer(5).timeout
	if not player:
		regen_hp()
func hunt():
	if hp > 0 and not attack:
		var direction = (player.global_position - global_position)
		if direction.x < 0:
			#$Sprite2D.scale.x = 0.2
			velocity.x = -50
		elif direction.x > 100:
			#$Sprite2D.scale.x = -0.2
			velocity.x = 50
		if direction.y < 0:
			velocity.y = -50
		elif direction.y > 100:
			velocity.y = 50
		move_and_slide()
func _on_timer_timeout():
	if player != null:
		hunt()
		
func random_walk():
	while true:
		velocity.x = randi_range(-50, 50)
		#if velocity.x > 0:
			#$"Body_Skin#Skin#Skin/Skin".scale.x = 1
		#else:
			#$"Body_Skin#Skin#Skin/Skin".scale.x = -1
		velocity.y = randi_range(-50, 50)
		await get_tree().create_timer(5).timeout


func _on_attack_direction_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		await get_tree().create_timer(2).timeout
		$Anim/AnimationPlayer.play("attack")
func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.hp -= 2
func check_other_bodies():
	var overlapping_bodies = $Skills/Attack/Attack_hitbox.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		if overlap_body.get_name() == "Player":
			overlap_body.hp -= damage
