extends Area2D

signal change_lvl

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		print("body_entered")
		print(4)
		emit_signal("change_lvl")
