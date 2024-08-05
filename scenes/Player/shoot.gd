extends Node2D

@onready var body = $"../../Body"
@onready var weapon = $"../../Body/Skin/Skin/Weapon"
@onready var skin = $"../../Body/Skin/Skin/Weapon/shape/Skin"
@onready var anim = $"../../Animations/Animation"

var attack_cooldown: float = 0.5
var can_attack: bool = true

func _process(delta):
	if Input.is_action_just_pressed("block") :
		anim.play("block")
		can_attack = false

	elif Input.is_action_just_pressed("attack"):
		anim.play("attack")
		can_attack = false

		
	elif can_attack:
		weapon.visible = false
		body.isBlocking = false
