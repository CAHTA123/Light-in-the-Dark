extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"

func _process(delta):
	if body.take_damage > 0 and not body.isBlocking:  #!!!!
		body.current_state = body.States.TAKEDAMAGE
		take(body.take_damage)
	else:
		body.take_damage = 0

func take(d):
	body.take_damage = 0
	anim.play("take_damage")
	body.hp -= d
	if body.hp <= 0:
		body.destroy = true
