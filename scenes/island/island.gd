extends Area2D
#
#@onready var ray_cast = $ShapeCast2D
#
#var neighbor_plates = {}
#
#signal buy_island(island)
#
#func _ready():
	#buy_island.connect(on_buy)
	#scanner.call_deferred()
###Сканирует острова
#func scanner():  
	#var last = Vector2.INF
	#var last_col = null
	#var closest_dist = INF
	#var dist
	#
	#ray_cast.add_exception(self)
	#ray_cast.enabled = true
#
	#for i in range(0, 360, 1):
		#ray_cast.rotation_degrees = i * 1
		#ray_cast.force_shapecast_update()  
		#
		#if ray_cast.is_colliding():
			#var collider = ray_cast.get_collider(0)
			#var point = ray_cast.get_collision_point(0)
			#dist = global_position.distance_to(point)
			#
			#if collider != last_col: 
				#if last_col:
					#neighbor_plates[last_col] = last_col.spawn_plate(last, self)
				#last_col = collider
				#closest_dist = dist
				#last = points
			#elif dist < closest_dist:
				#closest_dist = dist
				#last = point
		#
		#elif last_col != null: 
			##neighbor_plates[last_col] = last_col.spawn_plate(last, self)
			#last_col = null
			#last = Vector2.INF
			#closest_dist = INF
#
###Создание таблички ,если есть остров к которому можно провести мост от текущего.
#func spawn_plate(pos, self_island):
	#var p = load("res://scenes/Island/plate.tscn").instantiate()
	#add_child(p)
	#var parent = p.get_parent()
	#p.island = self_island
	#p.global_position = pos
	#return p
#
###Покупка и спавн моста
#func on_buy(island):
	#if not island in neighbor_plates.keys():
		#return
	#neighbor_plates[island].has_bridge = false
	#neighbor_plates[island].get_parent().neighbor_plates[self].has_bridge = false
	#var pos1 = neighbor_plates[island].global_position
	#var pos2 = neighbor_plates[island].get_parent().neighbor_plates[self].global_position
	#var b = load("res://scenes/Island/bridge.tscn").instantiate()
	#b.i1 = island
	#b.i2 = self
	#island.add_child(b)
	#b.points(pos1, pos2)
##
