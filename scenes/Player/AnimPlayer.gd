extends Node2D

@onready var body = $"../Body"
@onready var anim = $Anim

func _ready():
	pass 


func _on_animation_animation_finished(anim_name):
	$"../Skills/shoot".can_attack = true
	body.move = true


func _on_animation_animation_started(anim_name):
	if anim_name == "dash":
		body.move = false
		body.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * 3000
