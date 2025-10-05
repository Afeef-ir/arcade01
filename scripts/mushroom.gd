extends Node2D

@onready var bounce_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var vel : int

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	body.velocity.y = vel
	bounce_sfx.play()
