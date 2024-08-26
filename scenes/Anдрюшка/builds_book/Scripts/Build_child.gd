extends Control

@onready var necessary_item = $ScrollContainer/necessary_items
@onready var build_texture = $TextureRect
@onready var build_name = $Name
@onready var bg = $"."
@onready var build_book = $"../../../.."
@export var building_data: Resource  # Ссылка на ресурс постройки
@export var material_slot_scene: PackedScene  # Сцена слота материала]

var selection_build_place = false
var can_build = true
var is_island_exited = false
var have_enough_res = false

var cam_zoom = Vector2(1, 1)
var pos_cam = Vector2(0, 0)

var build_prev
var texture_size
var build_collision
var area
var instance
var body 
var build_visible
func _ready():
	build_visible = build_book.get_node("CanvasLayer")
	body = get_tree().root.get_node("Game/Player")
	Signals.connect("change_zoom", _change_zoom)
	build_book.connect("open_book", _open_book)
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
		_open_book()
		if have_enough_res:
			build_book.close()
			build_preview(building_data)

func build_preview (build_data: Resource):
	var preview_texture = TextureRect.new()
	preview_texture.texture = building_data.texture
	preview_texture.modulate.a = 0.3
	preview_texture.expand_mode = 1
	preview_texture.size = building_data.texture_size
	
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

func _open_book():
	var have_res_count = count_available_resources(body.inv.slots_tres)
		# Проверка, хватает ли всех ресурсов
	var all_resources_available = check_resources(building_data.materials, have_res_count)

	if all_resources_available:
		have_enough_res = true
		necessary_item.modulate  = Color(1, 1, 1)
		
	else:
		have_enough_res = false
		necessary_item.modulate  = Color(1, 0.58, 0.58)
func _on_mouse_entered():
	bg.modulate.a = 0.5

func _on_mouse_exited():
	bg.modulate.a = 1

func _on_body_exited(body):
		is_island_exited = true

func check_resources(required: Dictionary, available_count: Dictionary):
	for resource_path in required:
		if resource_path not in available_count or available_count[resource_path] < required[resource_path]:
			return false
	return true

func count_available_resources(slots: Array) -> Dictionary:
	var resource_count = {}
	for slot in slots.size():
		var item = slots[slot].item # Получаем путь к ресурсу
		var amount = slots[slot].amount
		
		if item == null:
			continue
			
		if item in resource_count:
			resource_count[item] += amount
		else:
			resource_count[item.patch_to_item] = amount
			if selection_build_place:
				for resourse_path in building_data.materials:
					if resourse_path in resource_count:
						print(building_data.materials)
						remove_item(slot, amount, slots)
	return resource_count
	
func remove_item(slot, amount, slots: Array):
	var needed_col
	for resource_path in building_data.materials:
		needed_col = building_data.materials[resource_path]
	if amount != 0:
		slots[slot].amount = amount - needed_col
	if slots[slot].amount == 0:
		slots[slot].item = null
	body.inv.emit_signal("update")
	
func _input(event):
	if event is InputEventMouseButton:
		#button left
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if selection_build_place and build_prev and can_build:
					count_available_resources(body.inv.slots_tres)
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
				var collisions
				collisions = area.get_overlapping_bodies()
				var found_island_exited
				var found_zone_of_interactions
				build_collision = false
				if collisions.size() == 2:
					for body in collisions:
						if body.name == "island_exited":
							found_island_exited = true
						elif body.name == "zone of interactions":
							found_zone_of_interactions = true
					if found_zone_of_interactions and found_zone_of_interactions:
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
	
