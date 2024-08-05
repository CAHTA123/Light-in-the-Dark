extends Node2D

@onready var body = $"../Body"
@onready var anim = $Animation

func _ready():
	pass 


func _on_animation_animation_finished(anim_name):	
	if anim_name != "Idle":
		body.current_state = body.States.IDLE
		anim.play("Idle")

func _on_animation_animation_started(anim_name):
	pass
