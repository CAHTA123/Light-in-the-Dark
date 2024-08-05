extends Node2D

@onready var body = $"../../Body"
@onready var SkinPlayer = $"../../Body/Skin"

func _ready():
	body.s = body.speed

func _process(delta):
	if body.move:
		move()
	body.move_and_slide()

func move():
	body.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * body.s
	
	if body.velocity.x > 0:
		SkinPlayer.scale.x = -1
	elif body.velocity.x < 0:
		SkinPlayer.scale.x = 1
