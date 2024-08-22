extends Body

var player = null
var direction = null
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
	$hp_bar.visible = false
#Перемещение к игроку
func hunt():
	var direction = (player.global_position - global_position)
	if direction.x < 0:
		$Skin/Skin.scale.x = 1
		velocity.x = -100
	elif direction.x > 0:
		$Skin/Skin.scale.x = 1
		velocity.x = 100
	if direction.y < 0:
		velocity.y = -100
	elif direction.y > 0:
		velocity.y = 100
	move_and_slide()

func _on_hunt_area_body_entered(body: CharacterBody2D) -> void:
	if body.get_name() == "Player":
		player = body
		$hp_bar.visible = true
		$Skin/Skin.texture = load("res://sprites/Enemy/Cactus.png")
		$HuntTimer.start()
func _on_hunt_area_body_exited(body: CharacterBody2D) -> void:
	if body.get_name() == "Player":
		$hp_bar.visible = false
		$Skin/Skin.texture = load("res://sprites/Enemy/Cactus_not_agry.png")
		$HuntTimer.stop()
		regen_hp()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.hp -= damage
		check_other_bodies()

func check_other_bodies():
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for overlap_body in overlapping_bodies:
		await get_tree().create_timer(1).timeout
		if overlap_body.get_name() == "Player":
			overlap_body.hp -= damage
			
func _on_hurt_area_entered(area: Area2D) -> void:
	if hp <= player.damage:
		drop()
		queue_free()
	else:
		player.hp -= (player.damage / 3)
		hp -= player.damage
func drop():
	#var drop = drop_preload.instantiate()
	#drop.position = Vector2(self.position.x, self.position.y)
	#$".".add_child.call_deferred(drop)
	pass
func _on_timer_timeout():
	if player != null:
		hunt()
func regen_hp():
	hp += 1
	await get_tree().create_timer(5).timeout
	if not player:
		regen_hp()
