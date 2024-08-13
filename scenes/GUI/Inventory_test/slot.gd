extends TextureRect

@onready var item = $Item/item
@onready var text = $Item/amount

func _get_drag_data(at_position):
	print(at_position)
	var p = TextureRect.new()
	p.texture = texture
	p.expand_mode = 1
	p.size = Vector2(64,64)
	var pr = Control.new()
	pr.add_child(p)
	pr.global_position = get_global_mouse_position()
	set_drag_preview(pr)
	
	#var drag_data = {}
	#drag_data["item"] = self  
	#drag_data["position"] = at_position
	#return drag_data
	return texture

func _can_drop_data(at_position, data):
	return data is Texture2D 
	
func _drop_data(at_position, data):
	texture = data

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
