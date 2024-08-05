extends Node2D

@onready var body = $"../../Body"
@onready var hp_bar = $"../../Body/hp_bar/hp_bar"

func _ready():
	body.hp = body.max_hp
	body.hp_bar = hp_bar

func _process(delta):
	if body.take_damage > 0 and not body.isBlocking:
		var d = body.take_damage
		body.take_damage = 0
		take(d)

func take(d):
	body.hp -= d
	var HP = (body.hp / body.max_hp) * 100
	body.hp_bar.value = HP
	if body.hp <= 0:
		body.destroy = true
