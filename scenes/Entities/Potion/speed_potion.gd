extends Area2D







func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.speed += 300
		$".".monitoring = false
		$".".visible = false
		await get_tree().create_timer(10).timeout
		body.speed -= 300
		queue_free()
