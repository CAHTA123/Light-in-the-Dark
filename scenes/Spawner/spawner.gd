extends Node2D

var spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_all()
	
func spawn_all():
	if spawn:
		var pos 
		var s = load(spawn).instantiate()
		s.global_position = pos.global_position
		get_parent().add_child(s)
