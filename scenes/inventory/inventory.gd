extends Node2D

const SlotClass = preload("res://scenes/inventory/Slot.gd")
@onready var inventory_slots = $GridContainer
var holding_item: Node2D = null  # Указываем тип, если это Node2D

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(_on_slot_gui_input, [inv_slot])

func _on_slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if holding_item != null:
				if !slot.item: # Поместить удерживаемый предмет в слот
					slot.put_into_slot(holding_item)
					holding_item = null
				else: # Поменять удерживаемый предмет с предметом в слоте
					var temp_item = slot.item
					slot.pick_from_slot()
					temp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
					holding_item = temp_item
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()

func _input(event: InputEvent):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
