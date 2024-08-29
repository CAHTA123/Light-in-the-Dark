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
var book_visible
var have_res = {}
var necessary_items_box = {}

func _ready():
	book_visible = build_book.get_node("CanvasLayer")
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
	for item_path in data.materials.size():
		var item_res = data.materials[item_path].material
		var slot_instance = material_slot_scene.instantiate()
		if item_res:
			# Добавляем слот в necessary_items
			necessary_item.add_child(slot_instance)
			#Устанавливаем иконку материала
			slot_instance.texture = item_res.item.texture
			# Устанавливаем количество материала
			slot_instance.amount = str(data.materials[item_path].amount)

func _on_mouse_signal_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		bg.modulate.a = 0.5
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_open_book()
		if have_enough_res:
			build_book.close()
			build_preview(building_data)
		else:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Don't have label")

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
	var have = check_resources(building_data.materials, body.inv.slots_tres)
	if typeof(have) != TYPE_ARRAY:
		have_enough_res = have
	else:
		have_enough_res = false
	apdate_necessary_slots(have_res)

func _on_control_mouse_entered():
	bg.modulate.a = 0.5

func _on_control_mouse_exited():
	bg.modulate.a = 1

func _on_body_exited(body):
		is_island_exited = true

func check_resources(necessary_items: Array, inventory_slots: Array):
	# Создаем словарь для хранения доступных предметов и их количества
	var available_items = {}
	var missing_items = []

	# Проходим по слотам инвентаря и заполняем словарь доступных предметов
	for slot in inventory_slots.size():
		var item = inventory_slots[slot].item
		var amount = inventory_slots[slot].amount

		if item == null:
			continue
		var item_path = item.patch_to_item
		# Добавляем предмет и его количество в словарь
		if item_path in available_items:
			available_items[item_path] += amount
		else:
			#тут добавляеться путь к предмету и его колличество
			available_items[item_path] = amount
		have_res = available_items 
	#translate: available_items доступные_элементы
	# Проверяем, хватает ли каждого предмета из necessary_items в available_items
	for neccess_slot in necessary_items.size():
		var neccess_item = necessary_items[neccess_slot].material.item.patch_to_item
		var neccess_amount = necessary_items[neccess_slot].amount

		if neccess_item not in available_items or available_items[neccess_item] < neccess_amount:
			missing_items.append(neccess_slot)
			#это добавляеться для того чтобы знать кокого именно предмета не хватает
	if missing_items.size() > 0:
		#и тут возващаеться массив с предметами
		return missing_items
	return true # Все предметы есть в нужном количестве
func remove_items(necessary_items: Array, inventory_slots: Array):
	# Проходим по необходимым предметам и удаляем их из инвентаря
	for neccess_slot in necessary_items:
		var neccess_item = neccess_slot.material.item.patch_to_item
		var neccess_amount = neccess_slot.amount

		for slot in inventory_slots:
			var item = slot.item
			if item == null:
				continue

			var item_path = item.patch_to_item

			if item_path == neccess_item:
				if slot.amount > neccess_amount:
					# Уменьшаем количество предмета
					slot.amount -= neccess_amount
					body.inv.emit_signal("update")
					break
				elif slot.amount == neccess_amount:
					# Удаляем предмет
					slot.amount = 0
					slot.item = null
					body.inv.emit_signal("update")
					break
				else:
					# Если предметов в слоте меньше, чем необходимо, удаляем все
					neccess_amount -= slot.amount
					slot.amount = 0
					slot.item = null
					body.inv.emit_signal("update")
func apdate_necessary_slots(have_items: Dictionary):
	var items = necessary_item.get_children()
	var have_enough = check_resources(building_data.materials, body.inv.slots_tres)
	for item in items.size():
		if typeof(have_enough) != TYPE_ARRAY:
			items[item].modulate = Color(1,1,1)
			self.modulate = Color(1, 1, 1)
		else:
			self.modulate = Color(0.98, 0.98, 0.98)
			items[item].modulate = Color(1,1,1)
			for i in have_enough:
				items[i].modulate = Color(1, 0.45, 0.45)
			
	
func _input(event):
	if event is InputEventMouseButton:
		#button left
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if selection_build_place and build_prev and can_build:
					remove_items(building_data.materials, body.inv.slots_tres)
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

