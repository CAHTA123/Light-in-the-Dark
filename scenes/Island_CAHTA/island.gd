extends Area2D

@onready var ray_cast = $ShapeCast2D

var plate_sosed = {}

signal buy_island(island)

func _ready():
	buy_island.connect(on_buy)
	mega.call_deferred()

func mega():
	var last = Vector2.INF
	var last_col = null
	var closest_dist = INF
	var dist
	var can = false
	
	ray_cast.add_exception(self)
	ray_cast.enabled = true

	for i in range(0, 360, 1):
		ray_cast.rotation_degrees = i * 1
		ray_cast.force_shapecast_update()  
		
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider(0)
			var point = ray_cast.get_collision_point(0)
			dist = global_position.distance_to(point)
			
			if collider != last_col: 
				if last_col:
					plate_sosed[last_col] = last_col.spawn_plate(last)
				last_col = collider
				closest_dist = dist
				last = point
				can = true
			elif dist < closest_dist:
				closest_dist = dist
				last = point
		
		elif last_col != null: 
			plate_sosed[last_col] = last_col.spawn_plate(last)
			last_col = null
			last = Vector2.INF
			closest_dist = INF
			can = false

func spawn_plate(por):
	var p = load("res://scenes/Island_CAHTA/plate.tscn").instantiate()
	add_child(p)
	p.global_position = por
	return p

func on_buy(island):
	if not island in plate_sosed.keys():
		return
	plate_sosed[island].most = true
	var pos1 = plate_sosed[island].global_position
	var pos2 = plate_sosed[island].get_parent().plate_sosed[self].global_position
	prints(pos1 , pos2)
