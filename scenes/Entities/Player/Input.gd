extends CanvasLayer

@onready var intv = $"."

func _ready():
	intv.visible = false


func _on_убрать_pressed():
	intv.visible = false
	


func _on_вернуть_pressed():
	intv.visible = true
