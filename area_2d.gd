extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_script() 
		if body.current_health < 100:
			body.current_health += 40
			queue_free()
