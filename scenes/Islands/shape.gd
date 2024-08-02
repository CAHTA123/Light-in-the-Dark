extends Node2D

func _on_area_2d_area_exited(area):
	area.get_parent().get_parent().move = false
	area.get_parent().get_parent().velocity = Vector2.ZERO
	area.get_parent().get_parent().center = global_position
	area.get_parent().get_parent().take_push = 10

func _on_area_2d_area_entered(area):
	area.get_parent().get_parent().move = true
