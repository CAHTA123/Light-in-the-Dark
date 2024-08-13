extends Panel

@onready var item = $CenterContainer/Panel/Item
@onready var text = $CenterContainer/Panel/Label

func update(slot: Slot):
	if !slot.item:
		item.visible = false
		text.visible = false
	else:
		item.visible = true
		item.texture = slot.item.texture
		if slot.amount > 1:
			text.visible = true
			text.text = str(slot.amount)
