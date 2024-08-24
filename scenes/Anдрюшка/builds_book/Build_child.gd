extends Control


@onready var necessary_item = $ScrollContainer/necessary_items
@onready var build_texture = $TextureRect
@onready var build_name = $Name
@onready var bg = $"."
@onready var build_book = $"../../.."

@export var building_data: Resource  # Ссылка на ресурс постройки
@export var material_slot_scene: PackedScene  # Сцена слота материала]

var selection_build_place = false
var build_prev
var cam_zoom = Vector2(1, 1)
var pos_cam = Vector2(0, 0)
var texture_size
var build_collision
var area
var instance
var can_build = true
var is_island_exited = false

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
	
	build_collision = instance.get_node("Area2D/CollisionShape2D").duplicate()
	area = instance.get_node("Area2D").duplicate()
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	get_tree().root.add_child(area)
	area.add_child(build_collision)
	instance.queue_free()
	
	
	get_tree().root.add_child(preview_texture)
	area.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
	build_prev.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
	selection_build_place = true
	
func _on_mouse_entered():
	bg.modulate.a = 0.5

func _on_mouse_exited():
	bg.modulate.a = 1

func _on_body_exited(body):
		is_island_exited = true
		
	
func _input(event):
	if event is InputEventMouseButton:
		#button left
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if selection_build_place and build_prev and can_build:
					print("-materials")
					var build_scenee = building_data.build_scene.instantiate()
					build_scenee.global_position = (build_book.global_mouse - texture_size / 2) + cam_zoom
					get_tree().root.add_child(build_scenee)
					
					area.queue_free()
					build_prev.queue_free()
					selection_build_place = false
		#button right
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				if selection_build_place  and build_prev:
					build_prev.queue_free()
					area.queue_free()
					build_prev = null
					selection_build_place = false
	#set preview pos
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if selection_build_place:
			if area.get_overlapping_bodies().size() > 0:
				build_collision = false
				if area.get_overlapping_bodies().size() == 1:
					for body in area.get_overlapping_bodies():
						if body.name == "island_exited":
							can_build = true
						else:
							can_build = false
				else:
					can_build = false
			elif !is_island_exited:
				can_build = true
			else:
				can_build = false
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
	
