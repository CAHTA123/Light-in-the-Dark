extends Node2D

func _on_area_2d_area_exited(area):
	var a = area
	var par = a.get_parent().get_parent()
	
	if par:
		par.move = false
		par.velocity = Vector2.ZERO
		par.center = global_position
		par.take_push = 10

func _on_area_2d_area_entered(area):
	var a = area
	var par = a.get_parent().get_parent()	
	if par:
		par.move = true
