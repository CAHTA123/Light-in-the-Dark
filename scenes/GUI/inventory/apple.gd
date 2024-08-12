extends CharacterBody2D

@export var inv: Inv
@export var item: InvItem

func _on_detector_body_entered(body):
	print("1")
	inv.insert(item)
	self.queue_free()
