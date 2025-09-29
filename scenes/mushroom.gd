extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var vel : int
const player = preload("res://scripts/player.tscn")
func _on_body_entered(body: CharacterBody2D) -> void:
	body.velocity.y = vel
	audio_stream_player_2d.play()
