extends Node2D

@onready var spawn_area = get_node("Area2D")
var spawn = "res://scenes/Enemy/enemy.tscn"

func _ready():
	spawn_all()

func _process(delta):
	pass

func spawn_all():
	if spawn:
		var pos = random_point()
		var s = load(spawn).instantiate()
		s.global_position = pos
		get_parent().add_child(s)
		await get_tree().create_timer(1.0).timeout 
		spawn_all()

func random_point():
	var shape = spawn_area.get_node("CollisionShape2D").get_shape() 
	var circle_shape = shape as CircleShape2D
	var angle = randf_range(0, 2 * PI)
	var radius = circle_shape.radius * randf_range(0, 1)
	var x = radius * cos(angle) 
	var y = radius * sin(angle) / 4 * 3
	var point = Vector2(x, y)
	return spawn_area.to_global(point) 
