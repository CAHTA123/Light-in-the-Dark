extends Node2D

@onready var body = $"../Body"
@onready var anim = $Anim

func _ready():
	pass 


func _on_animation_animation_finished(anim_name):
	if anim_name != "Idle":
		
		$"../Skills/shoot".can_attack = true
		body.move = true
		body.current_state = body.States.IDLE

func _on_animation_animation_started(anim_name):
	if anim_name == "dash":
		pass
		

