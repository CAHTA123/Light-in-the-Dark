extends Control

var value = 100

func _process(delta):
	$Bar.value = value


func _on_area_2d_area_entered(area):
	value -= 20
