extends TextureRect

@onready var text = $Item/amount

var slot_index

func _ready():
	update(slot_index)
	slot_index = get_slot_index()

func get_slot_index():
	var parent_container = get_parent()
	if parent_container is GridContainer:
		for i in range(parent_container.get_child_count()):
			if parent_container.get_child(i) == self:
				return i
				
func update(slot):
	if slot.item:
		texture = slot.item.texture
		#if slot_inventory:
			#b.inv.slots_tres[slot_index].item = slot.item
			#b.inv.slots_tres[slot_index].amount = slot.amount
		#else:
			#for slot_type in slot_types.keys():
				#if slot_types[slot_type]:
					#dict[slot_type].slot.item = slot.item
		text.text = str(slot.amount) if slot.amount > 1 else ""
