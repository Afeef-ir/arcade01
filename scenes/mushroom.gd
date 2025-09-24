extends Area2D
@export var vel : int
const player = preload("res://scripts/player.tscn")
func _on_body_entered(body: CharacterBody2D) -> void:
	body.velocity.y = vel
