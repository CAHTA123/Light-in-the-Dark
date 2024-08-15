extends CanvasLayer

func _ready():
	visible = false

func _on_убрать_pressed():
	visible = false

func _on_вернуть_pressed():
	visible = true
