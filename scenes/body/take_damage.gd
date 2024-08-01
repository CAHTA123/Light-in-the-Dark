extends Node2D

@onready var body = $".."

func _ready():
	body.hp = body.max_hp

func _process(delta):
	if body.take_damage > 0:
		take()

func take():
	body.hp - body.take_damage
	body.take_damage = 0
	if body.hp <= 0:
		body.destroy = true
