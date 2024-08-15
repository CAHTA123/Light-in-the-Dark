extends Node2D

@onready var body = $"../.."

@onready var _1 = $"../../Pause/Control/1"
@onready var _2 = $"../../Pause/Control/2"
@onready var _3 = $"../../Pause/Control/3"

@onready var skin = $"../../Skin/Skin/Weapon/shape/Skin"


var cur = 0
var item_on = []
func _ready():	
	item_on.append(body.weapon.i.name)
	item_on.append(body.axe.i.name)
	item_on.append(body.pickaxe.i.name)
	
	body.now_slot = item_on[cur]
	new_slots()

func _process(delta):

	if Input.is_action_just_pressed("X"):
		cur = (cur + 1) % item_on.size()
		
		body.now_slot = item_on[cur]
		new_slots()

	elif Input.is_action_just_pressed("Z"):
		cur = (cur - 1 + item_on.size()) % item_on.size()
		body.now_slot = item_on[cur]
		new_slots()
	
	#if s_axe != body.axe.i.name:
		#s_axe = body.axe.i.name
		#new_slots()
	#if s_shield != body.shield.i.name:
		#s_shield = body.shield.i.name
		#new_slots()
	#if s_pickaxe != body.pickaxe.i.name:
		#s_pickaxe = body.pickaxe.i.name
		#new_slots()
	#if s_weapon != body.weapon.i.name:
		#s_weapon = body.weapon.i.name
		#new_slots()
	

func new_slots():
	if body.weapon.i and body.now_slot == item_on[0]:
		skin.texture = body.weapon.i.texture
		for key in body.weapon.i.character.keys():
			if key in body:
				body[key] = body.weapon.i.character[key]
	else:
		for key in body.weapon.i.character.keys():
			if key in body:
				body[key] = 0

	if body.pickaxe.i and body.now_slot == item_on[1]:
		skin.texture = body.pickaxe.i.texture
		for key in body.pickaxe.i.character.keys():
			if key in body:
				body[key] = body.pickaxe.i.character[key]
	else:
		for key in body.pickaxe.i.character.keys():
			if key in body:
				body[key] = 0

	if body.axe.i and body.now_slot == item_on[2]:
		skin.texture = body.axe.i.texture
		for key in body.axe.i.character.keys():
			if key in body:
				body[key] = body.axe.i.character[key]
	else:
		for key in body.axe.i.character.keys():
			if key in body:
				body[key] = 0

	if body.shield.i:
		$"../../Skin/Skin/Shield/Skin".texture = body.shield.i.texture
		for key in body.shield.i.character.keys():
			if key in body:
				body[key] = body.shield.i.character[key]
