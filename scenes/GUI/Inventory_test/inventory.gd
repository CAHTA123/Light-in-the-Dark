extends Control

@onready var body = $".."
@onready var grid = $NinePatchRect/GridContainer
@onready var slot = "res://scenes/GUI/Inventory_test/slot.tscn"

var slots: Array
var slot_count = 0
var slot_limit = 20

func _ready():
	update_slots()
	body.inv.update.connect(add_slots)
	slots = $NinePatchRect/GridContainer.get_children()

func update_slots():
	for i in range(slot_limit - slot_count):
		slot_count += 1
		var sl = Slot.new() 
		body.inv.slots_tres.append(sl)
		var s = load(slot).instantiate()
		grid.add_child(s)

func add_slots():
	for i in range(slots.size()):
		slots[i].update(body.inv.slots_tres[i])
		

