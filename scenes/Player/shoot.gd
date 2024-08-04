extends Node2D

@onready var body = $".."
@onready var weapon = $"../Skin/Weapon"
@onready var anim = $"../Anim"
@onready var skin = $"../Skin/Weapon/shape/Skin"

var attack_cooldown: float = 0.5
var can_attack: bool = true

func _process(delta):
	if Input.is_action_pressed("block"): 
		skin.texture = load("res://sprites/weapon/shield/SH1.png")
		weapon.visible = true
		body.isBlocking = true
	elif Input.is_action_just_pressed("attack") and can_attack:
		skin.texture = load("res://sprites/weapon/sword/S1.png")
		attack()
	elif can_attack:
		weapon.visible = false
		body.isBlocking = false

func attack():
	can_attack = false
	anim.play("attack")  
   
func _finished(anim_name):
	can_attack = true 
