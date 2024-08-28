extends TextureRect

@onready var text = $Item/amount
@onready var b = $"../../../../.."
@export var slot_inventory = true
@export var resurse: Resource
@export var slot_types = { "weapon": false, "shield": false, "axe": false, "pickaxe": false }

var dict = {}
var slot_index

func _ready():
	dict = {"weapon": b.weapon,"shield": b.shield,"axe": b.axe,"pickaxe": b.pickaxe}
	slot_index = get_slot_index()

func _get_drag_data(at_position):
	
	var p = TextureRect.new()
	p.texture = texture
	p.modulate.a = 0.3
	p.expand_mode = 1
	p.size = Vector2(64,64)
	
	var pr = Control.new()
	pr.add_child(p)
	set_drag_preview(pr)
	
	var drag_data
	if slot_inventory:
		drag_data = b.inv.slots_tres[slot_index].duplicate()
		b.inv.slots_tres[slot_index].item = null
		b.inv.slots_tres[slot_index].amount = 0
	else:
		for slot_type in slot_types.keys():
			if slot_type:
				drag_data = dict[slot_type].slot.duplicate()
				dict[slot_type].slot.item = null
	text.text = ""
	texture = null
	return drag_data

func _can_drop_data(at_position, data):
	if !slot_inventory:
		for slot_type in slot_types.keys():
			if slot_types[slot_type]:
				if data.item:
					if data.item.slot_type[slot_type]:
						return true
		return false
	return true

func _drop_data(at_position, data):
	print(data)
	update(data)

func update(slot):
	if slot.item:
		texture = slot.item.texture
		if slot_inventory:
			b.inv.slots_tres[slot_index].item = slot.item
			b.inv.slots_tres[slot_index].amount = slot.amount
		else:
			for slot_type in slot_types.keys():
				if slot_types[slot_type]:
					dict[slot_type].slot.item = slot.item
		text.text = str(slot.amount) if slot.amount > 1 else ""
	else:
		texture = null
		text.text = ""
func get_slot_index():
	var parent_container = get_parent()
	if parent_container is GridContainer:
		for i in range(parent_container.get_child_count()):
			if parent_container.get_child(i) == self:
				return i
