extends Sprite2D
@onready var player = $"../Player"

@export var resurs: Resource
func _ready():
	texture = resurs.item.texture



func _on_area_2d_body_entered(body):
	body.inv.ins(resurs.item)
	queue_free()
