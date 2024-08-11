extends Node2D

@onready var body = $".."
@onready var anim = $Anim

func _on_animation_animation_finished(anim_name):
	body.current_state = body.States.IDLE
	anim.play("Idle")

func _on_animation_animation_started(anim_name):
	pass
