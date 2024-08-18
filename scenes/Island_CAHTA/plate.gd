extends Node2D

var bridge = "res://scenes/Island_CAHTA/bridge.tscn"
var pos
var rot
var most = false

func _process(delta):
	if Input.is_action_just_pressed("dash") and !most:
			most = true
			$"..".buy_island.emit($"..")
			var b = load(bridge).instantiate()
			#b.position = pos
			#b.rotation = deg_to_rad(rot)
			get_parent().add_child.call_deferred(b)
			

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Sale.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Sale.visible = false

func buy():
	most = true
