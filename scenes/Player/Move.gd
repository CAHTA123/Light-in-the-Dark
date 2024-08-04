extends Node2D

@onready var b = $".."
@onready var body = $"../Skin"
@onready var skin = $"../Skin/Skin"

var current_state = St.l 
enum St {l, r, t, d, ld, rd, lt, rt}

func _ready():
	b.s = b.speed

func _process(delta):
	if b.move:
		move()
	b.move_and_slide()

func move():
	#var mouse_pos = get_global_mouse_position()
	#var direction = (mouse_pos - body.global_position).normalized()
	b.velocity = Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * b.s
	if b.velocity.x > 0:
		body.scale.x = -1
	elif b.velocity.x < 0:
		body.scale.x = 1
