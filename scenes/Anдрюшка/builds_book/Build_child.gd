extends Control


@onready var necessary_item = $ScrollContainer/necessary_items
@onready var slot = "res://scenes/GUI/Inventory_test/slot.tscn"
@onready var build_texture = $TextureRect
@onready var build_name = $Name
@onready var bg = $ColorRect
@onready var build_book = $"../.."
#@onready var build_preview = $"../../../TextureRect"


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
		print("-materials")
		close()
		build_book.build_preview(build_texture.texture)
		
		
		
	
func close ():
	build_book.visible = false
	get_tree().paused = false
	
func _on_mouse_entered():
	bg.color.a = 0.5


func _on_mouse_exited():
	bg.color.a = 1
	
