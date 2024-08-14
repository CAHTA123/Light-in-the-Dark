extends Node2D

@onready var body = $"../.."

func _ready():
	new_slots()

func _process(delta):
	if body.new_item:
		body.new_item = false
		new_slots()

func new_slots():
	print(2)
	if body.weapon.i:
		body.weapon_tex = body.weapon.i.texture
		print(body.weapon.i.texture)
		$"../../Skin/Skin/Weapon/shape/Skin".texture = body.weapon.i.texture
		for key in body.weapon.i.character.keys():
			if key in body:
				body[key] = body.weapon.i.character[key]

	if body.pickaxe.i:
		body.pickaxe_tex = body.pickaxe.i.texture
		$"../../Skin/Skin/Tool/Area2D/Skin".texture = body.weapon.i.texture
		for key in body.pickaxe.i.character.keys():
			if key in body:
				body[key] = body.pickaxe.i.character[key]

	if body.axe.i:
		body.axe_tex = body.axe.i.texture
		$"../../Skin/Skin/Tool/Area2D/Skin".texture = body.weapon.i.texture
		for key in body.axe.i.character.keys():
			if key in body:
				body[key] = body.axe.i.character[key]

	if body.shield.i:
		body.shield_tex = body.shield.i.texture
		$"../../Skin/Skin/Shield/Skin".texture = body.shield.i.texture
		for key in body.shield.i.character.keys():
			if key in body:
				body[key] = body.shield.i.character[key]
