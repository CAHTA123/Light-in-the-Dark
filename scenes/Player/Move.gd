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
	if b.s != 0 and b.move:
		move()
	update_state()
	apply_state()
	b.move_and_slide()

func move():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - body.global_position).normalized()
	var velocity = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized() * b.s
	b.velocity = velocity
	var collision = b.move_and_collide(velocity)
	if collision:
		print("1")
func update_state():
	var angle_to_mouse = (get_global_mouse_position() - body.global_position).angle()
	var angle = fmod(rad_to_deg(angle_to_mouse), 360) 
	
	if angle < 0: 
		angle += 360
	
	match angle:
		_ when angle < 22.5 or angle >= 337.5: current_state = St.r
		_ when angle < 67.5: current_state = St.rd
		_ when angle < 112.5: current_state = St.d
		_ when angle < 157.5: current_state = St.ld
		_ when angle < 202.5: current_state = St.l
		_ when angle < 247.5: current_state = St.lt
		_ when angle < 292.5: current_state = St.t
		_ when angle < 337.5: current_state = St.rt

func apply_state():
	var textures = {St.t: up, St.d: down, St.l: horiz, St.r: horiz, St.lt: up, St.rt: up, St.ld: down_d, St.rd: down_d}
	skin.texture = textures.get(current_state, skin.texture)
	body.scale.x = 1 if current_state in [St.l, St.ld, St.lt] else -1
