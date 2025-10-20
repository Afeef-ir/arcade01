extends Area2D

@onready var flag: AnimatedSprite2D = $Flag
@onready var base: Sprite2D = $Base
@onready var flag_sfx: AudioStreamPlayer2D = $FlagSfx

var activated = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	flag.hide()
	

func _on_body_entered(body):
	if body.is_in_group("Player") and not activated:
		flag_sfx.play()
		flag.show()
		activated = true
		body.spawn_position = global_position
		print("Checkpoint reached at:", global_position)
