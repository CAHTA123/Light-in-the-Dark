extends Node2D

@onready var body = $".."
@onready var weapon = $"../Skin/Weapon"
@onready var anim = $"../Anim"

var attack_cooldown: float = 0.5
var can_attack: bool = true

func _process(delta):
	print(can_attack)
	if Input.is_action_pressed("attack") and can_attack:
		attack()

func attack():
	can_attack = false
	anim.play("attack")  
		   
func _finished(anim_name):
	can_attack = true 
