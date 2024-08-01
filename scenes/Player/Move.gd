extends Node2D

@onready var b = $".."
@onready var body = $"../Skin"
@onready var skin = $"../Skin/Skin"

var down = load("res://sprites/Player/1.png")
var down_d = load("res://sprites/Player/2.png")
var horiz = load("res://sprites/Player/3.png")
var up = load("res://sprites/Player/4.png")

var current_state = St.l 
enum St {l, r, t, d, ld, rd, lt, rt}

func _ready():
	b.s = b.speed

func _process(delta):
	move()
	update_state()
	apply_state()

func move():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - body.global_position).normalized()
	#body.global_rotation_degrees = rad_to_deg(direction.angle()) + 90	
	b.velocity = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized() * b.s
	b.move_and_slide()

func update_state():
	var x_velocity = b.velocity.x
	var y_velocity = b.velocity.y
	
	if x_velocity != 0 and y_velocity != 0:
		if x_velocity > 0:
			current_state = St.rd if y_velocity > 0 else St.rt
		else:
			current_state = St.ld if y_velocity > 0 else St.lt
	elif x_velocity != 0:
		current_state = St.r if x_velocity > 0 else St.l
	elif y_velocity != 0:
		current_state = St.d if y_velocity > 0 else St.t

func apply_state():	
	var textures = {St.t: up, St.d: down, St.l: horiz, St.r: horiz, St.lt: up, St.rt: up, St.ld: down_d, St.rd: down_d}
	skin.texture = textures.get(current_state, skin.texture)
	body.scale.x = 1 if current_state in [St.l, St.ld, St.lt] else -1
