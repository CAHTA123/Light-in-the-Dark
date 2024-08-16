extends Area2D







func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.hp += 2
		$".".monitoring = false
		$".".visible = false
		await get_tree().create_timer(10).timeout
		queue_free()
