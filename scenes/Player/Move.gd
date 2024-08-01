extends Node2D

@onready var b = $".."
@onready var body = $"../Skin"

func _ready():
	b.s = b.speed

func _process(delta):
	move()

func move():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - body.global_position).normalized()
	var target_angle = rad_to_deg(direction.angle()) + 90
	body.global_rotation_degrees = target_angle	
	
	b.velocity = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized() * b.s
	b.move_and_slide()
