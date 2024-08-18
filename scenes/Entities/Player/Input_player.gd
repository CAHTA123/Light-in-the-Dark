extends Node

@onready var body = $"../.."

## Событие взаимодействия с кем либо
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("dash") and body.action_object:
			body.action_object.action()
