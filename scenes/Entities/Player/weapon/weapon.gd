extends Node2D

@onready var b = $"../../.."

func _on_shape_body_entered(body):
	if b.damage > 0:
		body.take_damage = b.damage
	if b.adamage > 0:
		body.take_damage = b.adamage
	if b.pdamage > 0:
		body.take_damage = b.pdamage
