extends Node2D

@onready var body = $".."
var isBlocking = false
var can = 0

func _ready():
	body.hp = body.max_hp
	body.hp_bar = $"../hp_bar"

func _process(delta):
	if body.take_damage > can:
		can = body.take_damage
		take()
	if Input.is_action_pressed("block"): 
		print(isBlocking)
		isBlocking = true
	else:
		isBlocking = false

func take():
	body.hp -= body.take_damage
	var HP = (body.hp / body.max_hp) * 100
	body.hp_bar.value = HP
	if body.hp <= 0:
		body.destroy = true
	body.take_damage = 0
	can = body.take_damage

func _on_Blocker_body_entered(body):
	if isBlocking:
		if body.is_in_group("enemy"):
			body.apply_damage(0)

