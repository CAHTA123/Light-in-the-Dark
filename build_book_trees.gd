extends Resource

class_name Build_b

@export var slots_tres: Array[Slot]

signal update_need_res

func ins(item: Item):
	var itemslots = slots_tres.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty() and item.stack:
		itemslots[0].amount += 1
	else: 
		var emptyslots = slots_tres.filter(func(slot):return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			if item.stack:
				emptyslots[0].amount = 1
	update_need_res.emit()
