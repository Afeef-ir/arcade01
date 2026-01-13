extends Area2D


@onready var pick_up_sfx: AudioStreamPlayer2D = $Pick_up_sfx


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_script() 
		if body.current_health < 100:
			body.current_health += 40
			hide()
			await get_tree().create_timer(1).timeout
			queue_free()
