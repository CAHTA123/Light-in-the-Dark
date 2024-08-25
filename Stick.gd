extends Sprite2D
@onready var player = $"../Player"

@export var resurs: Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = resurs.item.texture
	if texture:
		print("feef")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	body.inv.ins(resurs.item)
	queue_free()
