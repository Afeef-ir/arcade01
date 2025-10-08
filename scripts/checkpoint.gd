extends Area2D

var activated = false
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player") and not activated:
		activated = true
		body.spawn_position = global_position
		print("Checkpoint reached at:", global_position)
