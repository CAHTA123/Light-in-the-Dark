extends Node2D

@onready var body = $".."
@onready var weapon = $"../Skin/Weapon"
@onready var skin = $"../Skin/Weapon/shape/Skin"

var attack_cooldown: float = 0.5
var can_attack: bool = true

func _process(delta):
	if Input.is_action_pressed("block"): 
		skin.texture = load("res://sprites/weapon/shield/SH1.png")
		weapon.visible = true
		body.isBlocking = true

	elif Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		skin.texture = load("res://sprites/weapon/sword/S1.png")
		
	elif can_attack:
		weapon.visible = false
		body.isBlocking = false
