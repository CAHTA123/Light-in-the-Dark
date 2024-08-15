extends Node2D

@onready var body = $"../.."
@onready var _1 = $"../../Pause/Control/1"
@onready var _2 = $"../../Pause/Control/2"
@onready var _3 = $"../../Pause/Control/3"
@onready var skin = $"../../Skin/Skin/Weapon/shape/Skin"

var w
var a
var p
var s

var cur = 0
var item_on = []

func _ready():
	item_on.append(body.weapon.slot.item.name)
	item_on.append(body.pickaxe.slot.item.name)
	item_on.append(body.axe.slot.item.name)

	a = body.axe.slot.item
	w = body.weapon.slot.item
	p = body.pickaxe.slot.item
	s = body.shield.slot.item
	
	body.now_slot = item_on[cur]
	new_slots()

func _process(delta):
	if a != body.axe.slot.item or w != body.weapon.slot.item or p != body.pickaxe.slot.item or s != body.shield.slot.item:
		a = body.axe.slot.item
		w = body.weapon.slot.item
		p = body.pickaxe.slot.item
		s = body.shield.slot.item
		new_slots()

	if Input.is_action_just_pressed("X"):
		cur = (cur + 1) % item_on.size()
		body.now_slot = item_on[cur]
		new_slots()

	elif Input.is_action_just_pressed("Z"):
		cur = (cur - 1 + item_on.size()) % item_on.size()
		body.now_slot = item_on[cur]
		new_slots()

func new_slots():
	if body.weapon.slot.item and body.now_slot == item_on[0]:
		_2.texture = body.axe.slot.item.texture
		_3.texture = body.pickaxe.slot.item.texture
		_1.texture = body.weapon.slot.item.texture
		skin.texture = body.weapon.slot.item.texture
		for key in body.weapon.slot.item.character.keys():
			if key in body:
				body[key] = body.weapon.slot.item.character[key]
	else:
		for key in body.weapon.slot.item.character.keys():
			if key in body:
				body[key] = 0

	if body.pickaxe.slot.item and body.now_slot == item_on[1]:
		_3.texture = body.axe.slot.item.texture
		_1.texture = body.pickaxe.slot.item.texture
		_2.texture = body.weapon.slot.item.texture
		skin.texture = body.pickaxe.slot.item.texture
		for key in body.pickaxe.slot.item.character.keys():
			if key in body:
				body[key] = body.pickaxe.slot.item.character[key]
	else:
		for key in body.pickaxe.slot.item.character.keys():
			if key in body:
				body[key] = 0

	if body.axe.slot.item and body.now_slot == item_on[2]:
		_1.texture = body.axe.slot.item.texture
		_2.texture = body.pickaxe.slot.item.texture
		_3.texture = body.weapon.slot.item.texture
		skin.texture = body.axe.slot.item.texture
		for key in body.axe.slot.item.character.keys():
			if key in body:
				body[key] = body.axe.slot.item.character[key]
	else:
		for key in body.axe.slot.item.character.keys():
			if key in body:
				body[key] = 0

	if body.shield.slot.item:
		$"../../Skin/Skin/Shield/Skin".texture = body.shield.slot.item.texture
		for key in body.shield.slot.item.character.keys():
			if key in body:
				body[key] = body.shield.slot.item.character[key]
