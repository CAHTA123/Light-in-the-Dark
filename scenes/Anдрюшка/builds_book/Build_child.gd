extends Control


@onready var necessary_item = $ScrollContainer/necessary_items
@onready var slot = "res://scenes/GUI/Inventory_test/slot.tscn"
@onready var build_texture = $TextureRect
@onready var build_name = $Name
@onready var bg = $"."
@onready var build_book = $"../../.."
@onready var canvas_layer = $"../.."
var selection_build_place = false
#@onready var build_preview = $"../../../TextureRect"
var build_prev

@export var building_data: Resource  # Ссылка на ресурс постройки
@export var material_slot_scene: PackedScene  # Сцена слота материала
#signal build

func _ready():
	# Инициализируем данные о постройке
	if building_data:
		setup_building(building_data)

func _process(_delta):
	pass
func setup_building(data: Resource):
	# Устанавливаем иконку постройки
	build_texture.texture = data.icon
	
	# Устанавливаем название постройки
	build_name.text = data.building_name
	
	# Очищаем GridContainer
	
	# Добавляем слоты для материалов
	for item_path in data.materials.keys():
		var item_res = load(item_path) as Resource
		var slot_instance = material_slot_scene.instantiate()
		if item_res:
			# Добавляем слот в necessary_items
			necessary_item.add_child(slot_instance)
			
			 #Устанавливаем иконку материала
			slot_instance.texture = item_res.item.texture
			#
			# Устанавливаем количество материала
			slot_instance.amount = str(data.materials[item_path])
			
			
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		build_book.close()
		build_preview(build_texture.texture)
func build_preview (texture: CompressedTexture2D):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.modulate.a = 0.3
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(400, 400)
	get_tree().root.add_child(preview_texture)
	build_prev = preview_texture
	selection_build_place = true
	
func _on_mouse_entered():
	bg.modulate.a = 0.5

func _on_mouse_exited():
	bg.modulate.a = 1

func _input(event):
	if event is InputEventMouseMotion:
		if selection_build_place:
			build_prev.global_position = (get_global_mouse_position() - build_prev.get_size() / 2) 
			
