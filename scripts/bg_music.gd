extends AudioStreamPlayer2D
@onready var bg_music: AudioStreamPlayer2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_music.stream.loop = true
	bg_music.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
