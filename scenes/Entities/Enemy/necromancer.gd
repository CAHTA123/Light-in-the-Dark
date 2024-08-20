extends Body
var player = null
var zombi_preload = preload("res://scenes/Entities/Enemy/zombi.tscn")
var zombi_dead_ = 0
var can_spawn_zombi = false
var zombi_dead_count: int
#var drop_preload
func _ready() -> void:
	#item_drop = ""
	#var drop_preload = item_drop
	var timer = Timer.new()
	add_child(timer)
	timer.name = "HuntTimer"
	timer.connect('timeout', Callable(self, "_on_timer_timeout_"))
	timer.set_wait_time(0.01)
	timer.set_one_shot(false)
	timer.stop()
	move_and_slide()
func hunt():
	if zombi_dead_ > 0 and can_spawn_zombi:
		zombi_dead_ -= 1
		can_spawn_zombi = false
		Spawn_zombi() 

	if player:
		var direction = (player.global_position - global_position)
		if direction.x < 0:
			$Sprite2D.scale.x = 1
			velocity.x = -100
		elif direction.x > 0:
			$Sprite2D.scale.x = 1
			velocity.x = 100
		if direction.y < 0:
			velocity.y = -100
		elif direction.y > 0:
			velocity.y = 100
	move_and_slide()

func _on_fight_area_body_entered(body):
	if body.get_name() == "Player":
		player = body
		$HuntTimer.start()
		if player:
			for i in range(3):
				if zombi_dead_ < 1:
					Spawn_zombi()
					
func _on_fight_area_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$HuntTimer.stop()
	
	
func Spawn_zombi():
	var zombi = zombi_preload.instantiate()
	zombi.position = Vector2(self.position.x + randi_range(-300, 300), self.position.y + randi_range(-300, 300) )
	$"..".add_child.call_deferred(zombi)
	
func zombi_die(zombi_dead_count):
	zombi_dead_ += zombi_dead_count

func _on_timer_timeout():
	can_spawn_zombi = true

func _on_hurt_area_entered(area: Area2D) -> void:
	if hp <= player.damage:
		drop()
		queue_free()
	else:
		hp -= player.damage
func drop():
	pass
	#var drop = drop_preload.instantiate()
	#drop.position = Vector2(self.position.x, self.position.y)
	#$".".add_child.call_deferred(drop)
func _on_timer_timeout_():
	if player != null:
		hunt()
