extends Node2D

var island
var has_bridge = true

func action():
	if has_bridge:
		has_bridge = false
		island.buy_island.emit($"..")

## Показать подсказку покупки
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Sale.visible = true
		if !body.action_object:
			body.action_object = $"."

## скрыть подсказку покупки
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Sale.visible = false
		body.action_object = null
