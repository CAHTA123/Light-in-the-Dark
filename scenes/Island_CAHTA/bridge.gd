extends Area2D

var collision1 = null
var collision2 = null
var i1 = null
var i2 = null

func _on_body_entered(body):
	if body.name == "Player":
		collision1 = i1.get_node("StaticBody2D/CollisionPolygon2D")
		collision1.set_disabled.call_deferred(true)
		collision2 = i2.get_node("StaticBody2D/CollisionPolygon2D")
		collision2.set_disabled.call_deferred(true)

func _on_body_exited(body):
	if body.name == "Player":
		collision1 = i1.get_node("StaticBody2D/CollisionPolygon2D")
		collision1.set_disabled.call_deferred(false)
		collision2 = i2.get_node("StaticBody2D/CollisionPolygon2D")
		collision2.set_disabled.call_deferred(false)

func points(pos1, pos2):
	global_position = pos1
	var dis = pos1.distance_to(pos2)
	var rot = pos1.angle_to(pos2) 
	look_at(pos2)
	$CollisionShape2D.shape.size.y = 200.0
	$CollisionShape2D.shape.size.x = dis
	$CollisionShape2D.position.x = dis/2
