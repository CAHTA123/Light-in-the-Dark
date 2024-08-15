extends Node2D

@onready var body = $"../.."
@onready var anim = $"../../Anim/Anim"

func _process(delta):
	if body.take_damage > 0: 
		body.current_state = body.States.TAKEDAMAGE
		if body.isBlocking:
			body.take_damage = 0
		else:
			take(body.take_damage)


func take(d):
	body.take_damage = 0
	anim.play("take_damage")
	body.hp -= d
	if body.hp <= 0:
		body.destroy = true
