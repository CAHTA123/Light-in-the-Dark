extends Node2D

func _on_area_2d_area_exited(area):
	var a = area
	var par = a.get_parent().get_parent()
	
	if par:
		par.take_push = 500
		par.center = global_position
