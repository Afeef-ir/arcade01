extends Area2D

signal change_lvl

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var exit_pos : Vector2

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		body.global_position = exit_pos
		print("yeah")
