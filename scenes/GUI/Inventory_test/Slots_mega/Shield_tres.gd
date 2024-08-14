extends Resource

class_name Shield

signal update

@export var i: Item

func ins(item: Item):
	i = item
	update.emit()
