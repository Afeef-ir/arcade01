extends Area2D

@onready var label: Label = $Label
@onready var timer_3: Timer = $Timer3


@onready var timer: Timer = $Timer

func _ready() -> void:
	label.visible = false
func _on_body_entered(body: CharacterBody2D) -> void:
	$Timer3.start()
	
	label.visible = true





func _on_timer_2_timeout() -> void:
	get_tree().reload_current_scene()
	
