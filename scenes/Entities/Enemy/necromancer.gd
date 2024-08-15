extends CharacterBody2D
var player = null
var zombi_preload = preload("res://scenes/Entities/Enemy/zombi_necromacer.tscn")
var zombi_dead_ = 0
var can_spawn_zombi = false
func _ready():
	Signals.connect("zombi_died", Callable(self, 'zombi_die'))



func _process(delta):
	
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
		for i in range(3):
			if zombi_dead_ < 1:
				Spawn_zombi()
		player = body
	
func Spawn_zombi():
	var zombi = zombi_preload.instantiate()
	zombi.position = Vector2(self.position.x + randi_range(-300, 300), self.position.y + randi_range(-300, 300) )
	$"..".add_child.call_deferred(zombi)

	
func dead():
	pass
func zombi_die(zombi_dead):
	
	zombi_dead_ += zombi_dead




func _on_timer_timeout():
	can_spawn_zombi = true
