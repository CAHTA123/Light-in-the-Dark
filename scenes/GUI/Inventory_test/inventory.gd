extends Control

@onready var body = $"../.."
@onready var grid_inv = $I/G
@onready var slot = "res://scenes/GUI/Inventory_test/slot.tscn"

var slots: Array
var slots_wea
var slots_tools: Array
var slot_count = 0
var slot_limit = 36
var is_open

func _ready():
	close()
	update_slots()
	body.inv.update.connect(add_slots)
	slots = grid_inv.get_children()
	slots_wea = grid_inv.get_children()
	slots_tools = grid_inv.get_children()

func update_slots():
	for i in range(slot_limit - slot_count):
		slot_count += 1
		var sl = Slot.new() 
		body.inv.slots_tres.append(sl)
		var s = load(slot).instantiate()
		grid_inv.add_child(s)

func add_slots():
	for i in range(slots.size()):
		slots[i].update(body.inv.slots_tres[i])

func _process(delta):
	if Input.is_action_just_pressed("I"):
		if is_open:
			close()
		else:
			open()

func open():
	get_tree().paused = true
	$"../Blur".visible = true
	visible = true
	is_open = true

func close():
	get_tree().paused = false
	$"../Blur".visible = false
	visible = false
	is_open = false

