extends Control

@export var inv: ChestInv
@onready var chest_inv = self
@onready var body_inv = get_tree().root.get_node("Game/Player/Pause/Inventory")
@onready var grid_inv = $I/G
@onready var slot = "res://scenes/Anдрюшка/builds_book/buildings/chest test/chest_slot.tscn"

var slots: Array
var slot_count = 0
var slot_limit = 36
var is_open

func _ready():
	inv = ChestInv.new()
	close()
	update_slots()
	self.inv.update3.connect(add_slots)
	slots = grid_inv.get_children()

func update_slots():
	for i in range(slot_limit - slot_count):
		slot_count += 1
		var sl = Slot.new() 
		chest_inv.inv.slots_tres.append(sl)
		var s = load(slot).instantiate()
		grid_inv.add_child(s)

func add_slots():
	for i in range(slots.size()):
		slots[i].update(inv.inv.slots_tres[i])

func _input(event):
	pass
		

func open():
	body_inv.open(Vector2(72, 72))
	get_tree().paused = true
	#$"../Blur".visible = true
	visible = true
	is_open = true

func close():
	body_inv.close()
	get_tree().paused = false
	#$"../Blur".visible = false
	visible = false
	is_open = false
	




func _on_button_pressed():
	close()
