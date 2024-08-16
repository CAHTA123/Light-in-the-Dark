extends Body
var take_damage_ = false
var player = null

func _ready():
	random_walk()
	max_hp = 10
	item_drop = ""
	
func _process(delta):
	
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

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player = body
		
		

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player = null
		random_walk()
func drop():
	pass
	
	
	



func _on_hurt_area_entered(area):
	
	
	if hp <= take_damage:
		
		drop()
		queue_free()
	else:
		take_damage_ = true
		
		hp -= player.damage
		
func random_walk():
	
	while true and not take_damage_:
		velocity.x = randi_range(-50, 50)
		if velocity.x > 0:
			$"Body_Skin#Skin#Skin/Skin".scale.x = 1
		else:
			$"Body_Skin#Skin#Skin/Skin".scale.x = -1
		velocity.y = randi_range(-50, 50)
		await get_tree().create_timer(5).timeout
	
	
