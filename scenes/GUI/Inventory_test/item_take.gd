extends Area2D

@export var item: Item

func _ready():
	print(item)
	$Sprite2D.texture = item.texture

func _on_body_entered(body):
	if body.name == "Player":
		body.inv.ins(item)
		queue_free()
