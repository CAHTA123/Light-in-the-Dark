extends Control

var value

func _ready():
	value = 100

func _process(delta):
	$Bar.value = value
