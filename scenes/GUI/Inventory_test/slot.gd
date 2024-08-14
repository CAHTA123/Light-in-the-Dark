extends TextureRect

@onready var text = $Item/amount
@onready var b = $"../../../../.."
@export var slot_inventory = true
@export var slot_weapon = false
@export var slot_shield = false
@export var slot_axe = false
@export var slot_pickaxe = false
var slot_index

func _ready():
	slot_index = get_slot_index()

func _get_drag_data(at_position):
	var item = b.inv.slots_tres[slot_index]
	var p = TextureRect.new()
	p.texture = texture
	p.modulate.a = 0.3
	p.expand_mode = 1
	p.size = Vector2(64,64)
	var pr = Control.new()
	pr.add_child(p)
	set_drag_preview(pr)
	texture = null
	text.text = ""
	b.inv.slots_tres[slot_index] = Slot
	var drag_data = {}
	drag_data["item"] = item
	drag_data["position"] = at_position
	return drag_data

func _can_drop_data(at_position, data):
	return data.has("item")
	
func _drop_data(at_position, data):
	if data.has("item"):
		update(data["item"])

func update(slot):
	if slot.item:
		texture = slot.item.texture
		if slot_inventory:
			b.inv.slots_tres[slot_index].item = slot.item
			b.inv.slots_tres[slot_index].amount = slot.amount
		elif slot_weapon and slot.item.weapon:
			print(0)
			b.weapon.i = slot.item
		elif slot_shield and slot.item.shield:
			b.shield.i = slot.item
		elif slot_axe and slot.item.axe:
			b.axe.i = slot.item
		elif slot_pickaxe and slot.item.pickaxe:
			b.pickaxe.i = slot.item
		if slot.amount > 1:
			text.text = str(slot.amount)
		else:
			text.text = ""
		b.new_item = true

func get_slot_index():
	var parent_container = get_parent()
	if parent_container is GridContainer:
		for i in range(parent_container.get_child_count()):
			if parent_container.get_child(i) == self:
				return i
