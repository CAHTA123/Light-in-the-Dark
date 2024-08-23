extends Control


@onready var necessary_item = $ScrollContainer/necessary_items
@onready var build_texture = $TextureRect
@onready var build_name = $Name
@onready var bg = $"."
@onready var build_book = $"../../.."
@onready var canvas_layer = $"../.."
@export var building_data: Resource  # Ссылка на ресурс постройки
@export var material_slot_scene: PackedScene  # Сцена слота материала
var selection_build_place = false
var build_prev
var cam_zoom = Vector2(1, 1)
var pos_cam = Vector2(0, 0)
var texture_size
var colision
var objects_in_collision = []

var colision_copy
var area
var inside_log_path = 0

var instance
var can_build = true

func _ready():
	Signals.connect("change_zoom", _change_zoom)
	if building_data:
		setup_building(building_data)
		instance = building_data.build_scene.instantiate()


func _change_zoom (zoom, pos):
	pos_cam = pos
	cam_zoom = zoom

func setup_building(data: Resource):
	# Устанавливаем иконку постройки
	build_texture.texture = data.icon
	# Устанавливаем название постройки
	build_name.text = data.building_name
	# Добавляем слоты для материалов
	for item_path in data.materials.keys():
		var item_res = load(item_path) as Resource
		var slot_instance = material_slot_scene.instantiate()
		if item_res:
			# Добавляем слот в necessary_items
			necessary_item.add_child(slot_instance)
			 #Устанавливаем иконку материала
			slot_instance.texture = item_res.item.texture
			# Устанавливаем количество материала
			slot_instance.amount = str(data.materials[item_path])

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		build_book.close()
		build_preview(building_data)

func build_preview (build_data: Resource):
	var preview_texture = TextureRect.new()
	preview_texture.texture = building_data.texture
	preview_texture.modulate.a = 0.3
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(400, 400)
	
	texture_size = preview_texture.size
	build_prev = preview_texture
	
	instance = building_data.build_scene.instantiate()
	add_child(instance)
	
	colision_copy = instance.get_node("Area2D/CollisionPolygon2D").duplicate()
	area = instance.get_node("Area2D").duplicate()
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	area.connect("body_shape_entered", Callable(self, "_on_area_2d_body_shape_entered"))
	get_tree().root.add_child(area)
	area.add_child(colision_copy)
	
	get_tree().root.add_child(preview_texture)
	selection_build_place = true
	
func _on_mouse_entered():
	bg.modulate.a = 0.5

func _on_mouse_exited():
	bg.modulate.a = 1

func _on_body_entered(body):
	print("enterted")
	if body.name != "StaticBody2D":
		if body not in objects_in_collision:
			objects_in_collision.append(body)
			can_build = false
	if body.name == "StaticBody2D" and inside_log_path != 1:
		if body not in objects_in_collision:
			objects_in_collision.append(body)
		inside_log_path = 1
func _on_body_exited(body):
	print("exit")
	if body.name != "StaticBody2D":
		if body in objects_in_collision:
			objects_in_collision.erase(body)
			if objects_in_collision.size() > 0:
				can_build = false
			else:
				can_build = true
	elif body.name == "StaticBody2D" and inside_log_path == 1:
		inside_log_path = 6
		can_build = false

	
func _input(event):
	if event is InputEventMouseButton:
		#button left
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if selection_build_place and build_prev and can_build:
					print("-materials")
					var build_scene = instance.duplicate()
					build_scene.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
					get_tree().root.add_child(build_scene)
					
					area.queue_free()
					instance.queue_free()
					build_prev.queue_free()
					selection_build_place = false
		#button right
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				if selection_build_place  and build_prev:
					build_prev.queue_free()
					area.queue_free()
					instance.queue_free()
					build_prev = null
					selection_build_place = false
	#set preview pos
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if selection_build_place:
			if can_build:
				build_prev.modulate.a = 0.5
				build_prev.modulate.g = 1
				build_prev.modulate.b = 0
			else:
				build_prev.modulate.a = 1
				build_prev.modulate.g = 0
				build_prev.modulate.b = 0
			area.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
			build_prev.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
	
