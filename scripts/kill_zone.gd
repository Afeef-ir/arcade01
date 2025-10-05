extends Area2D


@onready var timer_2: Timer = $Timer2

func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group("Player"):
		$Timer2.start()
	

func _on_timer_2_timeout() -> void:
	get_tree().reload_current_scene()
