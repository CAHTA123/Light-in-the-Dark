extends Node2D

@onready var body = $"../../Body"
@onready var hp_bar = $"../../Body/hp_bar/hp_bar"
@onready var anim = $"../../Animations/Animation"

func _ready():
	body.hp = body.max_hp
	body.hp_bar = hp_bar

func _process(delta):
	if body.take_damage > 0 and not body.isBlocking:
		body.current_state = body.States.TAKEDAMAGE
		var d = body.take_damage
		body.take_damage = 0
		take(d)
	else:
		body.take_damage = 0

func take(d):
	anim.play("take_damage")
	body.hp -= d
	var HP = (body.hp / body.max_hp) * 100
	body.hp_bar.value = HP
	if body.hp <= 0:
		body.destroy = true
