extends TextureRect

@onready var text = $Item/amount
var amount = ""

func _process(_delta):
	text.text = amount

