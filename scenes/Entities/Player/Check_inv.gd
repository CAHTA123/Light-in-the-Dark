extends Node2D

@onready var body = $"../.."
@onready var skin = $"../../Skin/Skin/Weapon/shape/Skin"
@onready var controls = [$"../../Pause/Control/1", $"../../Pause/Control/2", $"../../Pause/Control/3"]

var item_on = []
var sh
var cur = 0

func _ready():
	update_item_list()
	body.now_slot = item_on[cur]
	new_slots()

func _process(delta):
	if has_item_changed():
		update_item_list()
		new_slots()
	handle_input()

func update_item_list():
	item_on.clear()
	item_on.append(body.weapon.slot.item)
	item_on.append(body.pickaxe.slot.item)
	item_on.append(body.axe.slot.item)
	sh = body.shield.slot.item

func has_item_changed():
	return body.weapon.slot.item != item_on[0] or body.pickaxe.slot.item != item_on[1] or body.axe.slot.item != item_on[2] or body.shield.slot.item != sh

func handle_input():
	if Input.is_action_just_pressed("X"):
		cur = (cur + 1) % item_on.size()
		new_slots()
	elif Input.is_action_just_pressed("Z"):
		cur = (cur - 1 + item_on.size()) % item_on.size()
		new_slots()
	body.now_slot = item_on[cur].name

func new_slots():
	var current_item = item_on[cur]
	update_textures(current_item)
	update_character_stats(current_item)

func update_textures(current_item):
	if current_item:
		for i in range(controls.size()):
			controls[i].texture = item_on[(i + cur) % item_on.size()].texture if item_on[i] else null
		skin.texture = current_item.texture if current_item else null

func update_character_stats(current_item):
	for key in current_item.character.keys():
		body[key] = current_item.character[key] if key in body else 0

